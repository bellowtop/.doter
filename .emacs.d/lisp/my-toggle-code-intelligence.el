(defvar my-code-intelligence 't
  "enable by default")


(defun my-disable-eglot-highlight ()
  (interactive)
  (ignore-errors
    (setq eglot-ignored-server-capabilities
      (add-to-list 'eglot-ignored-server-capabilities ':documentHighlightProvider))
    (set-face-attribute 'eglot-highlight-symbol-face nil :inherit nil)
    (flymake-mode 0)
    ))

(defun my-enable-eglot-highlight ()
  (interactive)
  (ignore-errors
    (setq eglot-ignored-server-capabilities
      (delete ':documentHighlightProvider eglot-ignored-server-capabilities))
    (set-face-attribute 'eglot-highlight-symbol-face nil :inherit 'my-highlight-font-chars-face)
    (flymake-mode 1)
    (flymake-start)
    ))

(with-eval-after-load 'eglot
  (set-face-attribute 'eglot-highlight-symbol-face nil :inherit 'my-highlight-font-chars-face)
)



(defun my-enable-paren-highlight ()
  (interactive)
  (ignore-errors
    (set-face-attribute 'show-paren-match nil :foreground "black" :background "yellow")))

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
