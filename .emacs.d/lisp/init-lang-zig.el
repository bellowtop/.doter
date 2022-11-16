
;;
;; hacks for zig-mode format.
;;
(defun my-zig-mode-hook ()
  (remove-hook 'before-save-hook 'zig-before-save-hook)
  (add-hook 'after-save-hook 'zig-before-save-hook)
  (add-hook 'after-revert-hook 'my-god-mode)
)
(add-hook 'zig-mode-hook 'my-zig-mode-hook)

;; trigger eglot
(add-hook 'zig-mode-hook 'eglot-ensure)

(provide 'init-lang-zig)
