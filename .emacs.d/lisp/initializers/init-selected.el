
(use-package selected
  :ensure t
  :commands selected-minor-mode

  :config
  (defun my-kill-region-and-insert-d-in-selected()
    (interactive)
    (kill-region (region-beginning) (region-end))
    (unless (bound-and-true-p god-local-mode)
      (insert-char ?d))
    )

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
           ("`" . my-wrap-region-with-back-quotes)
           ("d" . my-kill-region-and-insert-d-in-selected)
           ("C-d" . kill-region)
           )))

(selected-global-mode 1)


(defun my-toggle-selected-keybinding ()
  "add special keybindings for visual selected mode"
  (interactive)
  (unless (bound-and-true-p selected-region-active-mode)
    (setq my-visual-line-selection nil))
  (if (or (bound-and-true-p selected-region-active-mode)
        (bound-and-true-p vterm-copy-mode))
    (progn
      ;; only non-special buffer and vterm buffer need this timer.
      (when (or (my-god-this-is-normal-editor-buffer (buffer-name))
              (string= "*vterm*" (buffer-name)))
        (when (bound-and-true-p selected-active-timer)
          (cancel-timer selected-active-timer))
        (setq selected-active-timer (run-with-timer 0.05 nil #'(lambda ()
                                                                 (when (region-active-p)
                                                                   (remove-all-highlight)
                                                                   (my-disable-symbol-overlay-highlight)
                                                                   (my-disable-paren-highlight)
                                                                   (my-disable-eglot-highlight))))))

      )
    (progn
      (my-enable-eglot-highlight)
      (my-enable-symbol-overlay-highlight)
      (my-enable-paren-highlight))))

(setq selected-region-active-mode-hook #'my-toggle-selected-keybinding)


(provide 'init-selected)
