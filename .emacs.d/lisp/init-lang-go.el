
;; init-lang-go.el --- Go Lang Config	-*- lexical-binding: t -*-

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
  (interactive)
  (when (or (eq major-mode 'go-mode)
            (eq major-mode 'go-ts-mode))
    (gofmt)))

(defun my-go-mode-hook ()
  ;; load go-mode package (not use go-mode as major mode)
  (eglot-ensure)
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'my-gofmt-before-save nil t)
)

;; (add-hook 'go-mode-hook 'my-go-mode-hook)

(message "in init-lang-go.el file")

(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  :config
  (with-eval-after-load 'exec-path-from-shell
    (exec-path-from-shell-copy-envs '("GOPATH" "GO111MODULE" "GOPROXY"))))


(provide 'init-lang-go)

;;; init-lang-go.el ends here
