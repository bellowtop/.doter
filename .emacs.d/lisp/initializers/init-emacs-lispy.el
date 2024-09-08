

(use-package lispy
  :hook (emacs-lisp-mode . lispy-mode)
  :config
  (setcdr lispy-goto-mode-map nil)
  (setcdr lispy-other-mode-map nil)
  (setcdr lispy-mode-map nil)
  (setcdr lispy-mode-map-oleh nil)
  (setcdr lispy-mode-map-base nil)
  (setcdr lispy-mode-map-lispy nil)
  (setcdr lispy-mode-map-evilcp nil)
  (setcdr lispy-mode-map-special nil)
  (setcdr lispy-mode-map-paredit nil)
  (setcdr lispy-mode-map-parinfer nil)
  (setcdr lispy-mode-map-c-digits nil)
  (define-key lispy-mode-map (kbd "M") 'special-lispy-alt-multiline)
  (define-key lispy-mode-map (kbd "s-m") 'special-lispy-alt-multiline)
  (define-key lispy-mode-map (kbd "s-j") 'lispy-down)
  (define-key lispy-mode-map (kbd "s-k") 'lispy-up))


(use-package elisp-autofmt
  :hook (emacs-lisp-mode . elisp-autofmt-mode)
  :config
  (setq elisp-autofmt-style 'fixed)
  (setq elisp-autofmt-format-quoted nil))


(use-package symbol-overlay
  :hook (emacs-lisp-mode . symbol-overlay-mode)
  :config
  (set-face-attribute 'symbol-overlay-default-face nil :inherit 'my-highlight-font-words-face)
)


(provide 'init-emacs-lispy)
