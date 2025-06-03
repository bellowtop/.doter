;; -*- lexical-binding: t -*-
;;; init-cmake-project.el --- CMake Project Configuration

;;; Commentary:
;;
;;  CMake project management and cmake-ts-mode configuration
;;

;;; Code:

(use-package cmake-project
  :ensure t
  :config
  (setq cmake-project-default-build-dir-name "build/")

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

  (add-hook 'cmake-project-mode-hook #'(lambda() (use-local-map my-cmake-project-mode-map))))

(use-package cmake-ts-mode
  :ensure nil  ; Built-in with Emacs 29+
  :hook (cmake-ts-mode . my-cmake-ts-mode-hook)
  :config
  (defun my-cmake-ts-mode-hook ()
    (setq cmake-tab-width 4)
    (bind-keys
     :map cmake-ts-mode-map
     ("C-c C-b" . compile)
     ("s-b" . compile))))

(provide 'init-cmake-project)

;;; init-cmake-project.el ends here
