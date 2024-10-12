(setq cmake-project-default-build-dir-name "build/")
(require 'cmake-project)
(defun maybe-cmake-project-mode ()
  (if (or (file-exists-p "CMakeLists.txt")
          (file-exists-p (expand-file-name "CMakeLists.txt" (car (project-roots (project-current))))))
      (cmake-project-mode)))

(defvar my-cmake-project-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-c") 'compile)
    (define-key map (kbd "s-b") 'compile)

    map)
  "my-cmake-project-mode-map keymap.")

(add-hook 'cmake-project-mode-hook #'(lambda() (use-local-map my-cmake-project-mode-map)))

(provide 'init-cmake-project)
