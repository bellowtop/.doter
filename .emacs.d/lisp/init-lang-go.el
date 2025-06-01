;; -*- lexical-binding: t -*-
;;; init-lang-go.el --- Go Lang Config

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Go Lang Config
;;

;;; Code:

;; Install gopls
;; https://github.com/golang/tools/blob/master/gopls/doc/user.md#installation

(defun my-gofmt-before-save ()
  "Format Go code before saving."
  (interactive)
  (when (or (eq major-mode 'go-mode)
            (eq major-mode 'go-ts-mode))
    (gofmt)))

(defun my-go-mode-hook ()
  "Hook for Go mode configuration."
  (require 'go-mode)
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'my-gofmt-before-save nil t)
  (ignore-errors (indent-guide-global-mode -1))

  (with-eval-after-load 'exec-path-from-shell
    (exec-path-from-shell-copy-envs '("GOPATH" "GO111MODULE" "GOPROXY")))

  (setq go-ts-mode-indent-offset 4)

  ;; Key bindings
  (if (eq major-mode 'go-mode)
      (define-key go-mode-map (kbd "s-<return>") #'my-go-mode-split-string)
    (define-key go-ts-mode-map (kbd "s-<return>") #'my-go-mode-split-string))

  ;; Smartparens configuration
  (sp-local-pair 'prog-mode "{" nil :post-handlers '((indent-between-pair "RET"))))

(defun my-go-mode-split-string(arg)
  "Split Go string expressions with appropriate formatting."
  (interactive "*P")
  (sp-split-sexp arg)
  (insert-char 43) ; insert char +
  (newline)
  (forward-char)
  (gofmt))

;; Add hooks for Go modes
(add-hook 'go-mode-hook #'my-go-mode-hook)
(add-hook 'go-ts-mode-hook #'my-go-mode-hook)

(provide 'init-lang-go)

;;; init-lang-go.el ends here
