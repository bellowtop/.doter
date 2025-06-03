;; -*- lexical-binding: t -*-
;;; init-srefactor.el --- SRefactor Configuration

;;; Commentary:
;;
;;  Semantic refactoring for C/C++ code
;;

;;; Code:

(use-package srefactor
  :ensure t
  :demand t
  :config
  (semantic-mode 1) ;; -> this is optional for Lisp
  (define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
  (define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point))

(provide 'init-srefactor)

;;; init-srefactor.el ends here