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


(provide 'my-utils)
