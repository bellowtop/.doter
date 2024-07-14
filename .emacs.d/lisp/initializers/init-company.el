

;; company-mode
(setq company-dabbrev-downcase nil)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'before-save-hook 'company-cancel)

;; company-posframe-mode
                                        ;  (require 'company-posframe)
                                        ;  (company-posframe-mode 1)

;; http://company-mode.github.io/manual/Getting-Started.html#Initial-Setup
(with-eval-after-load 'company
  (define-key
    company-active-map
    (kbd "<tab>")
    #'company-select-next-if-tooltip-visible-or-complete-selection)
  (define-key
    company-active-map
    (kbd "<backtab>")
    #'company-select-previous-or-abort)
  (define-key
    company-active-map
    (kbd "RET")
    #'company-complete-selection)

  (with-eval-after-load 'flymake
      (add-hook 'company-completion-started-hook   #'(lambda(&rest _) (flymake-mode 0))                 nil t)
      (add-hook 'company-completion-finished-hook  #'(lambda(&rest _) (flymake-mode 1) (flymake-start)) nil t)
      (add-hook 'company-completion-cancelled-hook #'(lambda(&rest _) (flymake-mode 1) (flymake-start)) nil t)
  )

  (global-set-key (kbd "s-r") #'company-yasnippet))
;; Use (kbd "TAB") (or use (kbd "<tab>"), if you want to distinguish C-i from the <tab> key)



(provide 'init-company)
