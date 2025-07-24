
(use-package java-ts-mode
  :ensure t
  :mode ("\\.java\\'" . java-ts-mode)
  :init
  (add-hook 'java-ts-mode-hook #'eglot-ensure)
  )


(provide 'init-language-java)

