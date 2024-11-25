(require 'init-flymake)

(defvar my-code-intelligence 't
  "enable by default")


(defvar my-eglot-highlight-symbol-face-saved nil
  "saved value for eglot-highlight-symbol-face")


(with-eval-after-load 'eglot
  (set-face-attribute 'eglot-highlight-symbol-face nil :inherit (if (display-graphic-p) 'my-highlight-font-words-face 'my-highlight-font-words-face))
  (setq my-eglot-highlight-symbol-face-saved (face-attribute 'eglot-highlight-symbol-face :inherit))
  )


(defun my-disable-eglot-highlight (&rest _)
  (interactive)
  (message "my-disable-eglot-highlight")
  (ignore-errors
    (setq eglot-ignored-server-capabilities
      (add-to-list 'eglot-ignored-server-capabilities ':documentHighlightProvider))
    (set-face-attribute 'eglot-highlight-symbol-face nil :inherit nil)
    (try-stop-flymake)
    ))

(defun my-enable-eglot-highlight (&rest _)
  (interactive)
  (message "my-enable-eglot-highlight")
  (ignore-errors
    (setq eglot-ignored-server-capabilities
      (delete ':documentHighlightProvider eglot-ignored-server-capabilities))
    (set-face-attribute 'eglot-highlight-symbol-face nil :inherit my-eglot-highlight-symbol-face-saved)
    (try-start-flymake)
    ))



(defun my-enable-paren-highlight ()
  (interactive)
  (ignore-errors
    (set-face-attribute 'show-paren-match nil :foreground "black" :background "yellow" :weight 'normal)))


(defun my-disable-paren-highlight ()
  (interactive)
  (ignore-errors
    (set-face-attribute 'show-paren-match nil :foreground "green" :background 'unspecified)))
;; (set-face-attribute 'show-paren-match nil :foreground 'unspecified :background 'unspecified :weight 'bold)))

(defun my-enable-symbol-overlay-highlight ()
  (interactive)
  (when (derived-mode-p 'emacs-lisp-mode)
    (ignore-errors
      (symbol-overlay-mode 1))))


(defun my-disable-symbol-overlay-highlight ()
  (interactive)
  (ignore-errors
    (symbol-overlay-mode 0)))


(defun my-disable-code-intelligence ()
  (interactive)
  (when my-code-intelligence
    (my-disable-eglot-highlight)
    (electric-pair-mode 0)
    (undo-tree-mode 0)
    (setq my-code-intelligence nil)
    ;; (message "code-intelligence is disabled.")
    ))

(defun my-enable-code-intelligence ()
  (interactive)
  (unless my-code-intelligence
    (my-enable-eglot-highlight)
    (electric-pair-mode 1)
    (undo-tree-mode 1)
    (setq my-code-intelligence 't)
    ;; (message "code-intelligence is enabled.")
    ))



(defun my-remove-all-highlight ()
  (interactive)
  (remove-all-highlight)
  (my-disable-paren-highlight)
  (my-disable-eglot-highlight))

(defun my-enable-all-highlight ()
  (interactive)
  (my-enable-paren-highlight)
  (my-enable-eglot-highlight))



(provide 'my-toggle-code-intelligence)
