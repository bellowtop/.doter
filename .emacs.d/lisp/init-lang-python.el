(use-package python-base-mode
  :defer t
  :after eglot
  :config
  (add-to-list 'eglot-server-programs
    `((python-mode python-ts-mode) .
       ,(eglot-alternatives
          '(("hatch" "run" "pyright-langserver" "--stdio")))))

  )

(provide 'init-lang-python)
