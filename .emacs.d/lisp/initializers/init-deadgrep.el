(defun my-deadgrep-edit-enter ()
  (interactive)
  (my-disable-code-intelligence)
  (refresh-current-mode)
  (remove-hook 'before-save-hook #'delete-trailing-whitespace)
  (remove-hook 'switch-buffer-functions #'my-god-mode-with-switch-any-buffer))


(defun my-deadgrep-edit-exit ()
  (interactive)
  (my-enable-code-intelligence)
  (refresh-current-mode)
  (add-hook 'before-save-hook #'delete-trailing-whitespace)
  (add-hook 'switch-buffer-functions #'my-god-mode-with-switch-any-buffer)
  (deadgrep-mode))


(use-package deadgrep
  :ensure t
  :config
  (setq-default deadgrep--context (cons 3 3))
  (setq-default deadgrep-max-line-length 2000)
  :bind
  (("C-c g" . deadgrep)
    :map
    deadgrep-mode-map
    ("RET" . deadgrep-visit-result)
    ("o" . deadgrep-visit-result-other-window)
    ("v" . (lambda ()
             (interactive)
             (deadgrep-visit-result-other-window)
             (other-window 1)))
    ("S" . deadgrep-search-term)
    ("D" . deadgrep-directory)
    ("g" . deadgrep-restart)
    ("n" . deadgrep-forward-match)
    ("r" . deadgrep-backward-match)
    ("p" . deadgrep-backward-match)
    ("N" . deadgrep-forward-filename)
    ("P" . deadgrep-backward-filename)
    ("C-c C-q" . deadgrep-edit-mode)
    :map
    deadgrep-edit-mode-map
    ("C-c C-c" . my-deadgrep-edit-exit))
  :hook (deadgrep-edit-mode . my-deadgrep-edit-enter)
  :init
  (advice-add 'deadgrep-visit-result :after 'xref-pulse-momentarily)
  (advice-add 'deadgrep-visit-result :after 'my-delete-other-windows)
  (advice-add 'deadgrep-visit-result-other-window :after 'xref-pulse-momentarily)
  (advice-add 'deadgrep-edit-mode :after 'xref-pulse-momentarily)
  (advice-add 'deadgrep--arguments :filter-return #'deadgrep--include-args)
)


(defun deadgrep--include-args (rg-args)
  (push "--hidden" rg-args) ;; consider hidden folders/files
  (push "--follow" rg-args) ;; follow symlink
  (push "--glob=!.git" rg-args)
  )


(provide 'init-deadgrep)
