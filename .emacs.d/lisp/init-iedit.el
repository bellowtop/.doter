;; -*- lexical-binding: t -*-
;;; init-iedit.el --- Iedit Configuration

;;; Commentary:
;;
;;  Multiple editing functionality
;;

;;; Code:

(use-package iedit
  :ensure t
  :bind (("C-M-'" . iedit-mode))
  :config
  (set-face-attribute 'iedit-occurrence nil :foreground "black" :background "yellow"))

(provide 'init-iedit)

;;; init-iedit.el ends here