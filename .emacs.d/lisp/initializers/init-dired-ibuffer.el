(defun my-ibuffer-hook ()
  ;; add another sorting method for ibuffer (allow the grouping of
  ;; filenames and dired buffers
  (define-ibuffer-sorter
    filename-or-dired
    "Sort the buffers by their pathname."
    (:description "filenames plus dired")
    (string-lessp
      (with-current-buffer (car a)
        (or buffer-file-name
          (if (eq major-mode 'dired-mode)
            (expand-file-name dired-directory))
          ;; so that all non pathnames are at the end
          "~"))
      (with-current-buffer (car b)
        (or buffer-file-name
          (if (eq major-mode 'dired-mode)
            (expand-file-name dired-directory))
          ;; so that all non pathnames are at the end
          "~"))))
  (define-key
    ibuffer-mode-map
    (kbd "s p")
    'ibuffer-do-sort-by-filename-or-dired)
  ;; sort now please!
  (ibuffer-do-sort-by-filename-or-dired))

(add-hook 'ibuffer-mode-hook 'my-ibuffer-hook)

(with-eval-after-load 'dired
  (setq dired-dwim-target t))

(provide 'init-dired-ibuffer)
