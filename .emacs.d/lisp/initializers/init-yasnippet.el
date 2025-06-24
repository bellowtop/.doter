(require 'my-toggle-code-intelligence)


(use-package yasnippet
  :config
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'yas-before-expand-snippet-hook 'my-disable-eglot-highlight)
  (add-hook 'yas-after-exit-snippet-hook    'my-enable-eglot-highlight)

  (add-hook 'yas-before-expand-snippet-hook #'my-disable-eglot-highlight)
  (add-hook 'yas-after-exit-snippet-hook    #'my-enable-eglot-highlight)

  ;; Face configuration moved to custom-set-faces
  )


(provide 'init-yasnippet)
