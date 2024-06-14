
(defun my-buffer-identification (fmt)
  (list
    (propertize fmt 'face (if (let ((window (selected-window)))
                                (or (eq window (old-selected-window))
                                  (and (minibuffer-window-active-p (minibuffer-window))
                                    (with-selected-window (minibuffer-window)
                                      (eq window (minibuffer-selected-window))))))
                            (if (bound-and-true-p god-local-mode)
                              'error
                              '(:foreground "#7fdc59"))
                            'mode-line-buffer-id)
      'mouse-face
      'mode-line-highlight
      'local-map
      mode-line-buffer-identification-keymap)))

;; (setq-default mode-line-buffer-identification
;;               '(:eval (my-buffer-identification "%12b")))


(defvar buffer-filename-with-git-directory nil
  "Parent directory of the current directory.
This variable is nil if the current buffer isn't visiting a file.")

(make-variable-buffer-local 'buffer-filename-with-git-directory)
(put 'buffer-filename-with-git-directory 'permanent-local t)
(defun set-buffer-filename-with-git-directory ()
  (when buffer-file-name
    (setq buffer-filename-with-git-directory
      (or
        (when-let* ((buffer-file-truename buffer-file-truename)
                     (prj (cdr-safe (project-current)))
                     (prj-parent
                       (file-name-directory
                         (directory-file-name (expand-file-name prj)))))
          (concat (file-relative-name (file-name-directory buffer-file-truename) prj-parent)
            (file-name-nondirectory buffer-file-truename)))
        buffer-file-name))))

(add-hook 'find-file-hook 'set-buffer-filename-with-git-directory)

(setq-default mode-line-buffer-identification `(:eval (my-buffer-identification
                                                        (or buffer-filename-with-git-directory ""))))


(provide 'init-modeline)
