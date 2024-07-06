

;; (use-package
;;   flymake-posframe
;;   :load-path "~/.emacs.d/lisp/flymake-posframe.el"
;;   :hook (flymake-mode . flymake-posframe-mode))


(use-package flymake-diagnostic-at-point
  :load-path "~/.emacs.d/lisp/flymake-diagnostic-at-point.el"
  :after flymake
  :config
  (setq flymake-start-syntax-check-on-find-file nil)
  (setq flymake-diagnostic-at-point-error-prefix " > ")
  (setq flymake-diagnostic-at-point-display-diagnostic-function
    'flymake-diagnostic-at-point-display-posframe)
  (unless (display-graphic-p)
    (setq flymake-diagnostic-at-point-display-diagnostic-function
      'flymake-diagnostic-at-point-display-minibuffer))
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))


;;
;; deprecated, use flymake-posframe.
;;
;; (use-package flymake-diagnostic-at-point
;;   :after flymake
;;   :config
;;   (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))





(provide 'init-flymake)
