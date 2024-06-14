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



(defun which-active-modes ()
  "Give a message of which minor modes are enabled in the current buffer."
  (interactive)
  (let ((active-modes))
    (mapc
      (lambda (mode)
        (condition-case nil
          (if (and (symbolp mode) (symbol-value mode))
            (add-to-list 'active-modes mode))
          (error nil)))
      minor-mode-list)
    (message "Active modes are %s" active-modes)))




;; Check if system is Darwin/Mac OS X
(defun my-system-type-is-darwin ()
  "Return true if system is darwin-based (Mac OS X)"
  (string-equal system-type "darwin"))

;; Check if system is Microsoft Windows
(defun my-system-type-is-windows ()
  "Return true if system is Windows-based (at least up to Win7)"
  (string-equal system-type "windows-nt"))

;; Check if system is GNU/Linux
(defun my-system-type-is-gnu ()
  "Return true if system is GNU/Linux-based"
  (string-equal system-type "gnu/linux"))




(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
    http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
    this.  The function inserts linebreaks to separate tags that have
    nothing but whitespace between them.  It then indents the markup
    by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t ]*\<" nil t)
      (backward-char)
      (insert "\n")
      (setq end (1+ end)))
    (indent-region begin end))
  (message "Ah, much better!"))






(defun flip-buffer-to-window ()
  "Flips to the last-visited buffer in this window."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer))))


(defun json-to-single-line (beg end)
  "Collapse prettified json in region between BEG and END to a single line"
  (interactive "r")
  (if (use-region-p)
    (save-excursion
      (save-restriction
        (narrow-to-region beg end)
        (goto-char (point-min))
        (while (re-search-forward "[[:space:]\n]+" nil t)
          (replace-match " "))))
    (print "This function operates on a region")))


(defun un-indent-by-removing-4-spaces ()
  "remove 4 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-line)
      ;; get rid of tabs at beginning of line
      (when (looking-at "^\\s-+")
        (untabify (match-beginning 0) (match-end 0)))
      (when (looking-at "^    ")
        (replace-match "")))))





(defun my-show-file-name ()
  (interactive)
  (message (buffer-file-name)))




(defun my-copied-content-is-end-of-newline ()
  (interactive)
  (string-suffix-p "\n" (current-kill 0 'DONT-MOVE)))




(defun buffer-mode (&optional buffer-or-name)
  "Returns the major mode associated with a buffer.
If buffer-or-name is nil return current buffer's mode."
  (with-current-buffer
    (if buffer-or-name
      (get-buffer buffer-or-name)
      (current-buffer))
    major-mode))



;; Source: https://www.emacswiki.org/emacs/misc-cmds.el
(defun my-revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  (revert-buffer :ignore-auto :noconfirm)
  (refresh-current-mode))



(defun increment-number-at-point ()
  (interactive)
  (skip-chars-backward "0-9")
  (or (looking-at "[0-9]+") (error "No number at point"))
  (replace-match
    (number-to-string (1+ (string-to-number (match-string 0))))))




(defun my-move-to-end-of-word ()
  "Move to the next 'last character' of a word."
  (interactive)
  (forward-char)
  (re-search-forward "\\w\\b" nil t)
  (goto-char (match-beginning 0)))

(defun my-delete-to-beginning (args)
  (interactive "p")
  (set-mark-command nil)
  (mwim-beginning-of-code-or-line)
  (delete-region (region-beginning) (region-end)))

(defun my-delete-to-end (args)
  (interactive "p")
  (set-mark-command nil)
  (mwim-end-of-line)
  (delete-region (region-beginning) (region-end)))

(defun my-delete-to-eof (args)
  (interactive "p")
  (set-mark-command nil)
  (forward-line 0)
  (set-mark-command nil)
  (end-of-buffer)
  (delete-region (region-beginning) (region-end)))



(provide 'my-utils)
