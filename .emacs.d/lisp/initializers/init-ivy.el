(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :bind
  ((:map
     ivy-minibuffer-map
     ;; ("C-'" . ivy-avy)
     ("TAB" . ivy-next-line)
     ("<backtab>" . ivy-previous-line)
     ("<escape>" . keyboard-escape-quit)))
  :config (ivy-mode 1)

  ;; donot sort mark ring
  (ivy-configure 'counsel-mark-ring :sort-fn #'ignore)

  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq counsel-switch-buffer-preview-virtual-buffers nil)
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
    ;; allow input not in order
    '((t . ivy--regex-ignore-order)))

  (set-face-attribute 'ivy-minibuffer-match-face-1     nil :weight 'regular)
  (set-face-attribute 'ivy-minibuffer-match-face-2     nil :weight 'regular)
  (set-face-attribute 'ivy-minibuffer-match-face-3     nil :weight 'regular)
  (set-face-attribute 'ivy-minibuffer-match-face-4     nil :weight 'regular)

  ;; donot show these buffers in counsel-switch-buffer
  (add-to-list 'ivy-ignore-buffers "\\*Messages\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Help\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Compile-Log\\*")
  (add-to-list 'ivy-ignore-buffers "\\*EGLOT")
  (add-to-list 'ivy-ignore-buffers "\\*rdm\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Backtrace\\*")
  (add-to-list 'ivy-ignore-buffers "\\*ripgrep-search\\*")
  (add-to-list 'ivy-ignore-buffers "\\*vterm\\*")
  (add-to-list 'ivy-ignore-buffers "\\*dashboard\\*")
  (add-to-list 'ivy-ignore-buffers "\\*xref\\*")
  (add-to-list 'ivy-ignore-buffers "\\*deadgrep")
  (add-to-list 'ivy-ignore-buffers "\\*Customize")
  (add-to-list 'ivy-ignore-buffers "\\*Semantic")
  (add-to-list 'ivy-ignore-buffers "\\*Flymake")
  (add-to-list 'ivy-ignore-buffers "\\*Ibuffer\\*"))

;; why ensure not work?
(require 'ivy)

(use-package ivy-posframe
  :after (ivy)
  :config

  (defun ivy-format-function-default (cands)
    "Transform CANDS into a string for minibuffer."
    (concat
      (propertize
        (format "%s\n" (make-string (round (* .50 (frame-width))) ?─))
        'face
        '(:foreground "#06C668"))
      (ivy--format-function-generic
        (lambda (str)
          (concat " > " (ivy--add-face str 'ivy-current-match) ""))
        (lambda (str) (concat "   " str "")) cands "\n")
      "\n"))

  (defun my-ivy-posframe-get-size ()
    "Set the ivy-posframe size according to the current frame."
    (let ((height (or ivy-posframe-height (or (+ ivy-height 2) 20)))
           (width (or ivy-posframe-width (round (* .50 (frame-width))))))
      (list :height height :min-height height :min-width width)))

  (setq ivy-posframe-size-function 'my-ivy-posframe-get-size)
  (setq ivy-posframe-display-functions-alist
    '((t . ivy-posframe-display-at-frame-center)))

  ;; padding 10
  (set-face-attribute 'ivy-posframe nil :background "black")
  (set-face-attribute 'fringe nil :background "black")
  ;; ivy window is dark
  ;; (set-face-attribute 'ivy-current-match nil :background "black")

  ;; (set-face-attribute 'ivy-posframe-border nil :background (face-background 'ivy-posframe))
  ;; (setq ivy-posframe-border-width 10)
  (set-face-attribute 'ivy-posframe-border nil :background (face-foreground 'vertical-border))
  (setq ivy-posframe-border-width my-posframe-border-width)

  (setq ivy-posframe-parameters `((left-fringe . ,my-posframe-fringe-width)
                                   (right-fringe . ,my-posframe-fringe-width)))


  (ivy-posframe-mode 1))

(provide 'init-ivy)
