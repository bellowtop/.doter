

;; for my-elisp-eldoc-var-docstring-with-value
;; (require 'my-utils)

(use-package eldoc
  :config
  (setq eldoc-echo-area-use-multiline-p 1)
  (setq eldoc-idle-delay 0.2)
  ;; show more doc in elisp mode
  (add-hook
    'emacs-lisp-mode-hook
    '(lambda () (add-to-list 'eldoc-documentation-functions 'elisp-eldoc-var-docstring-with-value)))
  (add-hook
    'lisp-mode-hook
    '(lambda () (add-to-list 'eldoc-documentation-functions 'elisp-eldoc-var-docstring-with-value))))

(use-package eldoc-box
  :config (setq eldoc-box-clear-with-C-g t)
  :commands (eldoc-box-help-at-point))

(provide 'init-eldoc)
