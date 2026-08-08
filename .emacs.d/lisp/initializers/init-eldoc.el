

;; for my-elisp-eldoc-var-docstring-with-value
;; (require 'my-utils)

(use-package eldoc
  :config
  (setq eldoc-echo-area-use-multiline-p 1)
  (setq eldoc-idle-delay 0.2)
  (add-hook
    'emacs-lisp-mode-hook
    '(lambda () (add-to-list 'eldoc-documentation-functions 'elisp-eldoc-var-docstring-with-value)))
  (add-hook
    'lisp-mode-hook
    '(lambda () (add-to-list 'eldoc-documentation-functions 'elisp-eldoc-var-docstring-with-value))))

(use-package eldoc-box
  :config
  (setq eldoc-box-clear-with-C-g t)
  (set-face-attribute 'eldoc-box-body nil :background "#000000")
  (setq eldoc-box-max-pixel-width 1000)

  ;; Emacs 31 NS port: `set-frame-size' on childframes is a no-op.
  ;; Workaround: kill the old frame before every display and create a
  ;; fresh one with frame-parameters sized to the content string.

  (defun my-eldoc-box--content-pixel-size (str)
    "Return (WIDTH . HEIGHT) pixel size for STR, clamped sensibly."
    (let* ((lines (split-string str "\n"))
           (cw (frame-char-width))
           (ch (frame-char-height))
           (max-chars (apply #'max (mapcar #'string-width lines)))
           ;; Cap width: don't exceed parent frame or 100 chars.
           (max-wide (* (min max-chars 100) cw))
           (pw (+ max-wide (* 3 cw))))  ; +3 chars for fringes+border
      (cons (min pw (frame-pixel-width)  ; never wider than main frame
                 eldoc-box-max-pixel-width)
            (max (* (length lines) ch)
                 (* 4 ch)))))  ; minimum 4 lines

  (defun my-eldoc-box--make-frame-params (pw ph)
    "Build frame parameters for a childframe of PW×PH pixels."
    `((left . -1) (top . -1)
      (width  . ,(ceiling pw (frame-char-width)))
      (height . ,(ceiling ph (frame-char-height)))
      (no-accept-focus . t)
      (no-focus-on-map . t)
      (min-width  . 0) (min-height . 0)
      (internal-border-width . 1)
      (vertical-scroll-bars . nil)
      (horizontal-scroll-bars . nil)
      (right-fringe . 3) (left-fringe . 3)
      (menu-bar-lines . 0) (tool-bar-lines . 0)
      (line-spacing . 0) (unsplittable . t)
      (undecorated . t)
      (mouse-wheel-frame . nil) (no-other-frame . t)
      (cursor-type . nil) (inhibit-double-buffering . t)
      (drag-internal-border . t) (no-special-glyphs . t)
      (desktop-dont-save . t)
      (tab-bar-lines . 0) (tab-bar-lines-keep-state . 1)))

  (define-advice eldoc-box--display (:around (orig-fun str) ns-workaround)
    "Pre-calculate frame size from STR and create frame accordingly."
    (when (and eldoc-box--frame (frame-live-p eldoc-box--frame))
      (delete-frame eldoc-box--frame)
      (setq eldoc-box--frame nil))
    (let* ((size (my-eldoc-box--content-pixel-size str))
           (eldoc-box-frame-parameters
            (my-eldoc-box--make-frame-params (car size) (cdr size))))
      (funcall orig-fun str)))

  ;; The geometry function calculates position from `window-text-pixel-size',
  ;; which may differ from the frame's actual size (set-frame-size is a no-op
  ;; on NS).  Re-position using the frame's REAL pixel dimensions.
  (define-advice eldoc-box--update-childframe-geometry (:after (frame _window) fix-pos)
    (let* ((pw (frame-pixel-width frame))
           (ph (frame-pixel-height frame))
           (pos (funcall eldoc-box-position-function pw ph)))
      (set-frame-position frame (car pos) (cdr pos))))
  :commands (eldoc-box-help-at-point))


(with-eval-after-load 'eldoc
    (eldoc-add-command 'my-forward-char-no-cross-line)
    (eldoc-add-command 'my-backward-char-no-cross-line)
    (eldoc-add-command 'my-forward-to-word)
    (eldoc-add-command 'my-next-line)
    (eldoc-add-command 'my-previous-line))


(provide 'init-eldoc)
