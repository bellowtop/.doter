
(use-package selected
  :ensure t
  :commands selected-minor-mode
  :bind ((:map
           selected-keymap
           ("C-c i" . clang-format-region)
           ("C-c f" . clang-format-buffer)
           ("(" . my-wrap-region-with-parens)
           ("[" . my-wrap-region-with-brackets)
           ("{" . my-wrap-region-with-braces)
           ("'" . my-wrap-region-with-single-quotes)
           ("\"" . my-wrap-region-with-double-quotes)
           ("_" . my-wrap-region-with-underscores)
           ("`" . my-wrap-region-with-back-quotes))))

(selected-global-mode 1)


(defun my-toggle-selected-keybinding ()
  "add special keybindings for visual selected mode"
  (interactive)
  (if (bound-and-true-p selected-region-active-mode)
    (progn
      ;; only non-special buffer need this timer.
      (when (my-god-this-is-normal-editor-buffer (buffer-name))
        (when (bound-and-true-p selected-active-timer)
          (cancel-timer selected-active-timer))
        (setq selected-active-timer (run-with-timer 0.05 nil #'(lambda ()
                                                                 (when (region-active-p)
                                                                   (remove-all-highlight)
                                                                   (my-disable-symbol-overlay-highlight)
                                                                   (my-disable-paren-highlight)
                                                                   (my-disable-eglot-highlight))))))

      (if (bound-and-true-p my-god-mode-is-active-flag)
        (progn
          ;; (message "god mode, & selected-region-active mode")
          ;; (define-key selected-keymap (kbd "i p") #'er/mark-text-paragraph)
          ;; (define-key selected-keymap (kbd "i w") #'er/mark-symbol)
          ;; (define-key selected-keymap (kbd "v") #'keyboard-quit)
          (define-key selected-keymap (kbd "d") #'kill-region)
          ;; (define-key selected-keymap (kbd "x") #'kill-region)
          ;; (define-key selected-keymap (kbd "C-n") #'my-mc/mark-next-like-this)
          ;; (define-key selected-keymap (kbd "C-p") #'my-mc/mark-previous-like-this)
          )
        (progn
          ;; (message "not god mode, & selected-region-active mode")
          ;; (message "is not god-local-mode")
          ;; (define-key selected-keymap (kbd "i p") nil)
          ;; (define-key selected-keymap (kbd "i w") nil)
          ;; (define-key selected-keymap (kbd "v") nil)
          ;; (define-key selected-keymap (kbd "d") nil)
          ;; (define-key selected-keymap (kbd "x") nil)
          ;; (define-key selected-keymap (kbd "C-n") nil)
          ;; (define-key selected-keymap (kbd "C-p") nil)
          )))
    (progn
      ;; (message "not selected-region-active mode")
      (my-enable-eglot-highlight)
      (my-enable-symbol-overlay-highlight)
      (my-enable-paren-highlight))))

(setq selected-region-active-mode-hook #'my-toggle-selected-keybinding)


(provide 'init-selected)
