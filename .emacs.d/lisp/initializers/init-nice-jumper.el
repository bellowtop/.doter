

;; load from ./lisp
(require 'nice-jumper)
(global-nice-jumper-mode t)
;; (add-hook 'nice-jumper-post-jump-hook 'my-recenter)
(add-hook 'nice-jumper-post-jump-hook 'xref-pulse-momentarily)


;; (defadvice deadgrep (before nice-jumper activate)
;;   (nice-jumper--set-jump))




(provide 'init-nice-jumper)
