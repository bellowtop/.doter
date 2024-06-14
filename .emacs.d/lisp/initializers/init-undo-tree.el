
(use-package undo-tree
  :config
  (setq undo-tree-history-directory-alist
    '(("." . "~/.emacs.d/.local/.undo-tree-files")))
  (setq undo-tree-auto-save-history nil)
  :init
  (add-hook 'prog-mode-hook #'undo-tree-mode)
  (add-hook 'cmake-mode-hook #'undo-tree-mode)
  (add-hook 'conf-mode-hook #'undo-tree-mode)
  (add-hook 'markdown-mode-hook #'undo-tree-mode) ;; these modes are not prog mode...
  (advice-add
    #'undo-tree-load-history
    :around #'radian--undo-tree-suppress-buffer-modified-message))

;; (global-undo-tree-mode)

;; Suppress the message saying that the undo history file was
;; saved (because this happens every single time you save a file).
(defun radian--undo-tree-suppress-undo-history-saved-message
  (undo-tree-save-history &rest args)
  (let ((inhibit-message t))
    (apply undo-tree-save-history args)))

;; Suppress the message saying that the undo history could not be
;; loaded because the file changed outside of Emacs.
(defun radian--undo-tree-suppress-buffer-modified-message
  (undo-tree-load-history &rest args)
  (let ((inhibit-message t))
    (apply undo-tree-load-history args)))


(provide 'init-undo-tree)
