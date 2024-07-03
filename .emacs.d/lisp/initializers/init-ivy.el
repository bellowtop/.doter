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
  ;; donot show these buffers in counsel-switch-buffer
  (add-to-list 'ivy-ignore-buffers "\\*Messages\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Help\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Compile-Log\\*")
  (add-to-list 'ivy-ignore-buffers "\\*EGLOT")
  (add-to-list 'ivy-ignore-buffers "\\*rdm\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Backtrace\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Ibuffer\\*"))

;; why ensure not work?
(require 'ivy)

(defun ivy-format-function-default (cands)
  "Transform CANDS into a string for minibuffer."
  (concat
    "---------------------------------------------------\n"
    (ivy--format-function-generic
      (lambda (str)
        (concat " > " (ivy--add-face str 'ivy-current-match) ""))
      (lambda (str) (concat "   " str "")) cands "\n")
    "\n----------------------------------------------------\n\n"))


;;  (use-package ivy-posframe
;;    :after (ivy)
;;    :config
;;
;;    (defun ivy-format-function-default (cands)
;;      "Transform CANDS into a string for minibuffer."
;;      (concat
;;        "---------------------------------------------------\n"
;;        (ivy--format-function-generic
;;          (lambda (str)
;;            (concat " > " (ivy--add-face str 'ivy-current-match) ""))
;;          (lambda (str) (concat "   " str "")) cands "\n")
;;        "\n----------------------------------------------------\n\n"))
;;
;;    (defun my-ivy-posframe-get-size ()
;;      "Set the ivy-posframe size according to the current frame."
;;      (let ((height (or ivy-posframe-height (or (+ ivy-height 2) 20)))
;;             (width (or ivy-posframe-width (round (* .80 (frame-width))))))
;;        (list :height height :min-height height :min-width width)))
;;
;;    (setq ivy-posframe-size-function 'my-ivy-posframe-get-size)
;;    (setq ivy-posframe-parameters '((:internal-border-width . 1)
;;                                     (:internal-border-color . "white")))
;;
;;    (setq ivy-posframe-display-functions-alist
;;      '((t . ivy-posframe-display-at-frame-center)))
;;
;;    (ivy-posframe-mode 1))

(provide 'init-ivy)
