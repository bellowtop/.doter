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
(require 'init-dired-plus)

(require 'custom-util-funcs)
(require 'my-utils)
(require 'init-eshell)

;;; Benchmark
(require 'init-benchmark)

;;; Font and UI Configuration
(setq default-font "IBM Plex Mono 1.2-14.0"
      default-font-family "IBM Plex Mono")

(set-face-attribute 'default nil :font default-font)
(setq default-frame-alist
      `((vertical-scroll-bars) ;隐藏滚动条
        (left-fringe . 8) ;关闭左fringe
        (right-fringe . 8) ;关闭右fringe
        (font . ,default-font)
        ;; (fullscreen . maximized)
        (vertical-scroll-bars . nil)))

(defun center-frame ()
  "Center the frame on the screen."
  (interactive)
  ;; 获取显示器的尺寸
  (let* ((screen-width (x-display-pixel-width))
         (screen-height (x-display-pixel-height))
         ;; 获取当前框架的尺寸
         (frame-width (frame-pixel-width))
         (frame-height (frame-pixel-height))
         ;; 计算新的框架位置
         (left (/ (- screen-width frame-width) 2))
         (top (/ (- screen-height frame-height) 2)))
    ;; 设置框架的位置
    (set-frame-position (selected-frame) left top)))

;; 在图形界面模式下应用此功能
(when (display-graphic-p)
  ;; 在窗口设置完成后调用
  (add-hook 'window-setup-hook 'center-frame t))

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

(defun my-set-small-line-height ()
  (interactive)
  (setq-local default-text-properties '(line-spacing 0 line-height 1)))

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
(require 'init-popper)

;;; Navigation and Jumping
(require 'init-nice-jumper)
(require 'init-mouse)
(require 'init-xref)

(require 'init-format-all)

;;; Terminal Colors
(setq ansi-color-names-vector ["black" "tomato" "PaleGreen2" "gold1" "DeepSkyBlue1" "MediumOrchid1" "cyan" "white"])
(setq ansi-color-map (ansi-color-make-color-map))

;;; Rainbow Delimiters
(require 'init-rainbow-delimiters)

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

(require 'init-iedit)

(require 'init-impatient-markdown)
(require 'init-ace-window)
(require 'init-blamer)
(require 'init-diminish)
(require 'init-dashboard)
(require 'init-autopep8)

;;; Search Tools
(require 'init-ripgrep)

;;; Terminal Emulator
(require 'init-vterm)

;;; Programming Languages
(require 'init-lang-rust)

(require 'init-lang-scala)

(require 'init-lang-yaml)

(require 'init-lang-qml)

(require 'init-ansible)

;;; Display and Visual Enhancements
(require 'init-display-line-numbers)

(require 'init-highlight-numbers)

(require 'init-highlight-indent-guides)

;;; Smart Parentheses and Electric Mode
(require 'init-smartparens)

(require 'init-electric)

;;; Additional Tools
(require 'init-blink-search)

(require 'init-tabby)

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

(require 'init-mwim)

(require 'init-yank-indent)

;; semantic-refactor, use in c++ mode
(require 'init-srefactor)

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

(require 'init-highlight)

(require 'init-dired-ibuffer)

;;; View Mode and Minibuffer Setup
(add-hook 'view-mode-hook 'View-exit)

;; Diactive my all special keys for minibuffer
(add-hook 'minibuffer-setup-hook #'(lambda () (my-keys-minor-mode 0)))
(add-hook 'minibuffer-setup-hook #'(lambda () (my-special-buffer-keys-minor-mode 0)))

(require 'init-selected)
(put 'scroll-left 'disabled nil)

;;; init.el ends here
