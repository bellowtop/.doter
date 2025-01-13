(use-package python-ts-mode
  :defer t
  :after eglot
  :config
  (add-to-list 'eglot-server-programs
    `((python-mode python-ts-mode) .
       ,(eglot-alternatives
          '(("hatch" "run" "pyright-langserver" "--stdio")))))
  (setq python-shell-interpreter "hatch")
  (setq python-shell-interpreter-args "run ipython -i --simple-prompt --InteractiveShell.display_page=True")
  )

(provide 'init-lang-python)
