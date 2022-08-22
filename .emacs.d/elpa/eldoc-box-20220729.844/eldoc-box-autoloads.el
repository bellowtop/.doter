;;; eldoc-box-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "eldoc-box" "eldoc-box.el" (0 0 0 0))
;;; Generated autoloads from eldoc-box.el

(autoload 'eldoc-box-hover-mode "eldoc-box" "\
Displays hover documentations in a childframe.
The default position of childframe is upper corner.

This is a minor mode.  If called interactively, toggle the
`ELDOC-BOX-Hover mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `eldoc-box-hover-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'eldoc-box-hover-at-point-mode "eldoc-box" "\
A convenient minor mode to display doc at point.
You can use [keyboard-quit] to hide the doc.

This is a minor mode.  If called interactively, toggle the
`ELDOC-BOX-Hover-At-Point mode' mode.  If the prefix argument is
positive, enable the mode, and if it is zero or negative, disable
the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `eldoc-box-hover-at-point-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "eldoc-box" '("eldoc-box-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; eldoc-box-autoloads.el ends here
