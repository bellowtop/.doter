
(use-package yasnippet
  :config
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'yas-before-expand-snippet-hook 'my-disable-eglot-highlight)
  (add-hook 'yas-after-exit-snippet-hook 'my-enable-eglot-highlight))


(provide 'init-yasnippet)
