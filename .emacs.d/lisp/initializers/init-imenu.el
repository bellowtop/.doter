

;; imenu size sidebar width, 0.20 of screen
;; NOTE: <SPC>-i to toggle imenu sidebar
(setq imenu-list-size 0.20)
(setq imenu-list-auto-update nil)

(defun my-enlarge-imenu-width ()
  (interactive)
  (enlarge-window-horizontally (/ (frame-width) 3)))

(defun my-shrink-imenu-width ()
  (interactive)
  (shrink-window-horizontally (/ (frame-width) 3)))

(defun my-fit-imenu-width ()
  (interactive)
  (imenu-list-resize-window))

(defun my-imenu-list-check-window-is-open ()
  (interactive)
  (and
    (bound-and-true-p imenu-list-buffer-name)
    (get-buffer-window imenu-list-buffer-name t)
    t))


(defun my-imenu-list-smart-toggle-refresh ()
  (interactive)
  (when (my-imenu-list-check-window-is-open)
    (imenu-list-quit-window))
  (imenu-list-minor-mode 1)
  (select-window (get-buffer-window (imenu-list-get-buffer-create))))

(use-package imenu-list
  :defer t
  :bind ((:map
           imenu-list-major-mode-map
           ("H" . my-enlarge-imenu-width)
           ("M" . my-fit-imenu-width)
           ("L" . my-shrink-imenu-width)
           ("m" . my-imenu-list-smart-toggle-refresh))))

(provide 'init-imenu)
