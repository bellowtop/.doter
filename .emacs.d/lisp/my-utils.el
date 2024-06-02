(require 'f)


(defun my-util-split-long-line-to-sub-lines (long-line wrap-width)
  (interactive)
  (let ((total-len (string-width long-line))
        (idx 0)
        (collected ()))
    (while (> (- total-len idx) wrap-width)
      (push (substring long-line idx (+ idx wrap-width)) collected)
      (setq idx (+ idx wrap-width)))
    (when (< idx total-len)
      (push (substring long-line idx total-len) collected))
    (reverse collected)))

;; (message "%s" (my-util-split-long-line-to-sub-lines "It is useful to include newlines" 4))
;; (string-width "It is useful to include newlines")

(defun my-util-seperate-string (line max-length)
  (let ((remains line)
        (result-lines ())
        )
    (while (> (length remains) max-length)
      (push (substring remains 0 max-length) result-lines)
      (setq remains (substring remains max-length nil))
      )
    ;; last one
    (push remains result-lines)
    (reverse result-lines)
    )
  )




(defun my-util-read-fmt-content (filepath)
  (interactive)
  (let ((file-content (f-read-text filepath)))
    (with-temp-buffer
      (emacs-lisp-mode)
      ;; (rename-buffer "tmp.el" t)
      ;; (set-auto-mode)
      ;; (message "%s" (buffer-mode))
      (insert file-content)
      (font-lock-ensure)
      (buffer-string))))



;; ;; copy from elisp-eldoc-var-docstring-with-value
;; (defun my-elisp-eldoc-var-docstring-with-value (callback &rest _)
;;   (when-let ((cs (elisp--current-symbol)))
;;     (when (and (boundp cs)
;; 	           ;; nil and t are boundp!
;; 	           (not (null cs))
;; 	           (not (eq cs t)))
;;       (funcall callback
;; 	           (format "%s"
;; 		               (let* ((doc
;;                                (describe-function cs)
;;                                ;; (documentation-property
;;                                ;;      cs 'variable-documentation t)
;;                                )
;; 			                  (more (- (length doc) 1000)))
;;                          (message "doc: %s" doc)
;; 			             (concat (propertize
;; 				                  (string-limit (if (string= doc "nil")
;; 						                            "Undocumented."
;; 						                          doc)
;; 					                            1000)
;; 				                  'face 'font-lock-doc-face)
;; 				                 (when (> more 0)
;; 				                   (format "[%sc more]" more)))))
;; 	           :thing cs
;; 	           :face 'font-lock-variable-name-face))))


(provide 'my-utils)
