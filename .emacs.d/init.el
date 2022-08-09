;; load emacs 24's package system. Add MELPA repository.
(define-key special-event-map [config-changed-event] #'ignore)

;; unset C-m, seperate it with the RET key
;; (define-key input-decode-map [?\C-m] [C-m])

;; Set garbage collection threshold to 1GB.
;; (setq gc-cons-threshold #x20000000)





(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)


(add-to-list 'exec-path "/usr/local/bin/")
(add-to-list 'exec-path "/usr/bin/")

(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
(setenv "PATH" (concat "/usr/bin:" (getenv "PATH")))


(use-package exec-path-from-shell
    :config
    (exec-path-from-shell-initialize)
)


(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))


(require 'cl)


;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (expt 2 23))))


;; (setq  x-meta-keysym 'super
;;         x-super-keysym 'meta)
;;
;; (when (eq system-type 'darwin)
;;    (setq mac-option-modifier 'super
;;          mac-command-modifier 'meta))





(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacswiki.org"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))




(global-unset-key [(control z)])




;;;;;; catch ESC in terminal(-nw) ;;;;;;;;;;;;
(defvar personal/fast-keyseq-timeout 50)
(defun personal/-tty-ESC-filter (map)
  (if (and (equal (this-single-command-keys) [?\e])
           (sit-for (/ personal/fast-keyseq-timeout 1000.0)))
      [escape] map))
(defun personal/-lookup-key (map key)
  (catch 'found
    (map-keymap (lambda (k b) (if (equal key k) (throw 'found b))) map)))
(defun personal/catch-tty-ESC ()
  "Setup key mappings of current terminal to turn a tty's ESC into `escape'."
  (when (memq (terminal-live-p (frame-terminal)) '(t pc))
    (let ((esc-binding (personal/-lookup-key input-decode-map ?\e)))
      (define-key input-decode-map
        [?\e] `(menu-item "" ,esc-binding :filter personal/-tty-ESC-filter)))))
(personal/catch-tty-ESC)





(setq visible-bell t)
(setq ring-bell-function #'ignore)

(setq-default cursor-type 'bar)



(require 'expand-region)



(toggle-truncate-lines t)



;; (use-package doom-themes
;;   :ensure t
;;   :config
;;   (setq doom-themes-enable-bold nil    ; if nil, bold is universally disabled
;;         doom-themes-enable-italic nil) ; if nil, italics is universally disabled
;;   ;; (doom-themes-neotree-config)
;;   ;; (load-theme 'doom-xcode t)
;;   (load-theme 'doom-dracula t)
;;   ;; (load-theme 'doom-oceanic-next t)
;;   )

;;      ;; (load-theme 'spacemacs-dark t)
;;      ;;(load-theme 'dracula t)
;;      ;; (load-theme 'spacemacs-dark t)
;;      ;; (load-theme 'dracula t)
;;      ;; (load-theme 'kaolin-ocean t)
;; (load-theme 'cyberpunk t)

(load-theme 'atom-one-dark t)



(setq-default line-spacing 0)

(set-face-attribute 'default nil :font "Dejavu Sans Mono for Powerline-14")
(add-to-list 'default-frame-alist '(font . "Dejavu Sans Mono for Powerline-14"))
(set-cursor-color "red")

;; (set-face-attribute 'region nil :background "#666")



;; (load-theme 'doom-molokai t)
;; (load-theme 'doom-palenight t)
;; (load-theme 'doom-material t)
;; (load-theme 'doom-dracula t)
;; (load-theme 'kaolin-aurora t)
;; (load-theme 'challenger-deep t)
;; (load-theme 'kaolin-temple t)
;; (load-theme 'kaolin-ocean t)
;; (load-theme 'doom-material t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(deadgrep-match-face ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(deadgrep-search-term-face ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(eglot-highlight-symbol-face ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(highlight ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(hydra-face-red ((t (:foreground "chocolate" :weight bold))))
 '(iedit-occurrence ((t (:background "yellow" :foreground "black" :inverse-video nil))))
 '(lazy-highlight ((t (:background "yellow" :foreground "black" :inverse-video nil))))
 '(lsp-face-highlight-read ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(lsp-face-highlight-textual ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(lsp-face-highlight-write ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(mc/region-face ((t (:foreground "#ff77cc" :inverse-video t :weight normal))))
 '(next-error ((t (:foreground "#000000" :background "#00ff00"))))
 '(region ((t (:background "#9ac76c" :foreground "#262626" :underline nil :weight normal))))
 '(show-paren-match ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(treemacs-root-face ((t :inherit font-lock-constant-face :underline t :bold t :height 1.0))))




;; (set-face-attribute 'mode-line nil :underline "#00ff00")
;; (set-face-attribute 'mode-line-inactive nil :underline "#209920")

;; Display dividers between windows
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(add-hook 'window-setup-hook #'window-divider-mode)

(set-face-background 'vertical-border (face-background 'default))
(set-face-foreground 'vertical-border "#00ff00")

;; (set-face-background 'line-number (face-background 'default))

;; (global-font-lock-mode -1)


;; Set symbol for the border
(set-display-table-slot standard-display-table
                        'vertical-border
                        (make-glyph-code ?│))



;; (global-set-key [remap lsp-ui-peek-find-definitions] 'my-lsp-ui-peek-find-definitions )
;; (global-set-key [remap xref-pop-marker-stack] 'my-xref-pop-marker-stack )
;; (global-set-key [remap xref-go-back] 'my-xref-go-back)
;; (defun my-lsp-ui-peek-find-definitions()
;;   (interactive)
;;   (lsp-ui-peek-find-definitions)
;;   (recenter)
;; )
;; (defun my-xref-pop-marker-stack()
;;   (interactive)
;;   (xref-pop-marker-stack)
;;   (recenter)
;; )
;; (defun my-xref-go-back()
;;   (interactive)
;;   (xref-go-back)
;;   (recenter)
;; )


(defun my-recenter (&optional ARG PRED)
  (recenter)
  ;; from crosshairs.el
  ;; (flash-crosshairs)
)

(advice-add 'xref-go-back                   :after 'my-recenter)
(advice-add 'xref-pop-marker-stack          :after 'my-recenter)
(advice-add 'lsp-ui-peek-find-definitions   :after 'my-recenter)
(advice-add 'pop-global-mark                :after 'my-recenter)
(advice-add 'xref-after-jump-hook           :after 'my-recenter)





;; override jump hook
;; (setq xref-after-jump-hook '(hs-show-all recenter xref-pulse-momentarily))







(setq dap-java-test-runner (expand-file-name "~/.emacs.d/.local/eclipse.jdt.ls/test-runner/junit-platform-console-standalone.jar"))
(setq dap-breakpoints-file (expand-file-name "~/.emacs.d/.local/.dap-breakpoints"))


(setq eglot-java-junit-platform-console-standalone-jar (expand-file-name "~/.emacs.d/.local/eclipse.jdt.ls/test-runner/junit-platform-console-standalone.jar"))






(require 'init-funcs)

(require 'init-eglot)

(require 'init-lang-java)

(require 'download-lombok)

(require 'init-lang-go)




(defun my-joindirs (root &rest dirs)
  "Joins a series of directories together, like Python's os.path.join,
  (dotemacs-joindirs \"/tmp\" \"a\" \"b\" \"c\") => /tmp/a/b/c"
  (if (not dirs)
      root
    (apply 'joindirs
           (expand-file-name (car dirs) root)
           (cdr dirs))))



;; company-mode
(add-hook 'after-init-hook 'global-company-mode)







(use-package yasnippet
    :defer t)
(add-hook 'prog-mode-hook 'yas-minor-mode)


;; all themes safe
(setq custom-safe-themes t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#14141e" "#e84c58" "#35BF88" "#dbac66" "#4ca6e8" "#c79af4" "#6bd9db" "#e6e6e8"])
 '(helm-minibuffer-history-key "M-p")
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(atom-one-dark-theme py-autopep8 jdecomp smart-jump eglot-java eglot yasnippet-snippets ansible moe-theme selected benchmark-init with-proxy exec-path-from-shell lsp-java valign markdown-toc markdownfmt disable-mouse rainbow-delimiters key-chord google-c-style lua-mode phi-search doom-modeline dracula-theme switch-buffer-functions iedit scala-mode multiple-cursors rtags yasnippet erlang highlight-parentheses all-the-icons undo-tree nimbus-theme challenger-deep-theme kaolin-themes spacemacs-theme afternoon-theme ivy golden-ratio-scroll-screen smooth-scrolling yaml-mode projectile-mode doom-themes smart-mode-line cyberpunk-theme cmake-mode magit lsp-python-ms protobuf-mode vue-mode web-mode centaur-tabs xclip smartparens god-mode rust-mode flycheck mwim which-key deadgrep ripgrep lsp-ui neotree expand-region easy-kill projectile helm-rg helm-ag use-package helm fzf company lsp-mode go-mode))
 '(pos-tip-background-color "#1d1d2b")
 '(pos-tip-foreground-color "#d4d4d6")
 '(safe-local-variable-values
   '((projectile-project-root . "~/deploy")
     (eval progn
	   (pp-buffer)
	   (indent-buffer))))
 '(warning-suppress-log-types '((comp) (use-package) (lsp-mode)))
 '(warning-suppress-types '((use-package) (lsp-mode))))




;; lsp-mode session file
(setq lsp-session-file (expand-file-name "~/.emacs.d/.local/.lsp-session-v1"))




(global-whitespace-mode -1)
(setq whitespace-style '(face trailing tabs tab-mark))
(setq whitespace-line-column 85)


(use-package iedit
  :defer t
  :bind
  ("C-c i" . iedit-mode)
)





(use-package ace-window
  :defer t
  :delight
  :config
  (ace-window-display-mode 1)
  )

;; alternatively, use Shift-<left> Shift-<right> to move cursor to window
;; for iTerms2 user, disable alt-> alt-< to send alt-f alt-b in `profile->keys`
 (windmove-default-keybindings 'meta)


;; (use-package centaur-tabs
;;   :ensure t
;;   :defer t
;;   :demand
;;   :config
;;   (centaur-tabs-mode t)
;;   :custom
;;   (centaur-tabs-gray-out-icons 'buffer)
;;   (centaur-tabs-style "rounded")
;;   (centaur-tabs-height 36)
;;   (centaur-tabs-set-icons t)
;;   (centaur-tabs-set-modified-marker t)
;;   (centaur-tabs-modified-marker "?")
;;   (centaur-tabs-buffer-groups-function #'centaur-tabs-projectile-buffer-groups)
;;   :bind
;;   ("M-h" . centaur-tabs-backward)
;;   ("M-l" . centaur-tabs-forward)
;; )


(use-package py-autopep8
  :defer t
  :init
)
(add-hook 'python-mode-hook 'py-autopep8-mode)




(use-package rust-mode
  :defer t
  :init
)

(use-package scala-mode
  :defer t
  :interpreter
  ("scala" . scala-mode)
)

(use-package yaml-mode
    :ensure t
    :init
    :config
    (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
    (add-to-list 'auto-mode-alist '("\\.yml\\.j2\\'" . yaml-mode))
    (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
    (add-to-list 'auto-mode-alist '("\\.yaml\\.j2\\'" . yaml-mode))
)



(use-package ansible
  :defer t
)


;; line number fixed width
(setq display-line-numbers-width-start t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'markdown-mode-hook 'display-line-numbers-mode)
(add-hook 'nxml-mode-hook 'display-line-numbers-mode)
(add-hook 'yaml-mode-hook 'display-line-numbers-mode)
(add-hook 'yaml-mode-hook #'(lambda () (ansible 1)))


;; delete all other buffers, only keep current one.
(defun my-only-current-buffer ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer)
                (remove-if-not 'buffer-file-name (buffer-list)))))


(add-hook 'before-save-hook #'delete-trailing-whitespace)


;; (global-auto-revert-mode t)


(defun my-go-mode-hook ()
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)



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




(defun my-tab-4-indent ()
    (setq tab-width 4)                  ;; Default is 2
    (setq c-basic-offset 4)                  ;; Default is 2
    (setq c-indent-level 4)                  ;; Default is 2
    (setq indent-tabs-mode nil)              ;; use spaces only if nil
)



(defun indent-between-pair (&rest _ignored)
  (newline)
  (indent-according-to-mode)
  (forward-line -1)
  (indent-according-to-mode))




(use-package smartparens
  :ensure t
  :defer t
  :pin melpa-stable
  :init (smartparens-global-mode t)
  :config
  (sp-local-pair 'prog-mode "{" nil :post-handlers '((indent-between-pair "RET")))
  (sp-local-pair 'prog-mode "[" nil :post-handlers '((indent-between-pair "RET")))
  (sp-local-pair 'prog-mode "(" nil :post-handlers '((indent-between-pair "RET")))
  (sp-local-pair 'prog-mode ")" nil :post-handlers '((indent-between-pair "RET")))
  ;; :bind
  ;; (
  ;;   ("C-c p d" . sp-splice-sexp)
  ;;   ("C-c p s" . sp-rewrap-sexp)
  ;;  )
)


;;
;; borrow from https://github.com/lujun9972/emacs-document/blob/master/emacs-common/Smartparens%E7%94%A8%E6%B3%95%E8%AF%A6%E8%A7%A3.org#key
;;
(defmacro def-region-pairs (pairs)
  "Define functions for pairing. PAIRS is an alist of (NAME . STRING)
conses, where NAME is the function name that will be created and
STRING is a single-character string that marks the opening character.

  (def-pairs ((paren . \"(\")
              (bracket . \"[\"))

defines the functions WRAP-WITH-PAREN and WRAP-WITH-BRACKET,
respectively."
  `(progn
     ,@(cl-loop for (key . val) in pairs
             collect
             `(defun ,(read (concat
                             "my-wrap-region-with-"
                             (prin1-to-string key)
                             "s"))
                  (start stop)
                (interactive "r")
                (sp-wrap-with-pair ,val)

                (goto-char (+ 1 start))
                (push-mark (+ 1 stop))
                (setq deactivate-mark  nil)

                ))))

(def-region-pairs ((paren . "(")
            (bracket . "[")
            (brace . "{")
            (single-quote . "'")
            (double-quote . "\"")
            (back-quote . "`")))
(bind-keys :map smartparens-mode-map
     ("C-c ("  . my-wrap-region-with-parens)
     ("C-c ["  . my-wrap-region-with-brackets)
     ("C-c {"  . my-wrap-region-with-braces)
     ("C-c '"  . my-wrap-region-with-single-quotes)
     ("C-c \"" . my-wrap-region-with-double-quotes)
     ("C-c _"  . my-wrap-region-with-underscores)
     ("C-c `"  . my-wrap-region-with-back-quotes))










(require 'emacs-surround)
;; (global-set-key (kbd "C-c p") 'emacs-surround)
(add-to-list 'emacs-surround-alist '("}" . ("{ " . " }")))
(add-to-list 'emacs-surround-alist '(")" . ("( " . " )")))
(add-to-list 'emacs-surround-alist '("]" . ("[ " . " ]")))





(require 'helm)
(require 'helm-command)
(helm-mode 1)
(define-key helm-map (kbd "C-u")       #'my-delete-to-beginning)
(define-key helm-M-x-map (kbd "C-u")   #'my-delete-to-beginning)
(define-key helm-map (kbd "TAB")       #'helm-next-line)
(define-key helm-map (kbd "<backtab>") #'helm-previous-line)


;; (setq helm-move-to-line-cycle-in-source t)
(setq helm-display-buffer-default-height 0.4)
(setq helm-default-display-buffer-functions '(display-buffer-in-side-window))
(setq helm-boring-buffer-regexp-list (list
                      (rx "*helm")
                      (rx "*Message")
                      (rx "*Help")
                      (rx "*Echo Area")
                      (rx "*Minibuf")
                      (rx "*lsp")
                      (rx "*jdtls")
                      (rx " *")
                      ))



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





;; (use-package ivy
;;   :ensure t
;;   :diminish ivy-mode
;;   :hook (after-init . ivy-mode))



(delete-selection-mode 1)

(add-hook 'org-mode-hook #'valign-mode)
(add-hook 'markdown-mode-hook #'valign-mode)



;; (require 'smooth-scrolling)
;; (smooth-scrolling-mode 1)


;; (require 'golden-ratio-scroll-screen)
;; (global-set-key [remap scroll-down-command] 'golden-ratio-scroll-screen-down)
;; (global-set-key [remap scroll-up-command] 'golden-ratio-scroll-screen-up)

 (setq scroll-margin 3
       scroll-conservatively 101
       scroll-up-aggressively 0.01
       scroll-down-aggressively 0.01
       ;; scroll-preserve-screen-position 'always
       auto-window-vscroll nil)

(defun scroll-half-page-down ()
  "scroll down half the page"
  (interactive)
  (scroll-down (/ (window-body-height) 2)))

(defun scroll-half-page-up ()
  "scroll up half the page"
  (interactive)
  (scroll-up (/ (window-body-height) 2)))

(defun scroll-other-window-half-page-up ()
  "scroll down half the page"
  (interactive)
  (scroll-other-window (/ (window-body-height) 2)))

(defun scroll-other-window-half-page-down ()
  "scroll up half the page"
  (interactive)
  (scroll-other-window (- 0 (/ (window-body-height) 2))))


(global-set-key [remap scroll-down-command] #'scroll-half-page-down)
(global-set-key [remap scroll-up-command] #'scroll-half-page-up)
(define-key global-map [(meta up)] #'(lambda() (interactive) (scroll-other-window-half-page-down)))
(define-key global-map [(meta down)] #'(lambda() (interactive) (scroll-other-window-half-page-up)))


(add-to-list 'default-frame-alist
             '(vertical-scroll-bars . nil))




;; (setq sml/theme 'dark)
;; (sml/setup)




(defun my-escape-key ()
    (interactive)
    (my-god-mode)
    (if isearch-mode (isearch-abort))
    (when (bound-and-true-p multiple-cursors-mode) (multiple-cursors-mode -1))
    (when (bound-and-true-p iedit-mode) (iedit-done))  ;; exit iedit mode, if needed.
    (keyboard-quit)
)

(global-set-key (kbd "<escape>") #'my-escape-key)
(define-key helm-map (kbd "<escape>") #'helm-keyboard-quit)
(define-key minibuffer-local-map (kbd "<escape>") #'minibuffer-keyboard-quit)





;; must be set as global
(global-set-key (kbd "M-k") #'my-delete-to-beginning )
(global-set-key (kbd "C-k") #'my-delete-to-end )



(tool-bar-mode -1)
(menu-bar-mode -1)
(smerge-mode -1)
(scroll-bar-mode -1)
(tab-bar-mode -1)


; (smerge-mode -1)
; (menu-bar-mode -1)
; (tool-bar-mode -1)

(when (display-graphic-p)
    ;; awesome-tray is from emacswiki sub-directory
    (setq awesome-tray-mode-line-active-color '"#00ff00")

    (require 'awesome-tray)
    (awesome-tray-mode 1)

    ;; (scroll-bar-mode -1)
    ;; (tab-bar-mode -1)
    (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
    (add-to-list 'default-frame-alist '(ns-appearance . dark))  ;; dark themes use "dark"

    (global-set-key [escape] 'my-escape-key)
    (define-key input-decode-map [?\C-\[] (kbd "<C-[>"))
    (global-set-key (kbd "<C-[>") 'my-escape-key)
)

(unless (display-graphic-p)
    (setq doom-modeline-height 1)
    (setq doom-modeline-icon nil)
    (setq doom-modeline-bar-width -1)
    (require 'doom-modeline)
    (doom-modeline-mode 1)
)

;;  (unless (display-graphic-p)
;;    ; (set-face-attribute 'default nil :background "nil")
;;    ;; (set-face-attribute 'line-number nil :background "nil")
;;    ;; (set-face-attribute 'line-number-current-line nil :background "nil")
;;  )

;; (when (display-graphic-p)
;;   (set-face-attribute 'default nil :font "Dejavu Sans Mono for Powerline-14")
;;   (set-cursor-color "red")
;; )





(projectile-mode 1)
(setq projectile-enable-caching t)
(setq projectile-cache-file          (expand-file-name "~/.emacs.d/.local/projectile.cache"))
(setq projectile-known-projects-file (expand-file-name "~/.emacs.d/.local/projectile-bookmarks.eld"))





;; scroll with cursor not move
(defun gcm-scroll-down ()
      (interactive)
      (scroll-up 1))
(defun gcm-scroll-up ()
      (interactive)
      (scroll-down 1))




(defun flip-buffer-to-window ()
  "Flips to the last-visited buffer in this window."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer))))



(defun json-to-single-line (beg end)
  "Collapse prettified json in region between BEG and END to a single line"
  (interactive "r")
  (if (use-region-p)
      (save-excursion
        (save-restriction
          (narrow-to-region beg end)
          (goto-char (point-min))
          (while (re-search-forward "[[:space:]\n]+" nil t)
            (replace-match " "))))
    (print "This function operates on a region")))


(defun un-indent-by-removing-4-spaces ()
  "remove 4 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-line)
      ;; get rid of tabs at beginning of line
      (when (looking-at "^\\s-+")
        (untabify (match-beginning 0) (match-end 0)))
      (when (looking-at "^    ")
        (replace-match "")))))




(defun my-hs-toggle-all ()
  "If anything isn't hidden, run `hs-hide-all', else run `hs-show-all'."
  (interactive)
  (hs-minor-mode 1)
  (let ((starting-ov-count (length (overlays-in (point-min) (point-max)))))
    (hs-hide-all)
    (when (equal (length (overlays-in (point-min) (point-max))) starting-ov-count)
        (hs-show-all)
        (recenter)
      )))



(defun my-hs-toggle-hiding ()
  (interactive)
  (hs-minor-mode 1)
   (if (hs-already-hidden-p)
       (hs-show-block)
     (hs-hide-block)))




(defun my-hide-all()
  (interactive)
  (hs-minor-mode 1)
  (hs-hide-all)
)
;; (add-hook 'prog-mode-hook 'my-hide-all)



(defun my-show-file-name ()
  (interactive)
  (message (buffer-file-name)))



(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position) (line-beginning-position 2)))))






(require 'avy)
(set-face-attribute 'avy-lead-face nil :foreground "#000000" :background "#ffff00")
(set-face-attribute 'avy-lead-face-0 nil :foreground "#000000" :background "#ffff00")
;; (set-face-attribute 'avy-lead-face nil :foreground "#ffffff" :background "#ff0000")
;; (set-face-attribute 'avy-lead-face-0 nil :foreground "#ffffff" :background "#ff0000")
(setq avy-keys (list ?a ?c ?d ?e ?f ?h ?i ?j ?k ?l ?m ?n ?o ?s ?v ?w ?\;))






(setq auto-save-list-file-prefix (expand-file-name "~/.emacs.d/.local/auto-save-list/"))
(setq create-lockfiles nil)
(setq backup-directory-alist '(("" . "~/.emacs.d/.local/backup")))
(setq recenter-redisplay nil)

(setq recentf-save-file (expand-file-name "~/.emacs.d/.local/recentf"))

(which-key-mode 1)


(xclip-mode 1)



(require 'mwim)


(defun buffer-mode (&optional buffer-or-name)
  "Returns the major mode associated with a buffer.
If buffer-or-name is nil return current buffer's mode."
  (buffer-local-value 'major-mode
   (if buffer-or-name (get-buffer buffer-or-name) (current-buffer))))





;; special-buffers are not affected by god-mode bindings, but affected by my-special-buffer-keys-minor-mode-map
(setq special-buffers (list
                        "*Backtrace*"
                        "*Pos-Frame-Read*"
                        "*Treemacs"
                        "*Messages*"
                        "HELLO"
                        "*Ibuffer*"
                        "*deadgrep"
                        "*xref"
                        "*Buffer"
                        "*Packages"
                        "*lsp-log*"
                        "*Help*"
                        "*info*"
                        "helm-*"
                        "*helm-mode-switch-to-buffer*"
                        "*Helm Help*"
                        "*ansi-term*"
                        "*fzf*"
                        "*NeoTree*"))

;; legendary-buffers are not affected by god-mode AND my-special-buffer-keys-minor-mode-map
(setq legendary-buffers (list "*this-buffer-is-left-alone-without-god-mode-at-all" "*Minibuf"))

(setq legendary-modes (list "*this-buffer-is-left-alone-without-god-mode-at-all" "dired-mode" "cfrs-input-mode" ))

(require 'god-mode)
(setq god-exempt-major-modes nil)
(setq god-exempt-predicates nil)

(defun my-god-this-is-special-buffer (bufname)
  (interactive)
  (let
    (
     (this-buffer-name (string-trim bufname))
    )
    (seq-filter
      (lambda (n) (string-prefix-p n this-buffer-name))
      special-buffers)
   )

)

(defun* my-god-this-is-legendary-buffer (bufname)
  (interactive)
  ;; (message "buffer-mode type is %s" (type-of (buffer-mode bufname))) ==> symbol
  ;;;; use symbol-name convert symbol to string; And for the reverse, (intern "some-string") to get symbol
  (let
    (
     (this-buffer-name (string-trim bufname))
     (this-buffer-mode (symbol-name (buffer-mode bufname)))
    )
    ;; (message "this-buffer-name %s" this-buffer-name)
    ;; (message "this-buffer-mode %s" this-buffer-mode)
    (or
        (seq-filter
          (lambda (n) (string-prefix-p n this-buffer-name))
          legendary-buffers)
        (seq-filter
          (lambda (n) (string-prefix-p n this-buffer-mode))
          legendary-modes)
    )
  )
)

(defun* my-god-mode ()
  (interactive)

  (if (my-god-this-is-legendary-buffer (buffer-name))
        (progn
            ;; (message "%s is legendary buffer" (buffer-name))
            (return-from my-god-mode)
        )
        (progn
            ;; (message "%s is not legendary buffer, continue" (buffer-name))
         )
    )

  (if (my-god-this-is-special-buffer (buffer-name))
            (progn
                ;; (message "%s is special buffer" (buffer-name))
                (ignore)
                (my-special-buffer-keys-minor-mode 1)
            )
            (progn
                ;; (message "%s not a special buffer" (buffer-name))
                (god-local-mode 1)                  ;; start local mode
                (my-special-buffer-keys-minor-mode 0)
             )
    nil)
)

(defun my-quit-god-mode()
  (interactive)
  (god-local-mode -1)
  )






(defun my-toggle-god-mode()
  (interactive)
    (if (bound-and-true-p god-local-mode)
        (my-quit-god-mode)
        (my-god-mode)
    )
  )




(defun my-god-mode-with-switch-any-buffer(prev curr)
    (cl-assert (eq curr (current-buffer)))  ;; Always t
    ;; (message "%S -> %S -> %S" prev curr (string-trim (buffer-name curr)))
    (my-god-mode)
  )
(add-hook 'switch-buffer-functions #'my-god-mode-with-switch-any-buffer)





(defun my-god-above-newline-and-insert-mode()
  (interactive)
  (beginning-of-line)
  (newline-and-indent)
  (previous-line)
  (god-mode-all)
  )

(defun my-god-below-newline-and-insert-mode()
  (interactive)
  (end-of-line)
  (newline-and-indent)
  (god-mode-all)
  )

(defun my-god-mwin-end-and-insert-mode()
  (interactive)
  (mwim-end-of-code-or-line)
  (god-mode-all)
  )

(defun my-god-mwin-beginning-and-insert-mode()
  (interactive)
  (mwim-beginning-of-code-or-line)
  (god-mode-all)
  )

(defun my-god-char-forward-and-insert-mode()
  (interactive)
  (forward-char)
  (god-mode-all)
  )

(defun my-move-to-end-of-word ()
  "Move to the next 'last character' of a word."
  (interactive)
  (forward-char)
  (re-search-forward "\\w\\b" nil t)
  (goto-char (match-beginning 0)))

(defun my-delete-to-beginning(args)
  (interactive "p")
  (set-mark-command nil)
  (mwim-beginning-of-code-or-line)
  (delete-region (region-beginning) (region-end))
  )

(defun my-delete-to-end(args)
  (interactive "p")
  (set-mark-command nil)
  (mwim-end-of-line)
  (delete-region (region-beginning) (region-end))
  )

;; donot warnning, just wrap search
(defun isearch-repeat-forward+ ()
  (interactive)
  (unless isearch-forward
    (goto-char isearch-other-end))
  (isearch-repeat-forward)
  (unless isearch-success
    (isearch-repeat-forward))
  ;; (recenter)
)
(defun isearch-repeat-backward+ ()
  (interactive)
  (when (and isearch-forward isearch-other-end)
    (goto-char isearch-other-end))
  (isearch-repeat-backward)
  (unless isearch-success
    (isearch-repeat-backward))
  ;; (recenter)
)

(require 'god-mode-isearch)
(define-key isearch-mode-map (kbd "TAB") #'god-mode-isearch-activate)
(define-key god-mode-isearch-map (kbd "TAB") #'god-mode-isearch-disable)
;; RET to god, then RET to exit
;; (define-key isearch-mode-map (kbd "RET") #'god-mode-isearch-activate)
(define-key isearch-mode-map (kbd "RET") #'isearch-exit)
(define-key god-mode-isearch-map (kbd "RET") #'isearch-exit)

(define-key isearch-mode-map (kbd "C-s") 'isearch-repeat-forward+)
(define-key isearch-mode-map (kbd "C-r") 'isearch-repeat-backward+)
(define-key god-mode-isearch-map (kbd "s") 'isearch-repeat-forward+)
(define-key god-mode-isearch-map (kbd "r") 'isearch-repeat-backward+)
;; like vim
(define-key god-mode-isearch-map (kbd "n") 'isearch-repeat-forward+)
(define-key god-mode-isearch-map (kbd "N") 'isearch-repeat-backward+)


(defun my-search-selection ()
      "search for selected text"
      (interactive
        (progn
            (if (region-active-p)
               (message "search the marked region")
               (progn
                 (er/mark-symbol)
                 (setq my-search-selection-is-word-search 1)                                         ;; set flag
               )
            )
            (let (
                  (selection (buffer-substring-no-properties (mark) (point)))
                  (case-fold-search (if (boundp 'my-search-selection-is-word-search) nil 'default))  ;; test flag
                 )

              (deactivate-mark)
              (isearch-mode t nil nil nil)

              (if (boundp 'my-search-selection-is-word-search) (isearch-toggle-word))                ;; test flag
              (makunbound 'my-search-selection-is-word-search)                                       ;; clear flag anyway

              ;; activate god-mode-isearch
              (god-mode-isearch-activate)
              (isearch-yank-string selection)
            )
        )
      )
)

(defun my-isearch-forward ()
      (interactive)
      (isearch-mode t nil nil nil)
      (god-mode-isearch-activate)
      (isearch-repeat-forward+)
)


(defun my-isearch-backward ()
      (interactive)
      (isearch-mode nil nil nil nil)
      (god-mode-isearch-activate)
      (isearch-repeat-backward+)
)


(defun my-disable-lsp-highlighting()
  (if (boundp 'lsp-enable-symbol-highlighting)
    (if (and lsp-enable-symbol-highlighting t)
      (lsp-toggle-symbol-highlight)
      (message "is already not highlight")
      )
  )
)

(defun my-enable-lsp-highlighting()
  (if (boundp 'lsp-enable-symbol-highlighting)
    (if (not lsp-enable-symbol-highlighting)
      (lsp-toggle-symbol-highlight)
      (message "is enabled highlight")
      )
  )
)

(add-hook 'isearch-mode-hook #'my-disable-lsp-highlighting)
(add-hook 'isearch-mode-end-hook #'my-enable-lsp-highlighting)



;; (defun my-quit-mc-mode-if-need ()
;;     (interactive)
;;     (if (bound-and-true-p multiple-cursors-mode)
;;       (progn (mc/keyboard-quit) (mc/keyboard-quit))  ;; have to double quit, i don't know why
;;     )
;;   )



;; (defun my-quit ()
;;     (interactive)
;;     (my-god-mode)
;;     (if isearch-mode (isearch-abort))
;;     (ignore-errors (helm-keyboard-quit))
;;     (ignore-errors (minibuffer-keyboard-quit))
;;     (ignore-errors (keyboard-quit))
;; )



;; (global-set-key (kbd "C-q")      '(lambda () (interactive)
;;                                     (my-quit-mc-mode-if-need)
;;                                     (my-quit))
;; )


(setq hl-line-inhibit-highlighting-for-modes '(dired-mode deadgrep-mode deadgrep-edit-mode treemacs-mode))
(global-hl-line-mode 1)

;;; from emacswiki
(require 'crosshairs)



(defun my-god-mode-update-mode-line ()
  (cond
   (god-local-mode
    (set-face-attribute 'mode-line nil
                        :background "green"
                        :foreground "black")
    (set-face-attribute 'mode-line-inactive nil
                        :background "#565063"
                        :foreground "white"
                        :box '(:line-width 8 :color "#565063")
                        :overline nil
                        :underline nil))
   ;; below, the default color is borrowed from monokai theme
   (t
    (set-face-attribute 'mode-line nil
                        :foreground "#F5F5F5"
                        :background "#1B1E1C")
    (set-face-attribute 'mode-line-inactive nil
                        :foreground "#8B8878"
                        :background "#1B1E1C"))
   ))


(defun my-god-mode-update-cursor-type ()
  ;; (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar))

    (if (bound-and-true-p god-local-mode)
      (progn
        ;; only terminal need this
        ;; (unless (display-graphic-p)
                (set-face-attribute 'hl-line nil :background (face-attribute 'default :background))
        ;; )
        (set-face-attribute 'line-number-current-line nil :foreground "#00ff00")
        ;; (setq cursor-type 'box)
      )

      (progn
        ;; only terminal need this
        ;; (unless (display-graphic-p)
                (set-face-attribute 'hl-line nil :background "gray10")
        ;; )
        (set-face-attribute 'line-number-current-line nil :foreground "#3f4040")
        ;; (setq cursor-type 'bar)
      )
    )

)

(add-hook 'god-mode-enabled-hook  'my-god-mode-update-cursor-type)
(add-hook 'god-mode-disabled-hook  'my-god-mode-update-cursor-type)




(toggle-truncate-lines t)



(use-package all-the-icons
    :config
    (setq all-the-icons-scale-factor 1.0)
    (setq all-the-icons-default-adjust 0.0)
)



(use-package neotree
  :defer t
  :init
  (setq neo-theme 'arrow)
  ;; (setq neo-auto-indent-point 't)
  (setq neo-confirm-create-file 'off-p)
  (setq neo-confirm-create-directory 'off-p)
  (setq neo-smart-open 't)
  (setq neo-window-fixed-size nil)
  ;; (setq neo-window-width (/ (display-pixel-width) 4))
  (setq neo-window-width 45)
  ;; (setq neo-toggle-window-keep-p 't)
)
(with-eval-after-load 'neotree
  (define-key neotree-mode-map (kbd "L") #'(lambda () (interactive) (setq neo-window-width (/ (display-pixel-width) 2)) (neotree-hide) (my-neotree-find)))
  ;; (define-key neotree-mode-map (kbd "H") #'(lambda () (interactive) (setq neo-window-width 35) (neotree-hide) (my-neotree-find)))
  (define-key neotree-mode-map (kbd "H") #'(lambda () (interactive) (setq neo-window-width (/ (display-pixel-width) 4)) (neotree-hide) (my-neotree-find)))
  (define-key neotree-mode-map (kbd "t") #'(lambda () (interactive) (neotree-hidden-file-toggle)))
  (define-key neotree-mode-map (kbd "a") 'mwim-beginning-of-code-or-line)
  (define-key neotree-mode-map (kbd "e") 'mwim-end-of-code-or-line)
)


(defun neotree-project-dir ()
    "Open NeoTree using the git root."
    (interactive)
    (let ((project-dir (projectile-project-root))
          (file-name (buffer-file-name)))
      (neotree-toggle)
      (if project-dir
          (if (neo-global--window-exists-p)
              (progn
                (neotree-dir project-dir)
                (neotree-find file-name)))
        (message "Could not find git project root."))))

(defun my-neotree-toggle()
  (interactive)
  (if (and (fboundp 'neo-global--window-exists-p) (neo-global--window-exists-p))
    (neotree-project-dir)
    (neotree-show)
  )
)

(defun my-neotree-find()
  (interactive)
  (unless (fboundp 'neo-global--window-exists-p) (neotree-show))
  (unless (neo-global--window-exists-p) (neotree-show))
  (neotree-find)
)




(setq treemacs-persist-file (expand-file-name "~/.emacs.d/.local/treemacs-persist"))
(setq treemacs-last-error-persist-file (expand-file-name "~/.emacs.d/.local/treemacs-persist-at-last-error"))

(use-package treemacs
  :ensure t
  :init
  :config
  (treemacs-resize-icons 18)
  (treemacs-follow-mode -1)
   :bind (
        ("C-c n" . treemacs)
        ("C-c t" . treemacs-toggle-node)
   )
)


(defun my-helm-ag-thing-at-point ()
  "Search the symbol at point with `helm-ag'."
  (interactive)
  (
   let (
        (helm-ag-insert-at-point 'symbol)
        (helm-ag-command-option " -Q ")
   )
   (helm-do-ag-project-root)
  )
)



(setq mc/list-file (expand-file-name "~/.emacs.d/.local/.mc-lists.el"))

(setq mc/match-cursor-style nil)
(use-package multiple-cursors
  :ensure t
  :config
  :bind (
         ("C-x C-n" . mc/mark-next-like-this)
         ("C-c C-SPC" . mc/edit-lines)
  )
)



(defun my-mc/mark-next-like-this (arg)
  (interactive "p")
  (if (region-active-p)
               (message "search the marked region")
               (er/mark-symbol)
               )
  (mc/mark-next-like-this-word arg)
  ;; copy from multiple-cursors-20211112.2223/mc-cycle-cursors.el
  (mc/cycle (mc/furthest-cursor-after-point)
            (mc/first-fake-cursor-after (point-min))
               "We're already at the last cursor.")
  )

(defun my-mc/mark-previous-like-this (arg)
  (interactive "p")
  (if (region-active-p)
               (message "search the marked region")
               (er/mark-symbol)
               )
  (mc/mark-previous-like-this-word arg)
  ;; copy from multiple-cursors-20211112.2223/mc-cycle-cursors.el
  (mc/cycle (mc/furthest-cursor-before-point)
            (mc/last-fake-cursor-before (point-max))
              "We're already at the last cursor")
  )

(defun my-mc/skip-to-next-like-this (arg)
  (interactive "p")
  ;; copy from multiple-cursors-20211112.2223/mc-cycle-cursors.el
  (mc/cycle (mc/furthest-cursor-before-point)
            (mc/last-fake-cursor-before (point-max))
              "We're already at the last cursor")
  (mc/skip-to-next-like-this)
  ;; copy from multiple-cursors-20211112.2223/mc-cycle-cursors.el
  (mc/cycle (mc/furthest-cursor-after-point)
            (mc/first-fake-cursor-after (point-min))
               "We're already at the last cursor.")
  )

(with-eval-after-load 'multiple-cursors-core
    (define-key mc/keymap (kbd "TAB") 'mc/cycle-forward)
    (define-key mc/keymap (kbd "<backtab>") 'mc/cycle-backward)
    (define-key mc/keymap (kbd "C-x C-n") 'my-mc/mark-next-like-this)
    (define-key mc/keymap (kbd "C-x C-p") 'my-mc/mark-previous-like-this)
    (define-key mc/keymap (kbd "C-x C-a") 'mc/mark-all-like-this)
    (define-key mc/keymap (kbd "C-x C-s") 'my-mc/skip-to-next-like-this)
    (define-key mc/keymap (kbd "C-x C-r") 'mc/skip-to-previous-like-this)
    (define-key mc/keymap (kbd "C-x C-x") 'mc/unmark-next-like-this)
    (define-key mc/keymap (kbd "C-x C-d") 'mc/unmark-previous-like-this)

    (add-hook 'multiple-cursors-mode-enabled-hook #'my-disable-lsp-highlighting)
    (add-hook 'multiple-cursors-mode-disabled-hook #'my-enable-lsp-highlighting)
  )




(require 'undo-tree)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/.local/.undo-tree-files")))
(global-undo-tree-mode)

;; Suppress the message saying that the undo history file was
;; saved (because this happens every single time you save a file).
(defun radian--undo-tree-suppress-undo-history-saved-message
    (undo-tree-save-history &rest args)
  (let ((inhibit-message t))
    (apply undo-tree-save-history args)))
;; Suppress the message saying that the undo history could not be
;; loaded because the file changed outside of Emacs.
(defun radian--undo-tree-suppress-buffer-modified-message
    (undo-tree-load-history &rest args)
  (let ((inhibit-message t))
    (apply undo-tree-load-history args)))
(advice-add #'undo-tree-load-history :around
            #'radian--undo-tree-suppress-buffer-modified-message)



;; Have to use require, not use-package
(require 'hydra)
(defhydra undo-tree-menu (global-map "C-c u")
  "
_u_: undo      _r_: redo
"
  ("u" undo-tree-undo)
  ("r" undo-tree-redo)
)


;;;  ;; Have to use require, not use-package
;;;  (require 'hydra)
;;;  (defhydra multiple-cursors-menu (global-map "C-c m")
;;;    "
;;;  _n_: next      _p_: prev     _a_: all      _s_: skip next       _S_: skip prev
;;;  "
;;;    ("n" my-mc/mark-next-like-this)
;;;    ("p" my-mc/mark-previous-like-this)
;;;    ("a" mc/mark-all-like-this)
;;;    ("s" mc/skip-to-next-like-this)
;;;    ("S" mc/skip-to-previous-like-this)
;;;  )




(advice-add 'deadgrep-visit-result                        :after 'my-recenter)
(advice-add 'deadgrep-visit-result-other-window           :after 'my-recenter)


;; (defun my-deadgrep-visit-result ()
;;   (interactive)
;;   (deadgrep-visit-result)
;;   (recenter)
;;   )

;; (defun my-deadgrep-visit-file-other-window ()
;;   (interactive)
;;   (deadgrep-visit-result-other-window)
;;   (recenter)
;;   )

;; (defun my-deadgrep-view-file ()
;;   "View result under cursor in other window."
;;   (interactive)
;;   (deadgrep-visit-result-other-window)
;;
;;   (recenter)
;;   (other-window 1)
;;   )


(defun my-deadgrep-edit-enter()
  (interactive)
  (global-undo-tree-mode -1)
  (undo-tree-mode -1)
  (my-quit-god-mode)
  (remove-hook 'before-save-hook #'delete-trailing-whitespace)
  (remove-hook 'switch-buffer-functions #'my-god-mode-with-switch-any-buffer)
  (my-special-buffer-keys-minor-mode 0)
  )


(defun my-deadgrep-edit-exit()
  (interactive)
  (global-undo-tree-mode 1)
  (undo-tree-mode 1)
  (my-god-mode)
  (add-hook 'before-save-hook #'delete-trailing-whitespace)
  (add-hook 'switch-buffer-functions #'my-god-mode-with-switch-any-buffer)
  (my-special-buffer-keys-minor-mode 1)
  (deadgrep-mode)
  )

(use-package deadgrep
  :ensure t
  :config
    (setq-default deadgrep--context (cons 3 3))
  :bind(
    ("C-c g" . deadgrep)
    (:map deadgrep-mode-map
          ("RET"  . deadgrep-visit-result)
          ("o"    . deadgrep-visit-result-other-window)
          ("v"    . (lambda () (interactive) (deadgrep-visit-result-other-window) (other-window 1)))
          ("S"    . deadgrep-search-term)
          ("D"    . deadgrep-directory)
          ("g"    . deadgrep-restart)
          ("n"    . deadgrep-forward-match)
          ("p"    . deadgrep-backward-match)
          ("N"    . deadgrep-forward-filename)
          ("P"    . deadgrep-backward-filename)
          ("C-x C-q" . deadgrep-edit-mode)
    :map deadgrep-edit-mode-map
         ("C-c C-c" . my-deadgrep-edit-exit)
    )
  )
  :hook (deadgrep-edit-mode . my-deadgrep-edit-enter)
)



;;;  treats underscores as part of words
(superword-mode 1)


(require 'highlight)



(use-package key-chord
  :ensure t
  :config
  )
(setq key-chord-two-keys-delay 1.0)
(setq key-chord-one-key-delay 1.1)

(key-chord-mode 1)

(defun my-key-chord-define (keymap keys command)
  "Define in KEYMAP, a key-chord of the two keys in KEYS starting a COMMAND.
KEYS can be a string or a vector of two elements. Currently only
elements that corresponds to ascii codes in the range 32 to 126
can be used.
COMMAND can be an interactive function, a string, or nil.
If COMMAND is nil, the key-chord is removed."
  (if (/= 2 (length keys))
      (error "Key-chord keys must have two elements"))
  ;; Exotic chars in a string are >255 but define-key wants 128..255
  ;; for those.
  (let ((key1 (logand 255 (aref keys 0)))
        (key2 (logand 255 (aref keys 1))))
    (if (eq key1 key2)
        (define-key keymap (vector 'key-chord key1 key2) command)
      (define-key keymap (vector 'key-chord key1 key2) command)
      ;; (define-key keymap (vector 'key-chord key2 key1) command)   ;; sekiroc:: donot reverse bind!
      )))






 ;; '(iedit-occurrence ((t (:background "black" :foreground "yellow"))))


;; (with-eval-after-load 'subr-x
;;         (setq-default mode-line-buffer-identification
;;                 '(:eval (format-mode-line (propertized-buffer-identification (or (when-let* ((buffer-file-truename buffer-file-truename)
;;                 (prj (cdr-safe (project-current)))
;;                 (prj-parent (file-name-directory (directory-file-name (expand-file-name prj)))))
;;                         (concat (file-relative-name (file-name-directory buffer-file-truename) prj-parent) (file-name-nondirectory buffer-file-truename)))
;; "%b"))))))









(defun my-last-in-word ()
  "Move to the next 'last character' of a word."
  (interactive)
  (forward-char)
  (re-search-forward "\\w\\b" nil t)
  (goto-char (match-beginning 0)))





(defun my-delete-char (arg)
  (interactive "p")
   (if (use-region-p)
     (let ((beg (region-beginning))
           (end (copy-marker (region-end))))
          (delete-region beg end)
     )
     (delete-forward-char 1)
   )
)


(defun my-replace-char ()
  "delete current char, goto insert mode"
  (interactive)
  (delete-forward-char 1)
  ;; (call-interactively (key-binding (kbd "q")))
  (my-quit-god-mode)
  )




(defun my-save-buffer ()
  "delete current word, goto insert mode"
  (interactive)
  (save-buffer)
  (my-god-mode)
  ;; (my-quit-mc-mode-if-need)
  )


(defun my-select-current-line-and-forward-line (arg)
  "Select the current line and move the cursor by ARG lines IF
no region is selected.
If a region is already selected when calling this command, only move
the cursor by ARG lines."
  (interactive "p")
  (when (not (use-region-p))
    (forward-line 0)
    (set-mark-command nil))
  (forward-line arg))




(defun my-join-lines (arg)
  "Apply join-line over region."
  (interactive "p")
  (forward-line 0)  ;; goto line begin
  (if (use-region-p)
          (let ((beg (region-beginning))
                        (end (copy-marker (region-end))))
                (goto-char beg)
                (while (< (point) end)
                  (join-line 1))
                )
    (progn
      (set-mark-command nil)
      (end-of-line)
      (join-line -1)
    )
))


(defun my-is-beginning-of-line ()
  (interactive)
  (= (point)
    (line-beginning-position)
  ))


(defun my-is-end-of-line ()
  (interactive)
  (= (point)
    (line-end-position)
  ))


(defun my-forward-char-no-cross-line()
  (interactive)
  (unless (my-is-end-of-line)
    (forward-char)
  )
)

(defun my-backward-char-no-cross-line()
  (interactive)
  (unless (my-is-beginning-of-line)
    (backward-char)
  )
)




(defun my-goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis. Else go to the
opening parenthesis one level up."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1))
        (t
         (backward-char 1)
         (cond ((looking-at "\\s\)")
                (forward-char 1) (backward-list 1))
               (t
                (while (not (looking-at "\\s("))
                  (backward-char 1)
                  (cond ((looking-at "\\s\)")
                         (message "->> )")
                         (forward-char 1)
                         (backward-list 1)
                         (backward-char 1)))
                  ))))))






(use-package highlight-parentheses
  :ensure t)
(add-hook 'prog-mode-hook #'highlight-parentheses-mode)




(defun my-ibuffer-hook ()
      ;; add another sorting method for ibuffer (allow the grouping of
      ;; filenames and dired buffers
    (define-ibuffer-sorter filename-or-dired
      "Sort the buffers by their pathname."
      (:description "filenames plus dired")
      (string-lessp
       (with-current-buffer (car a)
         (or buffer-file-name
             (if (eq major-mode 'dired-mode)
                 (expand-file-name dired-directory))
             ;; so that all non pathnames are at the end
             "~"))
       (with-current-buffer (car b)
         (or buffer-file-name
             (if (eq major-mode 'dired-mode)
                 (expand-file-name dired-directory))
             ;; so that all non pathnames are at the end
             "~"))))
    (define-key ibuffer-mode-map (kbd "s p") 'ibuffer-do-sort-by-filename-or-dired)

    ;; sort now please!
    (ibuffer-do-sort-by-filename-or-dired)
)
(add-hook 'ibuffer-mode-hook 'my-ibuffer-hook)


(eval-after-load "dired" '(progn
    (define-prefix-command 'my-god-mode-leader-key)
    (define-key dired-mode-map (kbd "SPC") 'my-god-mode-leader-key)

    (define-key dired-mode-map (kbd "SPC b") #'switch-to-buffer)
    (define-key dired-mode-map (kbd "SPC B") #'ibuffer)
    (define-key dired-mode-map (kbd "SPC k") #'kill-this-buffer)
    (define-key dired-mode-map (kbd "SPC K") #'my-only-current-buffer)
    (define-key dired-mode-map (kbd "SPC f") #'projectile-find-file)
    (define-key dired-mode-map (kbd "SPC p") #'helm-find-files)
    (define-key dired-mode-map (kbd "SPC m") #'deadgrep)
    (define-key dired-mode-map (kbd "SPC L") #'display-line-numbers-mode)
    (define-key dired-mode-map (kbd "SPC x") #'delete-window)   ;; delete this window
  ))



(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-x") #'helm-M-x)
    ;; (define-key map (kbd "C-M-f") #'projectile-find-file)
    ;; (define-key map (kbd "C-M-b") #'switch-to-buffer)
    ;; (define-key map (kbd "C-x C-b") #'switch-to-buffer)

    (define-key map (kbd "C-x C-b") #'ibuffer)
    (define-key map (kbd "C-x C-f") #'helm-find-files)
    (define-key map (kbd "C-x C-k") #'kill-this-buffer)

    (define-key map (kbd "C-c C-e") #'eval-region)

    (define-key map (kbd "C-a") 'mwim-beginning-of-code-or-line)
    (define-key map (kbd "C-e") 'mwim-end-of-code-or-line)
    (define-key map (kbd "<home>") 'mwim-beginning-of-line-or-code)
    (define-key map (kbd "<end>") 'mwim-end-of-line-or-code)

    (define-key map (kbd "C-c .") 'er/expand-region)

    (define-key map (kbd "C-c v") 'set-rectangular-region-anchor)
    (define-key map (kbd "C-c o") 'helm-occur)
    (define-key map (kbd "C-c s") 'my-helm-ag-thing-at-point)
    (define-key map (kbd "C-c C-v") #'set-rectangular-region-anchor)
    (define-key map (kbd "C-c C-o") #'helm-occur)
    (define-key map (kbd "C-c C-s") #'my-helm-ag-thing-at-point)

    (define-key map (kbd "M-;") 'avy-goto-word-0)
    (define-key map (kbd "M-s") 'my-save-buffer)
    (define-key map (kbd "C-j") 'my-save-buffer)
    (define-key map (kbd "M-n") 'gcm-scroll-down)
    (define-key map (kbd "M-p") 'gcm-scroll-up)
    (define-key map (kbd "M-o") 'other-window)
    (define-key map (kbd "C-q") 'my-toggle-god-mode)

    (define-key map (kbd "M-u") 'upcase-dwim)
    (define-key map (kbd "M-l") 'downcase-dwim)

    (define-prefix-command 'my-god-mode-leader-key)
    (define-prefix-command 'my-god-mode-dummmy-key)
    (define-prefix-command 'my-god-mode-viewer-key)
    (define-prefix-command 'my-god-mode-window-key)
    (define-key god-local-mode-map (kbd "SPC") 'my-god-mode-leader-key)
    (define-key god-local-mode-map (kbd ",")   'my-god-mode-dummmy-key)
    (define-key god-local-mode-map (kbd "z")   'my-god-mode-viewer-key)
    (define-key god-local-mode-map (kbd "q")   'my-god-mode-window-key)

    ;; God mode key mappings
    (define-key god-local-mode-map (kbd "f") #'avy-goto-word-0)
    (define-key god-local-mode-map (kbd "w") #'forward-word)
    (define-key god-local-mode-map (kbd "b") #'backward-word)
    (define-key god-local-mode-map (kbd "k") #'previous-line)
    (define-key god-local-mode-map (kbd "j") #'next-line)
    (define-key god-local-mode-map (kbd "l") #'my-forward-char-no-cross-line)
    (define-key god-local-mode-map (kbd "h") #'my-backward-char-no-cross-line)
    (define-key god-local-mode-map (kbd "v") #'set-mark-command)
    (define-key god-local-mode-map (kbd "V") #'my-select-current-line-and-forward-line)
    (define-key god-local-mode-map (kbd "J") #'my-join-lines)
    (define-key god-local-mode-map (kbd "y") #'kill-ring-save)
    (define-key god-local-mode-map (kbd "p") #'yank)
    (define-key god-local-mode-map (kbd "P") #'yank) ;; same as yank
    (define-key god-local-mode-map (kbd "u") #'undo-tree-undo)
    (define-key god-local-mode-map (kbd "C-r") #'undo-tree-redo)
    (define-key god-local-mode-map (kbd "o") #'my-god-below-newline-and-insert-mode)
    (define-key god-local-mode-map (kbd "O") #'my-god-above-newline-and-insert-mode)
    (define-key god-local-mode-map (kbd "i") #'my-quit-god-mode)
    (define-key god-local-mode-map (kbd "r") #'keyboard-quit-context+)
    (define-key god-local-mode-map (kbd "m") #'my-goto-match-paren)

    (define-key god-local-mode-map (kbd "s") #'my-replace-char)
    (define-key god-local-mode-map (kbd "x") #'my-delete-char)
    (define-key god-local-mode-map (kbd "d") #'kill-whole-line)

    (define-key god-local-mode-map (kbd "z o") #'my-hs-toggle-hiding)
    (define-key god-local-mode-map (kbd "z m") #'my-hs-toggle-all)
    (define-key god-local-mode-map (kbd "z z") #'recenter-top-bottom)
    (define-key god-local-mode-map (kbd "z j") #'end-of-buffer)
    (define-key god-local-mode-map (kbd "z k") #'beginning-of-buffer)

    (define-key god-local-mode-map (kbd "L") #'mwim-end-of-code-or-line)
    (define-key god-local-mode-map (kbd "H") #'mwim-beginning-of-code-or-line)
    (define-key god-local-mode-map (kbd "$") #'mwim-end-of-code-or-line)
    (define-key god-local-mode-map (kbd "0") #'mwim-beginning-of-code-or-line)
    (define-key god-local-mode-map (kbd "A") #'beginning-of-defun)
    (define-key god-local-mode-map (kbd "E") #'end-of-defun)

    (define-key god-local-mode-map (kbd "*") #'my-search-selection)
    (define-key god-local-mode-map (kbd "/") #'isearch-forward)
    (define-key god-local-mode-map (kbd "n") #'my-isearch-forward)
    (define-key god-local-mode-map (kbd "N") #'my-isearch-backward)
    (define-key god-local-mode-map (kbd ":") #'helm-M-x)

    (define-key god-local-mode-map (kbd "C-.") #'repeat)
    (define-key god-local-mode-map (kbd "C-~") #'upcase-char)

    (define-key god-local-mode-map (kbd "C-x C-n") #'my-mc/mark-next-like-this)
    (define-key god-local-mode-map (kbd "C-x C-p") #'my-mc/mark-previous-like-this)

    (define-key god-local-mode-map (kbd "SPC b") #'switch-to-buffer)
    (define-key god-local-mode-map (kbd "SPC B") #'ibuffer)
    (define-key god-local-mode-map (kbd "SPC k") #'kill-this-buffer)
    (define-key god-local-mode-map (kbd "SPC K") #'my-only-current-buffer)
    (define-key god-local-mode-map (kbd "SPC f") #'projectile-find-file)
    (define-key god-local-mode-map (kbd "SPC p") #'helm-find-files)
    (define-key god-local-mode-map (kbd "SPC m") #'deadgrep)
    (define-key god-local-mode-map (kbd "SPC L") #'display-line-numbers-mode)
    (define-key god-local-mode-map (kbd "SPC x") #'delete-window)   ;; delete this window

    (define-key god-local-mode-map (kbd "SPC l") #'previous-buffer)
    (define-key god-local-mode-map (kbd "SPC h") #'next-buffer)

    (define-key god-local-mode-map (kbd "SPC t") #'treemacs)
    (define-key god-local-mode-map (kbd "SPC n") #'my-neotree-toggle)
    (define-key god-local-mode-map (kbd "SPC N") #'my-neotree-find)

    (define-key god-local-mode-map (kbd "@") #'(lambda() (interactive) (treemacs-find-file) (treemacs-select-window)))
    (define-key god-local-mode-map (kbd "SPC @") #'treemacs-add-and-display-current-project)

    (define-key god-local-mode-map (kbd "q l") #'windmove-right)
    (define-key god-local-mode-map (kbd "q h") #'windmove-left)
    (define-key god-local-mode-map (kbd "q k") #'windmove-up)
    (define-key god-local-mode-map (kbd "q j") #'windmove-down)
    (define-key god-local-mode-map (kbd "q v") #'split-window-right)
    (define-key god-local-mode-map (kbd "q s") #'split-window-below)
    (define-key god-local-mode-map (kbd "q x") #'delete-window)         ;; delete this window
    (define-key god-local-mode-map (kbd "q d") #'delete-other-windows)  ;; delete other window
    (define-key god-local-mode-map (kbd "q q") #'other-window)

    (define-key god-local-mode-map (kbd "C-w l") #'windmove-right)
    (define-key god-local-mode-map (kbd "C-w h") #'windmove-left)
    (define-key god-local-mode-map (kbd "C-w k") #'windmove-up)
    (define-key god-local-mode-map (kbd "C-w j") #'windmove-down)
    (define-key god-local-mode-map (kbd "C-w q") #'delete-window)         ;; delete this window
    (define-key god-local-mode-map (kbd "C-w d") #'delete-other-windows)  ;; delete other window
    (define-key god-local-mode-map (kbd "C-w v") #'split-window-right)
    (define-key god-local-mode-map (kbd "C-w s") #'split-window-below)
    (define-key god-local-mode-map (kbd "C-w w") #'other-window)

    (define-key god-local-mode-map (kbd "C-w C-l") #'windmove-right)
    (define-key god-local-mode-map (kbd "C-w C-h") #'windmove-left)
    (define-key god-local-mode-map (kbd "C-w C-k") #'windmove-up)
    (define-key god-local-mode-map (kbd "C-w C-j") #'windmove-down)

    (define-key god-local-mode-map (kbd ", w") #'my-save-buffer)
    (define-key god-local-mode-map (kbd ", b") #'flip-buffer-to-window)
    (define-key god-local-mode-map (kbd ", ,") #'er/mark-symbol)             ;; b a   last buffer

    (define-key god-local-mode-map (kbd ", s") #'emacs-surround)


    ;; (define-key god-local-mode-map (kbd "C-, C-h") #'switch-to-prev-buffer)
    ;; (define-key god-local-mode-map (kbd "C-, C-l") #'switch-to-next-buffer)

    ;; (my-key-chord-define god-local-mode-map ",,"  #'er/mark-symbol)

    ;; (define-key god-local-mode-map (kbd "C-m") #'next-line)

    (define-key god-local-mode-map (kbd ";") #'scroll-up-command)
    (define-key god-local-mode-map (kbd "'") #'scroll-down-command)
    ;; (define-key god-local-mode-map (kbd "\\") #'recenter-top-bottom)



    (add-hook 'java-mode-hook 'my-tab-4-indent)
    (add-hook 'c-mode-hook 'my-tab-4-indent)
    (add-hook 'c++-mode-hook 'my-tab-4-indent)
    (add-hook 'nxml-mode-hook 'my-tab-4-indent)


    ;; projectile
    (define-key projectile-mode-map (kbd "C-c f") 'projectile-command-map)
    map)
  "my-keys-minor-mode keymap.")

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " my-keys")

;; Active my keys minor mode
(my-keys-minor-mode 1)





(defvar my-special-buffer-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd ";") #'scroll-up-command)
    (define-key map (kbd "'") #'scroll-down-command)
    (define-key map (kbd "k") #'previous-line)
    (define-key map (kbd "j") #'next-line)
    (define-key map (kbd "l") #'forward-char)
    (define-key map (kbd "h") #'backward-char)
    (define-key map (kbd "C-w l") #'windmove-right)
    (define-key map (kbd "C-w h") #'windmove-left)
    (define-key map (kbd "C-w k") #'windmove-up)
    (define-key map (kbd "C-w j") #'windmove-down)
    (define-key map (kbd "C-w Q") #'delete-window)      ;; delete this window
    (define-key map (kbd "C-w d") #'delete-other-windows)  ;; delete other window
    (define-key map (kbd "C-w v") #'split-window-right)
    (define-key map (kbd "C-w s") #'split-window-below)
    (define-key map (kbd "C-w w") #'other-window)

    (define-key map (kbd "C-w C-l") #'windmove-right)
    (define-key map (kbd "C-w C-h") #'windmove-left)
    (define-key map (kbd "C-w C-k") #'windmove-up)
    (define-key map (kbd "C-w C-j") #'windmove-down)
    map)
  "my-special-buffer-keys-minor-mode keymap.")
(define-minor-mode my-special-buffer-keys-minor-mode
  "A minor mode add some bindings for special-buffers."
  :init-value t
  :lighter " my-special-buffer-keys")



(add-hook 'view-mode-hook         'View-exit)
(add-hook 'view-mode-hook         'my-special-buffer-keys-minor-mode)




;; Diactive my all special keys for minibuffer
(add-hook 'minibuffer-setup-hook #'(lambda () (my-keys-minor-mode 0)))
(add-hook 'minibuffer-setup-hook #'(lambda () (my-special-buffer-keys-minor-mode 0)))
(add-hook 'helm-minibuffer-set-up-hook #'(lambda () (my-special-buffer-keys-minor-mode 0)))




(use-package selected
  :ensure t
  :commands selected-minor-mode
  :bind (:map selected-keymap
              ("v" . keyboard-quit)  ;; deactive region
              ("d" . kill-region)
              ("x" . kill-region)
              ("C-c i" . clang-format-region)
              ("C-c f" . clang-format-buffer)

              ("M-d" . my-mc/mark-next-like-this)
              ("M-D" . my-mc/mark-previous-like-this)
              ("C-c C-n" . my-mc/mark-next-like-this)
              ("C-c C-p" . my-mc/mark-previous-like-this)

              ;; ("g g" . (lambda () (interactive) (beginning-of-buffer) (keyboard-quit) ))
              ;; ("G" .   (lambda () (interactive) (end-of-buffer) (keyboard-quit) ))


              ("("  . my-wrap-region-with-parens)
              ("["  . my-wrap-region-with-brackets)
              ("{"  . my-wrap-region-with-braces)
              ("'"  . my-wrap-region-with-single-quotes)
              ("\"" . my-wrap-region-with-double-quotes)
              ("_"  . my-wrap-region-with-underscores)
              ("`"  . my-wrap-region-with-back-quotes)

        )
)
(selected-global-mode 1)
