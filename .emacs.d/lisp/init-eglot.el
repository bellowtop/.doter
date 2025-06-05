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
  ;; Face configuration for diagnostics
  (set-face-attribute 'eglot-diagnostic-tag-unnecessary-face nil
                      :underline nil
                      :foreground "yellow")
  (set-face-attribute 'eglot-diagnostic-tag-deprecated-face nil
                      :underline nil
                      :strike-through nil
                      :foreground "yellow")

  ;; Server configurations for specific languages
  (setq-default eglot-workspace-configuration
                '((gopls (usePlaceholders . t))))

  ;; Configure clangd parameters
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode c++-ts-mode c-ts-mode) . ("clangd"
                                                            "--compile-commands-dir=build"
                                                            ;; "--background-index"
                                                            "--header-insertion=never"
                                                            "--log=error"
                                                            ))
               )
  (add-to-list 'eglot-server-programs
             '((go-mode go-ts-mode) . ((:gopls . ((completeUnimported . :json-false))))))

  ;; Swift-specific server configuration
  (add-to-list 'eglot-server-programs '(swift-mode . ("xcrun" "sourcekit-lsp")))

  ;; Swift mode hook with special handling for .swiftinterface files
  (defun my-swift-eglot-hook ()
    (if (string= (file-name-extension buffer-file-name) "swiftinterface")
        (message "swift interface files ignored by eglot.")
      (eglot-ensure)))
  (add-hook 'swift-mode-hook #'my-swift-eglot-hook)

  ;; Don't interfere with company configuration
  (setq eglot-stay-out-of '(company))

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
  (setq sideline-backends-right '(sideline-eglot     ; `eglot'
                                  sideline-flymake)  ; `eglot' uses `flymake' by default
        sideline-eglot-code-actions-prefix "-> "))

(provide 'init-eglot)

;;; init-eglot.el ends here
