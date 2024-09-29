

;; enable mouse click in terminal
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

(global-set-key (kbd "<mouse-4>") #' (lambda () (interactive) (scroll-down 3)))
(global-set-key (kbd "<mouse-5>") #' (lambda () (interactive) (scroll-up 3)))

(defadvice xref-find-definitions-at-mouse
  (before nice-jumper activate)
  (nice-jumper--set-jump))


(defun my-mouse-find-definition-at-mouse ()
  (interactive)
  (mouse-set-point last-input-event)
  (xref-find-definitions-at-mouse last-input-event))

(define-key global-map (kbd "<s-mouse-1>") #'my-mouse-find-definition-at-mouse)
(define-key global-map (kbd "<s-mouse-3>") #'xref-go-back)

(define-key global-map (kbd "<M-mouse-1>") #'my-mouse-find-definition-at-mouse)
(global-unset-key [M-down-mouse-1])

(define-key global-map (kbd "<M-mouse-3>") #'xref-go-back)
(define-key global-map (kbd "<C-mouse-3>") #'xref-find-references-at-mouse)
(global-unset-key [C-down-mouse-3])
(global-unset-key [M-down-mouse-3])



;;;   ;;; swipe to go backward and forward
;;;   ;;;
;;;   (defun my-start-cold-down-wheel()
;;;     (my-unbind-swipe-actions)
;;;     (run-with-timer 1 nil #'(lambda()
;;;                                 (my-bind-swipe-actions))))
;;;
;;;   (defun my-swipe-backward-with-cold-down ()
;;;     (interactive)
;;;       (xref-go-back)
;;;       (recenter)
;;;       (my-start-cold-down-wheel))
;;;
;;;   (defun my-swipe-forward-with-cold-down ()
;;;     (interactive)
;;;       (xref-go-forward)
;;;       (recenter)
;;;       (my-start-cold-down-wheel))
;;;
;;;   (defun my-unbind-swipe-actions ()
;;;     (global-unset-key [wheel-left])
;;;     (global-unset-key [wheel-right])
;;;     )
;;;
;;;   (defun my-bind-swipe-actions ()
;;;     (define-key global-map (kbd "<wheel-left>") 'my-swipe-backward-with-cold-down)
;;;     (define-key global-map (kbd "<wheel-right>") 'my-swipe-forward-with-cold-down)
;;;     )
;;;
;;;   (when (my-system-type-is-darwin)
;;;     (my-bind-swipe-actions)
;;;   )


;;; right click to open context-menu. disable mouse-3 to disable region behavior, which is annoying!
;;;
(global-unset-key [mouse-3])
(add-hook 'prog-mode-hook 'context-menu-mode)

(provide 'init-mouse)
