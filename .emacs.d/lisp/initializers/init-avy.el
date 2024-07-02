
(require 'avy)
(setq avy-keys (list ?a ?s ?d ?f ?g ?w ?e ?v ?m ?n ?i ?o ?h ?j ?k ?l ?\;))
(setq avy-background 't)
(add-to-list 'avy-ignored-modes 'treemacs-mode)


(advice-add 'avy-goto-word-0 :before
  (lambda (&rest r)
    (my-disable-code-intelligence)
    (when (bound-and-true-p hl-line-mode) (hl-line-mode 0))
    )
  '((name . "avy-start")))

;; avy aborted
(advice-add 'avy-handler-default :before
  (lambda (&rest r)
    (my-enable-code-intelligence)
    (when (boundp hl-line-mode) (hl-line-mode 1))
    )
  '((name . "avy-aborted-end")))
;; avy success
(advice-add 'avy-action-goto :before
  (lambda (&rest r)
    (my-enable-code-intelligence)
    (when (boundp hl-line-mode) (hl-line-mode 1))
    )
  '((name . "avy-success-end")))


(set-face-attribute 'avy-lead-face nil
  :background (face-background 'default)
  :foreground "#E20000")

(set-face-attribute 'avy-lead-face-0 nil
  :background (face-background 'default)
  :foreground "#FFB400")

(provide 'init-avy)
