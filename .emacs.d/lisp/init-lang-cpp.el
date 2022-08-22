

;; init-lang-cpp.el --- CPP Lang Config	-*- lexical-binding: t -*-


;;; Commentary:
;;
;;  CPP Lang Config
;;

;;; Code:

;;; Use Google C Style instead
;;;
;;;  ;; put this to .clang-format
;;;  ;; --
;;;  ;;   BasedOnStyle: LLVM
;;;  ;;   UseTab: Never
;;;  ;;   IndentWidth: 8
;;;  ;;   TabWidth: 8
;;;  (defun my-c-mode-common-hook ()
;;;   (c-set-offset 'substatement-open 0)
;;;   (setq c++-tab-always-indent t)
;;;   (setq c-basic-offset 8)                  ;; Default is 2
;;;   (setq c-indent-level 8)                  ;; Default is 2
;;;   (setq tab-stop-list '(8 12 16 20 24 28 32 36 40 44 48 52 56 60))
;;;   (setq tab-width 8)
;;;   (setq indent-tabs-mode nil)  ; use spaces only if nil
;;;   )
;;;  (add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;; or just google
;; (add-hook 'c-mode-hook 'google-set-c-style)
;; (add-hook 'c++-mode-hook 'google-set-c-style)


;;; or just clang-format, from emacswiki
(require 'clang-format)



(defun my-rtags-find-symbol-at-point()
  (interactive)
  (rtags-find-symbol-at-point)
  (recenter)
)


(use-package rtags
  :ensure t
  :hook
  (c++-mode . rtags-start-process-unless-running)
  (c-mode . rtags-start-process-unless-running)
  :config
  (setq rtags-completions-enabled t)
  (setq rtags-use-helm t)
  (setq rtags-display-result-backend 'helm)
  :bind (
       ("C-c e" . my-rtags-find-symbol-at-point)
       ("C-c n" . rtags-location-stack-forward)
       ("C-c b" . rtags-location-stack-back)
       ("C-c u" . rtags-imenu)
       ("C-c r E" . rtags-find-symbol)
       ("C-c r O" . rtags-find-references)
       ("C-c r o" . rtags-find-references-at-point)
       ("C-c r s" . rtags-find-file)
       ("C-c r v" . rtags-find-virtuals-at-point)
       ("C-c r F" . rtags-fixit)
       ("C-c r P" . rtags-preprocess-file)
       ("C-c r R" . rtags-rename-symbol)
       ("C-c r x" . rtags-show-rtags-buffer)
       ("C-c r T" . rtags-print-symbol-info)
       ("C-c r t" . rtags-symbol-type)
       ("C-c r I" . rtags-include-file)
       ("C-c r i" . rtags-get-include-file-for-symbol)))


(add-hook 'c++-mode-hook 'eglot-ensure)

(provide 'init-lang-cpp)

;;; init-lang-cpp.el ends here
