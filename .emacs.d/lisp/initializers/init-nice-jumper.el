

;; load from ./lisp
(require 'nice-jumper)
(global-nice-jumper-mode t)
;; (add-hook 'nice-jumper-post-jump-hook 'my-recenter)
(add-hook 'nice-jumper-post-jump-hook 'xref-pulse-momentarily)
(when (display-graphic-p)
  ;; cmd+[ cmd+]
  (global-set-key (kbd "s-[") 'nice-jumper/backward)
  (global-set-key (kbd "s-]") 'nice-jumper/forward))
;; for terminal
;; C-o C-M-o
(global-set-key (kbd "C-o") 'nice-jumper/backward)
(global-set-key (kbd "C-M-o") 'nice-jumper/forward)

;; (defadvice deadgrep (before nice-jumper activate)
;;   (nice-jumper--set-jump))




(provide 'init-nice-jumper)
