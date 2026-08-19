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
    ;; No-op without a region, matching native terminal Cmd-C semantics
    (when (use-region-p)
      (kill-ring-save (region-beginning) (region-end))))

  (defun my-eat-send-ctrl-c ()
    (interactive)
    (eat-self-input 1 ?\C-c))


  (defun my-eat-clear-scrollback ()
    "Clear Eat's screen and scrollback, like Terminal's Cmd-K, then
  redraw the shell prompt (\\C-l)."
    (interactive)
    (unless eat-terminal
      (user-error ""))
    (let ((cmd (ignore-errors
                 (format "%s" (process-command
                                (get-buffer-process (current-buffer)))))))
      (unless (string-match-p
                "\\<\\(zsh\\|bash\\|sh\\|fish\\|nu\\|elvish\\|ksh\\)\\>"
                cmd)
        (user-error "Refusing to clear scrollback: %s" (or cmd "no process"))
        ))
    (let ((inhibit-read-only t)
           (inhibit-modification-hooks t)
           (buffer-undo-list t))
      (eat-term-process-output eat-terminal "\e[3J")
      (eat-term-redisplay eat-terminal))
    (eat-term-send-string eat-terminal "\C-l"))

  (setq eat-kill-buffer-on-exit t)
  (setq eat-scroll-to-bottom-on-output nil)
  ;; Latency is read per-buffer (eat--filter references them in the
  ;; process buffer, so setq-local wins).  Interactive shells render
  ;; echo immediately; Claude Code's streaming output keeps the default
  ;; batching (8–33ms) to limit redisplay cost and flicker.
  (defun my-eat-set-latency ()
    (if (string-match-p "\\*claude" (buffer-name))
        (progn
          (setq-local eat-minimum-latency 0.008)
          (setq-local eat-maximum-latency 0.033))
      (setq-local eat-minimum-latency 0)
      (setq-local eat-maximum-latency 0)))
  (add-hook 'eat-mode-hook #'my-eat-set-latency)

  ;; Kill window when buffer is killed
  (defun my-eat-kill-window-on-buffer-kill ()
    (let ((window (get-buffer-window (current-buffer))))
      (if (and window
              (window-parent window)
              (seq-find (lambda (w)
                          (and (not (eq w window))
                            (not (window-parameter w 'window-side))))
                (window-list (window-frame window) 'no-mini)))
        (delete-window window)
        ;; Only window in frame: kill-buffer-hook runs before
        ;; replace-buffer-in-windows, so switch away first to prevent
        ;; switch-to-prev-buffer from guessing a buffer.  *scratch* is
        ;; normally skipped by switch-to-prev-buffer-skip (name starts
        ;; with `*'), hence the explicit switch.
        (when window
          (set-window-buffer window (get-buffer-create "*scratch*"))))))

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

  ;; f1~f9
  (cl-loop for num from 1 to 9
    for key-str = (format "<f%d>" num)
    do (define-key eat-semi-char-mode-map (kbd key-str) 'eat-self-input))

  (dolist (key '("M-h" "M-l" "M-o"))
    (let ((k key))
      (define-key eat-semi-char-mode-map (kbd k) 'eat-self-input)))

  (define-key eat-semi-char-mode-map (kbd "C-s-c") #'my-eat-send-ctrl-c)
  (define-key eat-semi-char-mode-map (kbd "s-k") #'my-eat-clear-scrollback)
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
