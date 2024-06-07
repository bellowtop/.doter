(require 'corfu-terminal)
(corfu-terminal-mode 1)


(require 'my-utils)


(require 'popon)
(advice-add #'keyboard-quit :before #'popon-kill-all)


(setq my-term-popup-engine 'corfu-terminal)
;; (setq my-term-popup-engine 'popon)

(setq my-term-popup-show-p nil)

(defun my-term-popup-close (&optional arg)
  (interactive)
  (corfu--popup-hide)
  (if (window-parameter (get-buffer-window) 'popon-list)
    (popon-kill-all))
  (setq my-term-popup-show-p nil))




(defun show-eldoc-popup-at-point ()
  (interactive)
  (when (boundp 'eldoc--doc-buffer)
    (let* ((str (with-current-buffer eldoc--doc-buffer
                  (buffer-string)))
            (lines (string-split str "\n"))
            )
      (my-show-popup lines)
      (setq my-term-popup-show-p t))))



(defun my-show-popup(&optional lines)
  (interactive)
  (let* (
          (lines (or lines
                   (split-string (my-util-read-fmt-content "~/.emacs.d/lisp/my-utils.el") "\n") ;; for test
                   ))
          (display-width (- (window-width) 8))

          (content-width (- (window-body-width) 10)) ;; don't count the line-number column , and the border chars
          (border-line (make-string (1+ content-width) ?─))
          (lines (nconc (list border-line) lines (list border-line)))
          ;; (_ (message "lines number %d: \n%s\n"  (length lines) lines))
          (lines-size (length lines))
          (idx 0)
          (lines
            (cl-loop for line in lines
              do (setq idx (1+ idx))
              collect (cond
                        ((= 1 idx) (concat "┌" line))
                        ((= lines-size idx) (concat "└" line))
                        ((string= line "---") (concat "│" border-line))
                        (t (concat "│ " line)))
              ))
          )

    (if (eq my-term-popup-engine 'popon)
      ;; implemented using popon
      (popon-create
        (string-join lines "\n")
        (cons 0
          (+ (cdr (popon-x-y-at-pos (point))) 1))
        (get-buffer-window)
        (current-buffer))
      ;; implemented using corfu-terminal, I think it's more stable
      (progn
        (setq lines (cl-loop for line in lines
                      do (message "line width: %s" (length line))
                      collect (cond
                                ((> (length line) display-width)
                                  (substring-no-properties line 0 display-width))
                                ((< (length line) display-width)
                                  (concat line (make-string (- display-width (length line)) ?\s)))
                                (t line))))
        ;; (message "lines length: %s" (length lines))
        ;; (loop for line in lines do (message "line width: %s" (length line)))
        (corfu--popup-show
          (posn-at-point)
          (save-excursion (goto-char (point)) (current-column))
          display-width
          lines)))
    ))

(global-set-key (kbd "C-c C-i") #'my-show-popup)
(global-set-key (kbd "C-c C-j") #'(lambda() (interactive) (my-show-popup (list "hello this is a" "new line" "hhehe"))))




(advice-add 'next-line :after 'my-term-popup-close)
(advice-add 'previous-line :after 'my-term-popup-close)
(advice-add 'forward-char :after 'my-term-popup-close)
(advice-add 'backward-char :after 'my-term-popup-close)
(advice-add 'scroll-up-command :after 'my-term-popup-close)
(advice-add 'scroll-down-command :after 'my-term-popup-close)

(advice-add 'gcm-scroll-down :after 'my-term-popup-close)
(advice-add 'gcm-scroll-up :after 'my-term-popup-close)

(advice-add 'scroll-half-page-up :after 'my-term-popup-close)
(advice-add 'scroll-half-page-down :after 'my-term-popup-close)



(provide 'my-term-popup)
