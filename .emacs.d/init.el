;; -*- lexical-binding: t -*-
;;; init.el --- Emacs Configuration

;; load emacs 24's package system. Add MELPA repository.
(define-key special-event-map [config-changed-event] #'ignore)

;;; Package Management
(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

;; 完全禁止自动包管理
(setq package-enable-at-startup nil
      package-check-signature nil
      ;; 禁止自动安装选中的包
      package-install-upgrade-built-in nil)

;; 禁用 package-selected-packages 的自动安装机制
(defun package--save-selected-packages (&rest _args)
  "Do nothing to prevent automatic package installation."
  nil)

;; 阻止启动时自动刷新包列表
(defvar my-startup-finished nil)
(defun my-block-package-refresh (orig-fun &rest args)
  "Block package-refresh-contents during startup."
  (when my-startup-finished
    (apply orig-fun args)))

(advice-add 'package-refresh-contents :around #'my-block-package-refresh)

;; 启动完成后恢复正常行为
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq my-startup-finished t)))

(package-initialize)

;;; Performance Optimization
;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Lower threshold back to 16 MiB after startup (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

;;; Path Configuration
(add-to-list 'exec-path "/usr/local/bin/")
(add-to-list 'exec-path "/usr/bin/")
(add-to-list 'exec-path "/opt/homebrew/bin")

(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
(setenv "PATH" (concat "/usr/bin:" (getenv "PATH")))
(setenv "PATH" (concat "/opt/homebrew/bin:" (getenv "PATH")))
(setenv "PATH" (concat (expand-file-name "~/.local/bin:") (getenv "PATH")))

(setq mac-command-modifier 'super)

;;; Directory Setup
;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/.local/auto-save-list/" t)
(make-directory "~/.emacs.d/.local/autosaves/" t)
(make-directory "~/.emacs.d/.local/backups" t)

;;; Load Path Configuration
(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacswiki.org"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/blink-search"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/tabby.el"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/initializers"))
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/lisp"))

;;; Core Libraries
(require 'cl-lib)  ; Updated from deprecated 'cl
(require 's)
(require 'bind-key) ; more powerful than global-set-key! seems have the highest priority

;;; Local Libraries (immediate loading required)
(use-package dired+
  :ensure nil
  :demand t
  :init
  (setq diredp-hide-details-initially-flag nil))

(require 'custom-util-funcs)
(require 'my-utils)
(require 'init-eshell)

;;; Benchmark
(use-package benchmark-init
  :ensure t
  :demand t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

;;; Font and UI Configuration
(setq default-font "IBM Plex Mono 1.2-14.0"
      default-font-family "IBM Plex Mono")

(set-face-attribute 'default nil :font default-font)
(setq default-frame-alist
      `((vertical-scroll-bars) ;隐藏滚动条
        (left-fringe . 8) ;关闭左fringe
        (right-fringe . 8) ;关闭右fringe
        (font . ,default-font)
        (vertical-scroll-bars . nil)))

(set-face-attribute 'show-paren-match nil
                    :foreground "green"
                    :background "#11501B"
                    :weight 'normal
                    :underline '(:position t))

(setq-default left-margin-width 0
              right-margin-width 0)
(setq frame-resize-pixelwise t)

(setq my-posframe-border-width (if (display-graphic-p) 1 0)
      my-posframe-fringe-width (if (display-graphic-p) 8 0))

;; Set symbol for the border
(set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))

(setq cursor-in-non-selected-windows nil)

;;; Theme Configuration
(setq window-divider-color "#06C668")

(setq use-dark-theme-mode t)
(if use-dark-theme-mode
    (setq darker-window-bg-color "#181818"
          darker-window-fg-color "white"
          highlight-font-chars-face-fg "green"
          highlight-font-chars-face-underline t
          whitespace-tab-fg-color "#627D9D"
          whitespace-trailing-fg-color "#161c23"
          hl-line-bg-color "#1b2129")
  (setq darker-window-bg-color "#FFFFFF"
        darker-window-fg-color "black"
        highlight-font-chars-face-fg 'unspecified
        highlight-font-chars-face-underline t
        whitespace-tab-fg-color "#627D9D"
        whitespace-trailing-fg-color "#161c23"
        hl-line-bg-color (face-background 'highlight)))

(defun my-set-large-line-height ()
  (interactive)
  (setq-local default-text-properties '(line-spacing 0.15 line-height 1.15)))

(defface my-highlight-font-chars-face
  `((t (:foreground ,highlight-font-chars-face-fg
        :underline (:color ,highlight-font-chars-face-fg :position t)
        :weight normal)))
  "custom highlight for treemacs current line")

(defface my-highlight-font-words-face
  `((t (:background "#5114FA"
        :underline nil
        :weight normal)))
  "custom highlight for treemacs current line")

;;; UI Mode Configuration
(tool-bar-mode -1)
(menu-bar-mode -1)
(smerge-mode -1)
(tab-bar-mode 1)

(defun my-tab-name-formatter (tab index)
  (propertize
   (format " %s" (alist-get 'name tab))
   'face (funcall tab-bar-tab-face-function tab)))
(setq tab-bar-tab-name-format-function 'my-tab-name-formatter)

;;; Theme Loading and Face Configuration
(set-face-foreground 'default "#D1D2CE")
(set-face-attribute 'lazy-highlight nil :background "#7FDC59" :foreground "#161c23")

(with-eval-after-load 'wid-edit
  (set-face-attribute 'widget-field nil :background "#C6B8AD" :foreground "black"))

;; for macOS, set tooltip font size by:
;; defaults write org.gnu.Emacs NSToolTipsFontSize -int 16
(set-face-font 'tooltip (frame-parameter nil 'font))

(load-theme 'doom-xcode t)
(set-face-attribute 'font-lock-keyword-face nil :weight 'normal)
(set-face-attribute 'font-lock-preprocessor-face nil :weight 'normal)
(set-face-attribute 'region nil :background "#214283" :distant-foreground "#707080")
(set-face-attribute 'isearch nil :weight 'normal)
(set-face-attribute 'lazy-highlight nil :weight 'normal)

(set-face-background 'default "#161c23")
(set-face-foreground 'isearch "white")
(set-face-background 'isearch "deeppink")
(set-face-attribute 'mode-line-inactive nil :box nil :underline nil)
(set-face-attribute 'mode-line-active nil :box nil :underline nil)
(set-face-attribute 'mode-line-highlight nil :box nil :foreground "green")

(defun my-change-window-divider ()
  (let ((display-table (or buffer-display-table standard-display-table)))
    (set-display-table-slot display-table 5 ?│)
    (set-window-display-table (selected-window) display-table)))
(add-hook 'window-configuration-change-hook 'my-change-window-divider)

(set-face-attribute 'vertical-border nil
                    :foreground "#353535"
                    :background (face-background 'default)
                    :inherit 'unspecified)

;;; Core Initializers (immediate loading required)
(require 'init-god)
(require 'init-projectile)
(require 'init-treesit)
(require 'init-slime)
(require 'my-key-bindings)

(global-unset-key [(control z)])

;;; Terminal-specific Configuration
(unless (display-graphic-p)
  (require 'my-catch-term-escape-key)
  (require 'init-term-cursor)
  (require 'my-term-popup))

;;; Basic Settings
(setq warning-minimum-level :emergency
      visible-bell t
      ring-bell-function #'ignore
      custom-safe-themes t
      recenter-redisplay nil
      blink-cursor-blinks 0
      blink-cursor-interval 0.3)

(set-default 'truncate-lines t)

;; compile log with colors
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

(require 'init-expand-region)
(toggle-truncate-lines t)
(require 'init-imenu)

;;; Custom Faces Configuration
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "#415367" :foreground "#e5ded6" :underline (:color foreground-color :style line :position t)))))
 '(success ((t (:foreground "Green1" :weight regular)))))

(require 'my-highlight-current-line)

;;; Popup Windows
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
                  "^\\*vterm.*\\*$"  vterm-mode  ;vterm as a popup
                  )))
  (popper-mode +1)
  (popper-echo-mode +1)
  :config
  (setq popper-window-height 0.6))

;;; Navigation and Jumping
(require 'init-nice-jumper)
(require 'init-mouse)
(require 'init-xref)

(require 'init-format-all)

;;; Terminal Colors
(setq ansi-color-names-vector ["black" "tomato" "PaleGreen2" "gold1" "DeepSkyBlue1" "MediumOrchid1" "cyan" "white"])
(setq ansi-color-map (ansi-color-make-color-map))

;;; Rainbow Delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;;; Development Tools
(require 'init-eldoc)
(require 'init-eglot)
(require 'init-lang-go)
(require 'init-cmake-project)
(require 'init-lang-cpp)
(require 'init-lang-python)
(require 'init-lang-zig)
(require 'init-lang-typescript)
(require 'init-lang-swift)
(require 'init-company)
(require 'init-yasnippet)

;;; Custom Variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/.local/autosaves/\\1" t)))
 '(auto-save-list-file-prefix (expand-file-name "~/.emacs.d/.local/auto-save-list/"))
 '(backup-directory-alist '((".*" . "~/.emacs.d/.local/backups/")))
 '(create-lockfiles nil)
 '(helm-minibuffer-history-key "M-p")
 '(inhibit-startup-screen t)
 '(leetcode-prefer-language "cpp")
 '(leetcode-save-solutions t)
 '(package-selected-packages
   '(yank-indent jtsx sideline-eglot sideline-flymake sideline highlight-indent-guides treemacs-nerd-icons treemacs python-ts poetry dockerfile-mode popper spacious-padding afternoon-theme ansible apheleia atom-one-dark-theme auto-dim-other-buffers bazel beacon benchmark-init blamer centaur-tabs challenger-deep-theme color-theme-sanityinc-tomorrow company-posframe company-prescient company-qml corfu-terminal counsel csv-mode cyberpunk-theme dashboard dashboard-hackernews diminish disable-mouse easy-kill eglot elisp-autofmt elisp-def elisp-refs elisp-slime-nav eterm-256color format-all general google-c-style helm-rg highlight-numbers highlight-parentheses imenu-list impatient-mode inkpot-theme ivy ivy-posframe ivy-xref jdecomp jsonrpc key-chord known leetcode lispy lsp-python-ms markdown-mode markdown-toc markdownfmt modus-themes moe-theme mwim nano-theme neotree nimbus-theme package-lint paredit phi-search popon popup-switcher popwin prescient project projectsile-mode protobuf-mode py-autopep8 qml-mode rainbow-delimiters reformatter ripgrep rjsx-mode selected slime slime-company smart-jump smart-mode-line smooth-scrolling solaire-mode srcery-theme srefactor swift-mode switch-buffer-functions symbol-overlay treemacs-all-the-icons treesit-auto typescript-mode undo-tree valign vs-dark-theme vscode-dark-plus-theme vterm vue-mode with-proxy with-simulated-input xclip yasnippet))
 '(pos-tip-background-color "#1d1d2b")
 '(pos-tip-foreground-color "#d4d4d6")
 '(recentf-save-file (expand-file-name "~/.emacs.d/.local/recentf"))
 '(safe-local-variable-values
   '((eval font-lock-add-keywords nil
		   `((,(concat "("
					   (regexp-opt
						'("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl")
						t)
					   "\\_>")
			  1 'font-lock-variable-name-face)))))
 '(warning-suppress-log-types '((emacs) (use-package) (lsp-mode)))
 '(warning-suppress-types '((use-package) (lsp-mode))))

;; lsp-mode session file
(setq lsp-session-file (expand-file-name "~/.emacs.d/.local/.lsp-session-v1"))

;;; Text and Programming Modes
(require 'init-whitespace-mode)

(use-package iedit
  :ensure t
  :bind (("C-M-'" . iedit-mode))
  :config
  (set-face-attribute 'iedit-occurrence nil :foreground "black" :background "yellow"))

(require 'init-impatient-markdown)
(require 'init-ace-window)
(require 'init-blamer)
(require 'init-diminish)
(require 'init-dashboard)
(require 'init-autopep8)

;;; Search Tools
(defun my-ripgrep-kill-buffer()
  (interactive)
  (ripgrep/kill-buffer)
  (delete-window))

(use-package ripgrep
  :ensure t
  :config
  (set-face-attribute 'ripgrep-match-face nil :inherit 'my-highlight-font-words-face)
  :bind
  (:map ripgrep-search-mode-map
        (";" . scroll-up-command)
        ("'" . scroll-down-command)
        ("k" . previous-line)
        ("j" . next-line)
        ("x" . my-ripgrep-kill-buffer)))

;;; Terminal Emulator
(use-package vterm
  :ensure t
  :commands vterm
  :config
  (setq vterm-timer-delay 0.001
        vterm-max-scrollback 10000)
  (define-key vterm-mode-map (kbd "s-C")  #'vterm-copy-mode)
  (define-key vterm-mode-map (kbd "C-s-c")  #'(lambda() (interactive) (vterm-send-key "c" nil nil t)))
  (define-key vterm-mode-map (kbd "M-i")  #'er/expand-region)
  (define-key vterm-copy-mode-map (kbd "M-w")  #'vterm-copy-mode-done)
  (define-key vterm-copy-mode-map (kbd "s-C")  #'vterm-copy-mode)
  (add-hook 'vterm-copy-mode-hook #'(lambda() (if (bound-and-true-p vterm-copy-mode)
                                                   (my-special-buffer-keys-minor-mode 1)
                                                 (my-special-buffer-keys-minor-mode 0))))
  (keymap-unset vterm-mode-map "M-`")
  (keymap-unset vterm-mode-map "M-:")
  :hook
  (vterm-mode . (lambda() (selected-mode -1))))

;;; Programming Languages
(use-package rust-mode
  :ensure t)

(use-package scala-mode
  :ensure t
  :interpreter ("scala" . scala-mode))

(use-package yaml-mode
  :ensure t
  :hook
  (yaml-mode . display-line-numbers-mode)
  (yaml-ts-mode . display-line-numbers-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yml\\.j2\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\.j2\\'" . yaml-mode)))

(use-package qml-mode
  :ensure t
  :hook
  (qml-mode . (lambda ()
                (setq indent-tabs-mode nil
                      js-indent-level 4)
                (c-ts-mode-toggle-comment-style -1)
                (bind-keys :map qml-mode-map ("C-c C-b" . compile))
                (bind-keys :map qml-mode-map ("s-b" . compile))))
  (qml-mode . maybe-cmake-project-mode)
  (qml-mode . (lambda() (format-all-mode -1)))
  :config
  (add-to-list 'auto-mode-alist '("\\.qml\\'" . qml-mode)))

(use-package ansible
  :ensure t)

;;; Display and Visual Enhancements
(require 'init-display-line-numbers)

(use-package highlight-numbers
  :ensure t
  :hook (prog-mode . highlight-numbers-mode))

(use-package highlight-indent-guides
  :ensure t
  :config
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-auto-enabled nil
        highlight-indent-guides-character ?\x258f)
  (set-face-attribute 'highlight-indent-guides-character-face nil :inherit 'shadow)
  (defun my-highlighter (level responsive display)
    (if (> 1 level)
        nil
      (highlight-indent-guides--highlighter-default level responsive display)))
  (setq highlight-indent-guides-highlighter-function 'my-highlighter)
  :hook (prog-mode . highlight-indent-guides-mode))

;;; Mode-specific Hooks
(defun my-cmake-ts-mode-hook ()
  (setq cmake-tab-width 4)
  (bind-keys
   :map cmake-ts-mode-map
   ("C-c C-b" . compile)
   ("s-b" . compile)))

(add-hook 'cmake-ts-mode-hook 'my-cmake-ts-mode-hook)

(defun my-elisp-mode-hook ()
  (setq indent-tabs-mode nil
        lisp-indent-offset 2))

(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-hook)
(add-hook 'lisp-mode-hook 'my-elisp-mode-hook)

;;; Smart Parentheses and Electric Mode
(require 'init-smartparens)

(use-package electric
  :ensure t
  :demand t
  :config
  (electric-pair-mode 1)
  (electric-indent-mode 1))

;;; Additional Tools
(require 'init-blink-search)

(use-package tabby
  :ensure nil
  :demand t
  :config
  (add-hook 'python-ts-mode-hook 'tabby-mode)
  (define-key tabby-completion-map (kbd "M-<tab>") 'tabby-accept-completion))

(require 'init-ivy)
(require 'init-flymake)

;;; Basic Editing Enhancements
(delete-selection-mode 1)
(add-hook 'org-mode-hook #'valign-mode)
(add-hook 'markdown-mode-hook #'valign-mode)
(column-number-mode 1)

(require 'init-scroll-keys)

;; truncate-lines right margin sign
(set-display-table-slot standard-display-table 0 ?→)

;;; Key Bindings and Commands
(defun my-escape-key ()
  (interactive)
  (refresh-current-mode)
  (when isearch-mode (isearch-abort) (isearch-abort))  ;; must double abort
  (when (my-god-this-is-normal-editor-buffer (buffer-name))
    (when (bound-and-true-p multiple-cursors-mode) (multiple-cursors-mode 0))
    (when (bound-and-true-p iedit-mode) (iedit-done)) ;; exit iedit mode, if needed.
    (ignore-errors (company-cancel))
    (ignore-errors (remove-all-highlight)))
  (ignore-errors (flymake-start)) ;; but show errors
  (ignore-errors (blink-search-quit))
  (keyboard-quit)
  (keyboard-quit-context+)) ;; from custom-util-funcs.el

(bind-key (kbd "<escape>") #'my-escape-key)
(bind-key (kbd "<escape>") #'minibuffer-keyboard-quit minibuffer-local-map)

;; Global key bindings
(bind-key (kbd "C-S-k") #'my-delete-to-beginning)
(bind-key (kbd "C-k") #'my-delete-to-end)
(bind-key (kbd "C-j") #'save-buffer)

(bind-key* (kbd "C-<wheel-up>") #'ignore)
(bind-key* (kbd "C-<wheel-down>") #'ignore)

(when (display-graphic-p)
  (bind-key [escape] 'my-escape-key)
  (define-key input-decode-map [?\C-\[] (kbd "<C-[>"))
  (bind-key (kbd "<C-[>") 'my-escape-key))

(setq smex-save-file (expand-file-name "~/.emacs.d/.local/smex-items.cache"))

;;; Advice for Enhanced Editing
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

(require 'init-avy)

;;; Final Setup
(which-key-mode 1)
(xclip-mode 1)
(save-place-mode 1)

(use-package mwim
  :ensure t
  :demand t
  :config
  (global-set-key [remap move-end-of-line] #'mwim-end-of-code-or-line)
  (global-set-key [remap move-beginning-of-line] #'mwim-beginning-of-code-or-line))

(use-package yank-indent
  :ensure t
  :demand t
  :config
  (global-yank-indent-mode 1))

;; semantic-refactor, use in c++ mode
(use-package srefactor
  :ensure t
  :demand t
  :config
  (semantic-mode 1) ;; -> this is optional for Lisp
  (define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
  (define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point))

(require 'my-toggle-code-intelligence)
(add-hook 'isearch-mode-hook #'my-disable-code-intelligence)
(add-hook 'isearch-mode-end-hook #'my-enable-code-intelligence)

(require 'init-emacs-lispy)

;; for hl-line+.el
(setq hl-line-inhibit-highlighting-for-modes
      '(dired-mode deadgrep-mode deadgrep-edit-mode treemacs-mode))

(global-hl-line-mode 0)

(set-face-attribute 'line-number              nil :background (face-background 'default) :foreground "gray33" :slant 'normal :weight 'normal)
(set-face-attribute 'line-number-current-line nil :background (face-background 'hl-line) :foreground "white"  :slant 'normal :weight 'normal)

(require 'init-modeline)

(toggle-truncate-lines nil)
(toggle-continuation-fringe-indicator)

(global-auto-revert-mode 1)

;;;  treats underscores as part of words
(superword-mode 1)

;;; UI and Navigation Tools
(require 'init-all-the-icons)
(require 'init-neotree)
(require 'init-treemacs)
(require 'init-multi-cursor)
(require 'init-undo-tree)
(require 'init-hydra)
(require 'init-deadgrep)

(use-package highlight
  :ensure t)

(require 'init-dired-ibuffer)

;;; View Mode and Minibuffer Setup
(add-hook 'view-mode-hook 'View-exit)

;; Diactive my all special keys for minibuffer
(add-hook 'minibuffer-setup-hook #'(lambda () (my-keys-minor-mode 0)))
(add-hook 'minibuffer-setup-hook #'(lambda () (my-special-buffer-keys-minor-mode 0)))

(require 'init-selected)
(put 'scroll-left 'disabled nil)

;;; init.el ends here
