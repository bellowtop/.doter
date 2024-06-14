(setq mc/list-file (expand-file-name "~/.emacs.d/.local/.mc-lists.el"))
(setq mc/match-cursor-style nil)
(use-package multiple-cursors
  :ensure t
  :config
  :bind (("C-x C-n" . mc/mark-next-like-this) ("C-c C-SPC" . mc/edit-lines))
  :init
  (add-hook 'multiple-cursors-mode-enabled-hook #'my-disable-code-intelligence)
  (add-hook 'multiple-cursors-mode-disabled-hook #'my-enable-code-intelligence))

(use-package multiple-cursors-core
  :bind
  (:map
    mc/keymap
    ("TAB" . 'mc/cycle-forward)
    ("<backtab>" . 'mc/cycle-backward)
    ("RET" . 'newline)
    ;; give RET back to the newline function, use C-c C-c to exit
    ("C-c C-c" . 'multiple-cursors-mode)
    ;; exit
    ("C-x C-n" . 'my-mc/mark-next-like-this)
    ("C-x C-p" . 'my-mc/mark-previous-like-this)
    ("C-x C-a" . 'mc/mark-all-like-this)
    ("C-x C-s" . 'my-mc/skip-to-next-like-this)
    ("C-x C-r" . 'mc/skip-to-previous-like-this)
    ("C-x C-x" . 'mc/unmark-next-like-this)
    ("C-x C-d" . 'mc/unmark-previous-like-this)))


(defun my-mc/mark-next-like-this (arg)
  (interactive "p")
  (if (region-active-p)
    (message "run my-mc/mark-next-like-this")
    (er/mark-symbol))
  (mc/mark-next-like-this-word arg)
  ;; copy from .emacs.d/elpa/multiple-cursors-20230113.835/mc-mark-more.el
  (let ((end (if mark-active
               (max (mark) (point))
               (point)))
         furthest)
    (mc/for-each-fake-cursor
      (when (> (mc/cursor-end cursor) end)
        (setq end (mc/cursor-end cursor))
        (setq furthest cursor)))
    ;; if end point is not visible in window, then cycle to it.
    (or (pos-visible-in-window-p end (selected-window))
      (mc/cycle
        furthest
        (mc/first-fake-cursor-after (point-min))
        "We're already at the last cursor."))))


(defun my-mc/mark-previous-like-this (arg)
  (interactive "p")
  (if (region-active-p)
    (message "run my-mc/mark-previous-like-this")
    (er/mark-symbol))
  (mc/mark-previous-like-this-word arg)
  ;; copy from multiple-cursors-20211112.2223/mc-cycle-cursors.el
  (mc/cycle
    (mc/furthest-cursor-before-point)
    (mc/last-fake-cursor-before (point-max))
    "We're already at the last cursor"))


(defun my-mc/skip-to-next-like-this (arg)
  (interactive "p")
  ;; copy from multiple-cursors-20211112.2223/mc-cycle-cursors.el
  (mc/cycle
    (mc/furthest-cursor-before-point)
    (mc/last-fake-cursor-before (point-max))
    "We're already at the last cursor")
  (mc/skip-to-next-like-this)
  ;; copy from multiple-cursors-20211112.2223/mc-cycle-cursors.el
  (mc/cycle
    (mc/furthest-cursor-after-point)
    (mc/first-fake-cursor-after (point-min))
    "We're already at the last cursor."))

(provide 'init-multi-cursor)
