;; -*- lexical-binding: t -*-
;;; init-lang-swift.el --- Swift language configuration

(use-package swift-mode
  :defer t
  :config
  (add-hook 'before-save-hook 'format-all-buffer nil 'local))

(defun xcode-build()
  "Build current Xcode project."
  (interactive)
  (shell-command-to-string
   "osascript -e 'tell application \"Xcode\"' -e 'set targetProject to active workspace document' -e 'build targetProject' -e 'end tell'"))

(defun xcode-run()
  "Run current Xcode project."
  (interactive)
  (shell-command-to-string
   "osascript -e 'tell application \"Xcode\"' -e 'set targetProject to active workspace document' -e 'stop targetProject' -e 'run targetProject' -e 'end tell'"))

(defun xcode-test()
  "Test current Xcode project."
  (interactive)
  (shell-command-to-string
   "osascript -e 'tell application \"Xcode\"' -e 'set targetProject to active workspace document' -e 'stop targetProject' -e 'test targetProject' -e 'end tell'"))

(provide 'init-lang-swift)

;;; init-lang-swift.el ends here
