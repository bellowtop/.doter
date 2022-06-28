;;; jdecomp-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "jdecomp" "jdecomp.el" (0 0 0 0))
;;; Generated autoloads from jdecomp.el

(autoload 'jdecomp-preview-mode "jdecomp" "\
Major mode for previewing decompiled Java class files.

\\{jdecomp-preview-mode-map}

\(fn)" t nil)

(autoload 'jdecomp-decompile "jdecomp" "\
Decompile FILE and return buffer of decompiled contents.

FILE must be a Java class file.

Optional parameter JAR is the name of the JAR archive FILE is
in.

\(fn FILE &optional JAR)" nil nil)

(autoload 'jdecomp-decompile-and-view "jdecomp" "\
Decompile FILE and view buffer of decompiled contents.

FILE must be a Java class file.  If called interactively, FILE is
the name of the file the current buffer is visiting.

Optional parameter JAR is the JAR file containing FILE, if
applicable.

\(fn FILE &optional JAR)" t nil)

(defvar jdecomp-mode nil "\
Non-nil if Jdecomp mode is enabled.
See the `jdecomp-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `jdecomp-mode'.")

(custom-autoload 'jdecomp-mode "jdecomp" nil)

(autoload 'jdecomp-mode "jdecomp" "\
Automatically decompile Java class files.

This is a minor mode.  If called interactively, toggle the
`Jdecomp mode' mode.  If the prefix argument is positive, enable
the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='jdecomp-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "jdecomp" '("jdecomp-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8-emacs-unix
;; End:
;;; jdecomp-autoloads.el ends here
