;; -*- lexical-binding: t -*-
;;; init-popper.el --- Popper Configuration

;;; Commentary:
;;
;;  Popup window management
;;

;;; Code:

(use-package popper
  :ensure t
  :demand t
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          help-mode
          compilation-mode))
  ;; Match eshell, shell, term and/or vterm buffers
  (setq popper-reference-buffers
        (append popper-reference-buffers
                '("^\\*eshell.*\\*$" eshell-mode ;eshell as a popup
                  "^\\*shell.*\\*$"  shell-mode  ;shell as a popup
                  "^\\*term.*\\*$"   term-mode   ;term as a popup
                  flymake-diagnostics-buffer-mode
                  "^\\*vterm.*\\*$"  vterm-mode  ;vterm as a popup
                  )))
  (popper-mode +1)
  (popper-echo-mode +1)
  :config
  (defun my-popper-maximum-height() (interactive) (setq popper-window-height (- (window-height) 2)))
  (defun my-popper-restore-height() (interactive) (setq popper-window-height 0.6))
  (my-popper-restore-height))

(provide 'init-popper)

;;; init-popper.el ends here
