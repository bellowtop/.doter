(use-package swift-mode
  :defer t
  :after eglot
  :config
  (add-to-list 'eglot-server-programs '(swift-mode . ("xcrun" "sourcekit-lsp") ))

  (add-hook 'swift-mode-hook #'(lambda()
                                 (if (string= (file-name-extension buffer-file-name) "swiftinterface")
                                   (message "swift interface files ignored by eglot.")
                                   (eglot-ensure))))

  (add-hook 'before-save-hook 'format-all-buffer nil 'local)
  )



(defun xcode-build()
  (interactive)
  (shell-command-to-string
    "osascript -e 'tell application \"Xcode\"' -e 'set targetProject to active workspace document' -e 'build targetProject' -e 'end tell'"))
(defun xcode-run()
  (interactive)
  (shell-command-to-string
    "osascript -e 'tell application \"Xcode\"' -e 'set targetProject to active workspace document' -e 'stop targetProject' -e 'run targetProject' -e 'end tell'"))
(defun xcode-test()
  (interactive)
  (shell-command-to-string
    "osascript -e 'tell application \"Xcode\"' -e 'set targetProject to active workspace document' -e 'stop targetProject' -e 'test targetProject' -e 'end tell'"))

(provide 'init-lang-swift)
