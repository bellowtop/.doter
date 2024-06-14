(use-package treesit
  :demand t
  :custom
  (treesit-font-lock-level 4) ;; skittles highlighting
  :init
  (push '(css-mode . css-ts-mode) major-mode-remap-alist)
  (push '(sh-mode . bash-ts-mode) major-mode-remap-alist)
  (push '(python-mode . python-ts-mode) major-mode-remap-alist)
  (push '(js-json-mode . json-ts-mode) major-mode-remap-alist)
  ;; ;; js ts mode is not working yet.
  ;; (push '(javascript-mode . javascript-ts-mode) major-mode-remap-alist)
  ;; (push '(typescript-mode . typescript-ts-mode) major-mode-remap-alist)
  ;; ;; go-mode does not support treesitter yet.
  ;; (push '(go-mode . go-ts-mode) major-mode-remap-alist)
  (push '(c-mode . c-ts-mode) major-mode-remap-alist)
  (push '(c++-mode . c++-ts-mode) major-mode-remap-alist)
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-ts-mode)) ;; tell h file to c++-ts-mode
  (add-to-list 'auto-mode-alist '("\\.ros\\'" . lisp-mode)) ;; tell ros file to emacs lisp mode
  ;; (setq treesit-extra-load-path `( ,(expand-file-name "~/.emacs.d/.local/tree-sitter-grammars") ))
  )


;; invoke M-x treesit-auto-install-all to install treesit libs to ~/.emacs.d/tree-sitter/
(use-package treesit-auto
  :config (global-treesit-auto-mode))

(provide 'init-treesit)
