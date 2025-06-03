;; -*- lexical-binding: t -*-
;;; init-tabby.el --- Tabby Configuration

;;; Commentary:
;;
;;  Tabby AI completion configuration
;;

;;; Code:

(use-package tabby
  :ensure nil
  :demand t
  :config
  (add-hook 'python-ts-mode-hook 'tabby-mode)
  (define-key tabby-completion-map (kbd "M-<tab>") 'tabby-accept-completion))

(provide 'init-tabby)

;;; init-tabby.el ends here