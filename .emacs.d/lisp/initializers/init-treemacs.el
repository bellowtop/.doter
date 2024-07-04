(require 'fringe)

(use-package treemacs
  :init
  :config
  (setq treemacs-hide-gitignored-files-mode 1)
  (setq treemacs-space-between-root-nodes nil)
  (setq treemacs-show-hidden-files t)
  (setq treemacs-show-cursor t)
  (setq treemacs-persist-file (expand-file-name "~/.emacs.d/.local/treemacs-persist"))
  (setq treemacs-last-error-persist-file
    (expand-file-name "~/.emacs.d/.local/treemacs-persist-at-last-error"))
  (setq treemacs-expand-after-init nil)
  (setq treemacs-width-is-initially-locked nil)
  (treemacs-follow-mode 0)

  (global-set-key (kbd "C-c C-p") treemacs-project-map)
  (global-set-key (kbd "C-c C-w") treemacs-workspace-map)
  ;; (treemacs-resize-icons 26)

  (defun my-add-padding-for-treemacs ()
    (set-window-margins (treemacs-get-local-window) 1 1)
    (set-fringe-mode 0))

  (defun dim-treemacs-window-background ()
    (set (make-local-variable 'face-remapping-alist)
      '((default :background "#26282F"))))

  (defun my-decrease-treemacs-width ()
    (interactive)
    ;; call inner api
    (treemacs--set-width 25))

  (defun my-increase-treemacs-width ()
    (interactive)
    ;; call inner api
    (treemacs--set-width (/ (frame-width) 3)))

  (defun my-treemacs-mark-or-unmark-path-at-point()
    (interactive)
    (treemacs-mark-or-unmark-path-at-point)
    (next-line)
    )

  (defun my-treemacs-duplicate-current-file()
    (interactive)
    (let* ((source (treemacs--prop-at-point :path))
            (destination (treemacs--parent-dir source))
            (target-name (treemacs--filename source))
            (target (->> target-name
                      (treemacs-join-path destination)
                      (treemacs--find-repeated-file-name)))
            (copy-fn (if (file-directory-p source) #'copy-directory #'copy-file))
            )
      (funcall copy-fn source target)
      (treemacs-refresh)
      ))

  (defun my-treemacs-delete-marked-or-current-file-without-confirm()
    (interactive)
    (with-simulated-input ("yes" "RET")
      (if (eq treemacs--marked-paths nil)
        (treemacs-delete-file)
        (treemacs-delete-marked-paths)))
    (treemacs-refresh))

  (defun my-treemacs-copy-marked-files-without-confirm()
    (interactive)
    (with-simulated-input ("RET")
      (if (eq treemacs--marked-paths nil)
        (message "no marked files.")
        (treemacs-copy-marked-files)
        (treemacs-refresh))))


  (defun display-treemacs-widow-in-ace-window-selection ()
    (setq aw-ignored-buffers
      (delete 'treemacs-mode aw-ignored-buffers)))

  ;;;; custom highlight for treemacs current line
  (defface my-treemacs-custom-line-highlight
    '((t (:background "#59dcb7" :foreground "black" :weight normal)))
    "")
  (defun change-treemacs-hl-line-mode ()
    (setq-local hl-line-face 'my-treemacs-custom-line-highlight)
    (overlay-put hl-line-overlay 'face hl-line-face))


  ;; CAUTION: private api. copied from treemacs-core-utils.el
  ;; because i want _Copy1 instead of (Copy 1)
  (defun treemacs--find-repeated-file-name (path)
    "Find a fitting copy name for given file PATH.
Returns a name in the /file/name_Copy1.ext.  If that also already
exists it returns /file/name_Copy2.ext etc."
    (let* ((n 0)
            (dir (treemacs--parent-dir path))
            (filename (treemacs--filename path))
            (filename-no-ext (file-name-sans-extension path))
            (ext (--when-let (file-name-extension filename) (concat "." it)))
            (template "_Copy%d")
            (new-path path))
      (while (file-exists-p new-path)
        (cl-incf n)
        (setf new-path (treemacs-join-path dir (concat filename-no-ext (format template n) ext))))
      new-path))


  (add-hook 'treemacs-mode-hook #'my-add-padding-for-treemacs)
  (add-hook 'treemacs-mode-hook #'display-treemacs-widow-in-ace-window-selection)
  (add-hook 'treemacs-mode-hook #'dim-treemacs-window-background)
  (add-hook 'treemacs-mode-hook #'change-treemacs-hl-line-mode)
  (add-hook 'treemacs-mode-hook #'my-special-buffer-keys-minor-mode)
  ;; (add-hook 'treemacs-mode-hook #'my-set-bigger-spacing)
  :bind
  (:map
    treemacs-mode-map
    ("M" . my-treemacs-mark-or-unmark-path-at-point)
    ("U" . treemacs-reset-marks)
    ("H" . my-decrease-treemacs-width)
    ("L" . my-increase-treemacs-width)
    ("C-d" . my-treemacs-duplicate-current-file)
    ("C-y" . my-treemacs-copy-marked-files-without-confirm)
    ("D" . my-treemacs-delete-marked-or-current-file-without-confirm)
    ("a" . treemacs-create-file)
    ("n" . my-isearch-forward)
    ("N" . my-isearch-backward)
    ("A" . treemacs-create-dir)
    ;; add-hook no work????
    ;; ("<mouse-1>" . treemacs-single-click-expand-action)
    ("<double-mouse-1>" . treemacs-RET-action)
    ))


(with-eval-after-load 'treemacs
  (require 'treemacs-nerd-icons)

  (dolist
    (face '(treemacs-root-face
             treemacs-git-unmodified-face
             treemacs-git-modified-face
             treemacs-git-renamed-face
             treemacs-git-ignored-face
             treemacs-git-untracked-face
             treemacs-git-added-face
             treemacs-git-conflict-face
             treemacs-directory-face
             treemacs-directory-collapsed-face
             treemacs-file-face
             ;; treemacs-nerd-icons-file-face
             ;; treemacs-nerd-icons-root-face
             treemacs-tags-face))
    (set-face-attribute face nil
      :family "IBM Plex Mono"
      :weight 'normal
      :height 140
      :foreground "#C4C4C4"
      :underline nil
      :inherit 'unspecified))

  (when (display-graphic-p)
    (treemacs-load-theme "nerd-icons")
    ;; (require 'treemacs-all-the-icons)
    ;; (treemacs-load-theme "all-the-icons")
    ;; (require 'treemacs-compatibility)
    ;; (treemacs-load-all-the-icons-with-workaround-font "Segoe UI")
    )

  (unless (display-graphic-p)
    (treemacs-load-theme "nerd-icons")))



(defun my-treemacs-add-and-display-current-project ()
  (interactive)
  (with-selected-window (get-buffer-window (current-buffer))
    (treemacs-add-and-display-current-project))
  (treemacs-find-file)
  (treemacs-select-window)
  (when (display-graphic-p)
    (setq-local cursor-type 'box)))


(provide 'init-treemacs)
