
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
  (eglot-ensure)
  (require 'go-mode)
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'my-gofmt-before-save nil t)

  (with-eval-after-load 'exec-path-from-shell
    (exec-path-from-shell-copy-envs '("GOPATH" "GO111MODULE" "GOPROXY")))

  (setq go-ts-mode-indent-offset 4)

  (if (eq major-mode 'go-mode)
    (define-key go-mode-map    (kbd "s-<return>") #'my-go-mode-split-string)
    (define-key go-ts-mode-map (kbd "s-<return>") #'my-go-mode-split-string)
    (sp-local-pair 'prog-mode "{" nil :post-handlers '((indent-between-pair "RET")))
    )
)


(defun my-go-mode-split-string(arg)
  (interactive "*P")
  (sp-split-sexp arg)
  (insert-char 43) ; insert char +
  (newline)
  (forward-char)
  (gofmt)
)


(add-hook 'go-mode-hook #'my-go-mode-hook)
(add-hook 'go-ts-mode-hook #'my-go-mode-hook)



(provide 'init-lang-go)

;;; init-lang-go.el ends here
