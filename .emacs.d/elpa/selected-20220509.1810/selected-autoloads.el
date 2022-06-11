;;; selected-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "selected" "selected.el" (0 0 0 0))
;;; Generated autoloads from selected.el

(autoload 'selected-minor-mode "selected" "\
If enabled activates the `selected-keymap' when the region is active.

This is a minor mode.  If called interactively, toggle the
`selected minor mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `selected-minor-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(put 'selected-global-mode 'globalized-minor-mode t)

(defvar selected-global-mode nil "\
Non-nil if Selected-Global mode is enabled.
See the `selected-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `selected-global-mode'.")

(custom-autoload 'selected-global-mode "selected" nil)

(autoload 'selected-global-mode "selected" "\
Toggle Selected minor mode in all buffers.
With prefix ARG, enable Selected-Global mode if ARG is positive;
otherwise, disable it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Selected minor mode is enabled in all buffers where
`selected--global-on-p' would do it.

See `selected-minor-mode' for more information on Selected minor
mode.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "selected" '("selected-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; selected-autoloads.el ends here
