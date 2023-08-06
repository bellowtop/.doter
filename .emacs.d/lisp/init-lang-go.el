
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



;; (defun my-go-mode-hook ()
;;   (setq gofmt-command "goimports")
;;   (add-hook 'before-save-hook 'gofmt-before-save))
;; 
;; (add-hook 'go-mode-hook 'my-go-mode-hook)

(message "in init-lang-to.el file")

(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  :hook
  (go-mode . eglot-ensure)
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (+eglot/set-leader-keys go-mode-map)
  (with-eval-after-load 'exec-path-from-shell
    (exec-path-from-shell-copy-envs '("GOPATH" "GO111MODULE" "GOPROXY"))))


(provide 'init-lang-go)

;;; init-lang-go.el ends here
