;; -*- lexical-binding: t -*-
;;; init-lang-yaml.el --- YAML Language Configuration

;;; Commentary:
;;
;;  YAML file format support
;;

;;; Code:

(use-package yaml-mode
  :ensure t
  :hook
  (yaml-mode . display-line-numbers-mode)
  (yaml-ts-mode . display-line-numbers-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yml\\.j2\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\.j2\\'" . yaml-mode)))

(provide 'init-lang-yaml)

;;; init-lang-yaml.el ends here