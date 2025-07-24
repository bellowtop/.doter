;; -*- lexical-binding: t -*-
;;; init-eglot.el --- Language Server Protocol client eglot configuration

;;; Commentary:
;;
;;  Language Server Protocol Emacs Client Eglot
;;

;;; Code:

;; Increase the amount of data which Emacs reads from the process
(when (bound-and-true-p read-process-output-max)
  (setq read-process-output-max (* 1024 1024)))

(use-package eglot
  :ensure t
  :commands (eglot eglot-ensure)
  :hook
  ;; Enable eglot for various programming languages
  ((c-ts-mode c++-ts-mode) . eglot-ensure)
  ((go-mode go-ts-mode) . eglot-ensure)
  (python-ts-mode . eglot-ensure)
  (zig-mode . eglot-ensure)
  (tsx-ts-mode . eglot-ensure)
  ((rust-mode rust-ts-mode) . eglot-ensure)
  :config

  (defvar my-eglot-ensure-is-enabled t
  "控制是否允许 eglot-ensure 实际运行。")
  (defun my-toggle-eglot-ensure () (interactive) (setq my-eglot-ensure-is-enabled (not my-eglot-ensure-is-enabled)))
  (defun my/around-eglot-ensure (orig-fun &rest args)
    "根据开关决定是否真正调用 eglot-ensure。"
    (if my-eglot-ensure-is-enabled
        (apply orig-fun args)
      (message "[Eglot] eglot-ensure 已被阻止，使用 symbol-overlay-mode 代替高亮")
      (symbol-overlay-mode 1)
      ))
  (advice-add 'eglot-ensure :around #'my/around-eglot-ensure)

  ;; Face configuration moved to custom-set-faces

  ;; Server configurations for specific languages
  (setq-default eglot-workspace-configuration
                '((gopls (usePlaceholders . t))))

  ;; Configure gopls
  (add-to-list 'eglot-server-programs
             '(go-ts-mode . ("gopls")))

  ;; Configure clangd parameters
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode c++-ts-mode c-ts-mode) . ("clangd"
                                                            "--compile-commands-dir=build"
                                                            ;; "--background-index"
                                                            "--header-insertion=never"
                                                            "--log=error"
                                                            ))
               )
  ;; Swift-specific server configuration
  (add-to-list 'eglot-server-programs '(swift-mode . ("xcrun" "sourcekit-lsp")))

  ;; Java configuration
  (setq jdt-language-server-latest-dir (expand-file-name "~/.emacs.d/.local/jdt-language-server-latest"))
  (setq jdt-language-server-workspaces (expand-file-name "~/.emacs.d/.local/jdt-language-server-workspaces"))
  (add-to-list 'eglot-server-programs
    `(java-ts-mode .
       (,(file-name-concat jdt-language-server-latest-dir "bin" "jdtls")
         "-configuration"
         ,(file-name-concat jdt-language-server-latest-dir "config_mac_arm")
         "-data"
         ,(file-name-concat
            jdt-language-server-workspaces
            (file-name-base (directory-file-name (project-root (eglot--current-project))))
            ))))

  ;; 自定义查找引用行为：不包含定义
  (cl-defmethod xref-backend-references ((_backend (eql eglot)) _identifier)
    (or
      eglot--lsp-xref-refs
      (eglot--lsp-xrefs-for-method
        :textDocument/references
        :extra-params `(:context (:includeDeclaration :json-false)))))

  ;; Swift mode hook with special handling for .swiftinterface files
  (defun my-swift-eglot-hook ()
    (if (string= (file-name-extension buffer-file-name) "swiftinterface")
        (message "swift interface files ignored by eglot.")
      (eglot-ensure)))
  (add-hook 'swift-mode-hook #'my-swift-eglot-hook)

  ;; Don't interfere with company configuration
  (setq eglot-stay-out-of '(company))
  ;; Don't show indicator
  (setq eglot-code-action-indicator "")

  ;; Performance and behavior settings
  (setq eglot-autoshutdown t
        eglot-ignored-server-capabilities '(:foldingRangeProvider)
        ;; Drop jsonrpc log to improve performance
        eglot-events-buffer-size 1)

  ;; Disable inlay hints by default
  (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1))))

(use-package sideline
  :ensure t
  :after eglot
  :hook (prog-mode . sideline-mode)
  :config
  (setq sideline-backends-right '(;; sideline-eglot     ; `eglot'
                                  sideline-flymake)     ; `eglot' uses `flymake' by default
        sideline-eglot-code-actions-prefix "-> ")
  )

(use-package sideline-flymake
  :ensure t
  :after sideline
  :config
  ;; Face configuration moved to custom-set-faces
  )

(provide 'init-eglot)

;;; init-eglot.el ends here
