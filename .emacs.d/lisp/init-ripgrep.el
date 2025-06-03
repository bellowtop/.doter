;; -*- lexical-binding: t -*-
;;; init-ripgrep.el --- Ripgrep Configuration

;;; Commentary:
;;
;;  Fast grep tool configuration
;;

;;; Code:

(defun my-ripgrep-kill-buffer()
  (interactive)
  (ripgrep/kill-buffer)
  (delete-window))

(use-package ripgrep
  :ensure t
  :config
  (set-face-attribute 'ripgrep-match-face nil :inherit 'my-highlight-font-words-face)
  :bind
  (:map ripgrep-search-mode-map
        (";" . scroll-up-command)
        ("'" . scroll-down-command)
        ("k" . previous-line)
        ("j" . next-line)
        ("x" . my-ripgrep-kill-buffer)))

(provide 'init-ripgrep)

;;; init-ripgrep.el ends here