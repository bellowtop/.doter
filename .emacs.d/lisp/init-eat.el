;; -*- lexical-binding: t -*-
;;; init-eat.el --- Eat Terminal Configuration

;;; Commentary:
;;
;;  Terminal emulator configuration (replaces init-vterm.el)
;;

;;; Code:

(use-package eat
  :ensure t
  :commands eat
  :config

  (defun my-eat-copy-region (&optional arg)
    (interactive "p")
    (if (use-region-p)
        (kill-ring-save (region-beginning) (region-end))
      (save-excursion
        (copy-region-as-kill (line-beginning-position) (line-end-position)))))

  (defun my-eat-send-ctrl-c ()
    (interactive)
    (eat-self-input 1 ?\C-c))

  (setq eat-kill-buffer-on-exit t)
  (setq eat-scroll-to-bottom-on-output nil)
  ;; Batch terminal output updates to reduce redisplay overhead
  (setq eat-minimum-latency 0.008
        eat-maximum-latency 0.033)

  ;; Kill window when buffer is killed
  (defun my-eat-kill-window-on-buffer-kill ()
    (let ((window (get-buffer-window (current-buffer))))
      (when (and window
                 (window-parent window)
                 (seq-find (lambda (w)
                             (and (not (eq w window))
                                  (not (window-parameter w 'window-side))))
                           (window-list (window-frame window) 'no-mini)))
        (delete-window window))))

  (defun my-eat-setup-kill-window-hook ()
    (remove-hook 'kill-buffer-hook #'my-eat-kill-window-on-buffer-kill t)
    (add-hook 'kill-buffer-hook #'my-eat-kill-window-on-buffer-kill nil t))

  (add-hook 'eat-mode-hook #'my-eat-setup-kill-window-hook)

  ;; Legendary buffer management: eat/claude buffers are always legendary
  (defun my-toggle-legendary-buffer-for-eat (&optional arg)
    (when (derived-mode-p 'eat-mode)
      (my-add-to-legendary-buffers '("*eat" "*claude"))
      (refresh-current-mode)))

  (add-hook 'eat-mode-hook #'my-toggle-legendary-buffer-for-eat)

  ;; Semi-char mode keybindings
  (setq eat-enable-yank-to-terminal t)
  (define-key eat-semi-char-mode-map (kbd "M->") #'end-of-buffer)
  (define-key eat-semi-char-mode-map (kbd "M-<") #'beginning-of-buffer)
  (define-key eat-semi-char-mode-map (kbd "M-i") #'er/expand-region)

  (dolist (key '("M-h"  "M-l"))
    (let ((k key))
      (define-key eat-semi-char-mode-map (kbd k)
        (lambda ()
          (interactive)
          (eat-self-input 1 ?\M-h)))))

  (define-key eat-semi-char-mode-map (kbd "C-s-c") #'my-eat-send-ctrl-c)
  (keymap-unset eat-semi-char-mode-map "M-`")
  (keymap-unset eat-semi-char-mode-map "M-:")

  ;; In emacs-mode (semi-char off): C-s-c switches back and sends ctrl-c
  (define-key eat-mode-map (kbd "C-s-c")
    (lambda () (interactive)
      (eat-switch-to-semi-char-mode)
      (my-eat-send-ctrl-c)))

  ;; Return to bottom when switching back from emacs-mode to semi-char-mode
  (advice-add 'eat-switch-to-semi-char-mode :after
    (lambda (&rest _)
      (goto-char (point-max))))

  ;; When switching to a tab, scroll eat buffer to bottom
  (defun my-eat-scroll-to-bottom-on-tab-switch (&rest _)
    (let ((buf (window-buffer (selected-window))))
      (with-current-buffer buf
        (when (and (derived-mode-p 'eat-mode) eat--semi-char-mode)
          (goto-char (point-max))))))
  (advice-add 'tab-bar-select-tab :after #'my-eat-scroll-to-bottom-on-tab-switch)

  ;; Font/display setup for Claude Code flickering fix
  (defun diego--eat-font-setup ()
    (let ((tbl (or buffer-display-table (setq buffer-display-table (make-display-table)))))
      (dolist (pair '((#x273B . ?*) (#x273D . ?*) (#x2722 . ?+) (#x2736 . ?+) (#x2733 . ?*)))
        (aset tbl (car pair) (vector (cdr pair))))))

  (defun my-eat-nobreak-space-setup ()
    (face-remap-add-relative 'nobreak-space :underline nil))

  (add-hook 'eat-mode-hook #'diego--eat-font-setup)
  (add-hook 'eat-mode-hook #'my-eat-nobreak-space-setup)

  ;; Disable eat's built-in buffer renaming based on foreground process name
  (advice-add 'eat-update-buffer-name :override #'ignore)

;; Override eat ANSI colors to match ansi-color-names-vector (dark theme readable)
  (with-eval-after-load 'eat
    (custom-set-faces
      '(eat-term-color-0  ((t (:foreground "black"))))
      '(eat-term-color-1  ((t (:foreground "tomato"))))
      '(eat-term-color-2  ((t (:foreground "PaleGreen2"))))
      '(eat-term-color-3  ((t (:foreground "gold1"))))
      '(eat-term-color-4  ((t (:foreground "DeepSkyBlue1"))))
      '(eat-term-color-5  ((t (:foreground "MediumOrchid1"))))
      '(eat-term-color-6  ((t (:foreground "cyan"))))
      '(eat-term-color-7  ((t (:foreground "white"))))
      ;; Bright variants (8-15)
      '(eat-term-color-8  ((t (:foreground "gray50"))))
      '(eat-term-color-9  ((t (:foreground "tomato"))))
      '(eat-term-color-10 ((t (:foreground "PaleGreen2"))))
      '(eat-term-color-11 ((t (:foreground "gold1"))))
      '(eat-term-color-12 ((t (:foreground "DeepSkyBlue1"))))
      '(eat-term-color-13 ((t (:foreground "MediumOrchid1"))))
      '(eat-term-color-14 ((t (:foreground "cyan"))))
      '(eat-term-color-15 ((t (:foreground "white"))))))

  )


(provide 'init-eat)

;;; init-eat.el ends here
