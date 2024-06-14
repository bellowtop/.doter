
(use-package slime
  :ensure t
  :defer t
  :init
  (setq inferior-lisp-program (executable-find "sbcl"))
  :config
  (slime-setup '(slime-fancy slime-company))
  :hook
  (slime-mode . slime-company)
  (slime-mode . (lambda ()
                  (load (expand-file-name "~/quicklisp/slime-helper.el"))
                  (add-to-list 'slime-contribs 'slime-fancy)
                  (add-to-list 'slime-contribs 'inferior-slime))))

(use-package slime-company
  :after slime
  :bind ((:map slime-repl-mode-map
           ("C-n" . company-select-next)
           ("C-p" . company-select-previous)
           ("M-." . company-show-location)
           ))
  :config
  (setq
    slime-company-completion 'fuzzy
    slime-company-after-completion 'slime-company-just-one-space))


(provide 'init-slime)
