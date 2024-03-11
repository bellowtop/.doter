(with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
        '(swift-mode . ("xcrun" "sourcekit-lsp")))
)

(add-hook 'swift-mode-hook 'eglot-ensure)

(provide 'init-lang-swift)
