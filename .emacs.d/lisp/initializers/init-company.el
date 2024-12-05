(require 'my-toggle-code-intelligence)

(require 'company)


;; company-mode
(setq company-dabbrev-downcase nil)

(setq company-backends '((company-capf company-keywords company-files company-dabbrev)))

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'before-save-hook 'company-cancel)


;; company-posframe-mode
(require 'company-posframe)
(company-posframe-mode 1)

;; http://company-mode.github.io/manual/Getting-Started.html#Initial-Setup
(with-eval-after-load 'company-posframe
  (define-key company-mode-map (kbd "C-M-i") #'company-complete)

  (set-face-attribute 'company-tooltip-common nil :weight 'normal :foreground "#7FDC59" :background "#161c23")

  (define-key company-active-map (kbd "<tab>") #'company-select-next-if-tooltip-visible-or-complete-selection)
  (define-key company-active-map (kbd "<backtab>") #'company-select-previous-or-abort)
  (define-key company-active-map (kbd "RET") #'company-complete-selection)


  ;; patch this function, it has bug when posframe is active.
  (defun company-select-next-if-tooltip-visible-or-complete-selection ()
    (interactive)
    (if (and t (> company-candidates-length 1))
        (call-interactively 'company-select-next)
      (call-interactively 'company-complete-selection)))

  (define-key company-posframe-active-map (kbd "<tab>") #'company-select-next-if-tooltip-visible-or-complete-selection)
  (define-key company-posframe-active-map (kbd "<backtab>") #'company-select-previous-or-abort)
  (define-key company-posframe-active-map (kbd "RET") #'company-complete-selection)

  (add-hook 'company-completion-started-hook   #'my-disable-eglot-highlight)
  (add-hook 'company-completion-finished-hook  #'my-enable-eglot-highlight)
  (add-hook 'company-completion-cancelled-hook #'my-enable-eglot-highlight)

  (global-set-key (kbd "s-r") #'company-yasnippet))
;; Use (kbd "TAB") (or use (kbd "<tab>"), if you want to distinguish C-i from the <tab> key)



(provide 'init-company)
