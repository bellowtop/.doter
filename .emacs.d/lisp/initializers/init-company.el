;; -*- lexical-binding: t -*-
;;; init-company.el --- Company configuration

(require 'my-toggle-code-intelligence)

(use-package company
  :ensure t
  :demand t
  :hook
  (after-init . global-company-mode)
  (before-save . company-cancel)
  :config
  ;; company-mode settings
  (setq company-dabbrev-downcase nil
        ;; company-backends '((company-capf company-keywords company-files company-dabbrev))
        company-backends '((company-capf company-keywords company-files))
        )
  )

(use-package company-posframe
  :ensure t
  :after company
  :demand t
  :config
  (company-posframe-mode 1)

  ;; Face configuration
  (set-face-attribute 'company-tooltip-common nil :weight 'normal :foreground "#7FDC59")
  (set-face-attribute 'company-tooltip nil :background "black")
  (set-face-attribute 'company-tooltip-selection nil :weight 'normal)

  ;; Posframe settings
  (setq company-tooltip-scrollbar-width 0
        company-posframe-show-params (list
                                      :internal-border-color (face-foreground 'vertical-border)
                                      :internal-border-width my-posframe-border-width
                                      :left-fringe 0
                                      :right-fringe 0
                                      :line-height 1.2))

  ;; Key bindings for company-active-map
  (define-key company-active-map (kbd "<TAB>") #'company-select-next-if-tooltip-visible-or-complete-selection)
  (define-key company-active-map (kbd "<backtab>") #'company-select-previous-or-abort)
  (define-key company-active-map (kbd "RET") #'company-complete-selection)

  ;; Patch function for posframe bug fix
  (defun company-select-next-if-tooltip-visible-or-complete-selection ()
    "Select next candidate if tooltip visible, otherwise complete selection."
    (interactive)
    (if (and t (> company-candidates-length 1))
        (call-interactively 'company-select-next)
      (call-interactively 'company-complete-selection)))

  ;; Key bindings for posframe-active-map
  (define-key company-posframe-active-map (kbd "<TAB>") #'company-select-next-if-tooltip-visible-or-complete-selection)
  (define-key company-posframe-active-map (kbd "<backtab>") #'company-select-previous-or-abort)
  (define-key company-posframe-active-map (kbd "RET") #'company-complete-selection)

  ;; Hooks for eglot highlight management
  (add-hook 'company-completion-started-hook   #'my-disable-eglot-highlight)
  (add-hook 'company-completion-finished-hook  #'my-enable-eglot-highlight)
  (add-hook 'company-completion-cancelled-hook #'my-enable-eglot-highlight)

  ;; Global yasnippet binding
  (global-set-key (kbd "s-r") #'company-yasnippet))

(use-package company-prescient
  :ensure t
  :after company
  :demand t
  :config
  (company-prescient-mode 1))

(provide 'init-company)

;;; init-company.el ends here
