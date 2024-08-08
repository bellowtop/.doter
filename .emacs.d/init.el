;; load emacs 24's package system. Add MELPA repository.
(define-key special-event-map [config-changed-event] #'ignore)

;; Set garbage collection threshold to 1GB.
;; (setq gc-cons-threshold #x20000000)


(require 'package)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
;; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)


(package-initialize)


(add-to-list 'exec-path "/usr/local/bin/")
(add-to-list 'exec-path "/usr/bin/")
(add-to-list 'exec-path "/opt/homebrew/bin")

(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
(setenv "PATH" (concat "/usr/bin:" (getenv "PATH")))
(setenv "PATH" (concat "/opt/homebrew/bin:" (getenv "PATH")))

(setq mac-command-modifier 'super)


(require 'cl)
(require 's)

;; more powerful than global-set-key! seems have the highest priority
(require 'bind-key)


;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook (lambda () (setq gc-cons-threshold (* 8192 8192))))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/.local/auto-save-list/" t)
(make-directory "~/.emacs.d/.local/autosaves/" t)
(make-directory "~/.emacs.d/.local/backups" t)


(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacswiki.org"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/blink-search"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/initializers"))
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/lisp"))



(setq diredp-hide-details-initially-flag nil)
(require 'dired+)


(require 'my-utils)



(require 'init-eshell)



(use-package benchmark-init
  :ensure t
  :config ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))



;; don't need it!!!
(electric-indent-mode 0)







(setq default-font "IBM Plex Mono 1.2-15.0")
;; ;;; https://github.com/supercomputra/SF-Mono-Font
;; setq default-font "SF Mono-16.0")
(set-face-attribute 'default nil :font default-font)
(setq default-frame-alist
  `(
     ;; (undecorated . t)  ;;;;会导致所有边框全部消失无法拖动调整窗口大小 需要加上后面两句
     ;; (drag-internal-border . 1)
     ;; (internal-border-width . 5)
     (vertical-scroll-bars) ;隐藏滚动条
     (left-fringe . 0) ;关闭左fringe
     (right-fringe . 0) ;关闭右fringe
     (font . ,default-font)
     (vertical-scroll-bars . nil)
     ))
(set-face-attribute 'region nil :inverse-video t)
(set-face-attribute 'show-paren-match nil :foreground "black" :background "yellow")
(setq-default left-margin-width 0 right-margin-width 0)

;; Set symbol for the border
(set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))
;;;
;;; My tiny Theme
;;;
(setq use-dark-theme-mode t)
(set-face-foreground 'default "#161c23")
(set-face-background 'default "white")
(set-face-attribute 'mode-line-inactive    nil :box nil)
(set-face-attribute 'mode-line-active      nil :box nil)
(set-face-attribute 'mode-line-highlight   nil :box nil :foreground "green")
(setq cursor-in-non-selected-windows nil)



 ;;;;  '(centaur-tabs-selected ((t ())))
 ;;;;  '(centaur-tabs-selected-modified ((t ())))

(if use-dark-theme-mode
  (progn
        (setq darker-window-bg-color "#26282F")
        (setq darker-window-fg-color "white")
        ;;
        (setq highlight-font-chars-face-fg "green")
        (setq highlight-font-chars-face-underline t)
        ;;
        (setq whitespace-tab-fg-color "#627D9D")
        (setq whitespace-trailing-fg-color "#59728F")
        ;;
        (setq hl-line-bg-color "#33485e")
        ;; dark theme!
        (invert-face 'default)
    )
  (progn
        (setq darker-window-bg-color "#FFFFFF")
        (setq darker-window-fg-color "black")
        ;;
        (setq highlight-font-chars-face-fg 'unspecified)
        (setq highlight-font-chars-face-underline t)
        ;;
        (setq whitespace-tab-fg-color "#627D9D")
        (setq whitespace-trailing-fg-color "#59728F")
        ;;
        (setq hl-line-bg-color (face-background 'highlight))
    )
  )
(defface my-highlight-font-chars-face
  `((t (
        :foreground ,highlight-font-chars-face-fg
        :underline ,highlight-font-chars-face-underline
        :weight normal
        )))
  "custom highlight for treemacs current line")



(load-theme 'bogster t)


(require 'init-god)


(require 'init-projectile)


(require 'init-treesit)


(require 'init-slime)


;; (require 'init-theme)


(require 'my-key-bindings)


(global-unset-key [(control z)])




(unless (display-graphic-p)
  (require 'my-catch-term-escape-key)
  (require 'init-term-cursor)
  (require 'my-term-popup)
  )



(setq warning-minimum-level :emergency)
(setq visible-bell t)
(setq ring-bell-function #'ignore)
;; all themes safe
(setq custom-safe-themes t)
(setq recenter-redisplay nil)
(setq blink-cursor-blinks 0)
(setq blink-cursor-interval 0.3)


(set-default 'truncate-lines t)


;; compile log with colors
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)



(require 'init-expand-region)


(toggle-truncate-lines t)


(require 'init-imenu)





(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

  ;; If there is more than one, they won't work right.
 ;;;;  '(ahs-definition-face ((t (:inherit ahs-plugin-default-face))))
 ;;;;  '(ahs-definition-face-unfocused ((t (:inherit ahs-plugin-default-face))))
 ;;;;  '(ahs-face ((t (:inherit ahs-plugin-default-face))))
 ;;;;  '(ahs-plugin-default-face ((t (:background "#59dcb7" :foreground "Black"))))
 ;;;;  '(centaur-tabs-selected ((t (:inherit default :foreground "black" :background "#FFC44C" :weight normal))))
 ;;;;  '(centaur-tabs-selected-modified ((t (:inherit centaur-tabs-selected :foreground "black"))))
 ;;;;  '(centaur-tabs-unselected ((t (:foreground "#969696" :background "#262830"))))
 ;;;;  '(centaur-tabs-unselected-modified ((t (:inherit centaur-tabs-unselected :foreground "white"))))
 ;;;;  '(company-preview-common ((t (:inherit font-lock-comment :foreground "white" :weight normal))))
 ;;;;  '(corfu-default ((t (:inherit default))))
 ;;;;  '(counsel-outline-default ((t (:inherit green))))
 ;;;;  '(deadgrep-filename-face ((t (:inherit bold :foreground "green"))))
 ;;;;  '(deadgrep-match-face ((t (:foreground "#7fdc59" :background "#232d38" :weight normal))))
 ;;;;  '(deadgrep-search-term-face ((t (:foreground "#000000" :background "#7fdc59" :weight normal))))
 ;;;;  '(diff-added ((t (:extend t :foreground "green" :background "black"))))
 ;;;;  '(diff-indicator-added ((t (:extend t :foreground "green" :background "black"))))
 ;;;;  '(diff-indicator-removed ((t (:extend t :foreground "red" :background "black"))))
 ;;;;  '(diff-removed ((t (:extend t :foreground "red" :background "black"))))
 ;;;;  '(doom-modeline-buffer-file ((t (:inherit nil))))
 ;;;;  '(doom-modeline-buffer-major-mode ((t (:inherit nil))))
 ;;;;  '(doom-modeline-buffer-minor-mode ((t nil)))
 ;;;;  '(doom-modeline-buffer-modified ((t (:inherit nil))))
 ;;;;  '(doom-modeline-buffer-path ((t nil)))
 ;;;;  '(doom-modeline-god ((t (:foreground "red" :weight bold))))
 ;;;;  '(doom-modeline-info ((t (:inherit nil))))
 ;;;;  '(doom-modeline-project-dir ((t (:inherit nil))))
 ;;;;  '(doom-modeline-project-parent-dir ((t (:inherit nil))))
 ;;;;  '(doom-modeline-project-root-dir ((t (:inherit nil))))
 ;;;;  '(eglot-highlight-symbol-face ((t (:inherit highlight))))
 ;;;;  '(eldoc-box-body ((t (:inherit default))))
 ;;;;  '(flymake-diagnostic-at-point-posframe-background-face ((t (:background "dark magenta"))))
 ;;;;  '(flymake-error ((t (:foreground "DeepPink" :underline (:color foreground-color :style line :position line)))))
 ;;;;  '(flymake-error-echo ((t nil)))
 ;;;;  '(flymake-warning ((t (weight normal))))
 ;;;;  '(flymake-warning-echo ((t nil)))
 ;;;;  '(fringe ((t :background "#161c23")))
 ;;;;  '(header-line ((t :box (:line-width 4 :color "grey20" :style nil))))
 ;;;;  '(header-line-highlight ((t :box (:color "#e5ded6"))))
 ;;;;  '(helm-selection ((t (:foreground "white" :background "purple"))))
 ;;;;  '(help-argument-name ((t (:inherit italic :underline nil))))
 ;;;;  '(highlight ((t (:background "#7ED9B9" :foreground "black" :weight normal))))
 ;;;;  ;; '(hl-line ((t (:extend t :background "#33485e" :underline nil))))
 ;;;;  '(hydra-face-red ((t (:foreground "chocolate" :weight bold))))
 ;;;;  '(iedit-occurrence ((t (:inherit nil :foreground "yellow"))))
 ;;;;  '(isearch ((t (:background "orange1" :foreground "black" :weight normal :inverse-video nil))))
 ;;;;  '(ivy-current-match ((t (:inherit region :background nil :foreground nil))))
 ;;;;  '(ivy-posframe ((t (:background "black"))))
 ;;;;  '(ivy-posframe-border ((t (:background "green"))))
 ;;;;  '(keycast-key ((t)))
 ;;;;  '(lazy-highlight ((t (:background "light green" :foreground "black" :weight normal))))
 ;;;;  '(line-number ((t (:inherit default :foreground "#565575" :slant normal :weight normal))))
 ;;;;  '(line-number-current-line ((t (:inherit (hl-line default) :foreground "#CBE3E7" :slant normal :weight normal))))
 ;;;;  '(lsp-face-highlight-read ((t (:foreground "#000000" :background "#7fdc59" :weight normal))))
 ;;;;  '(lsp-face-highlight-textual ((t (:foreground "#000000" :background "#7fdc59" :weight normal))))
 ;;;;  '(lsp-face-highlight-write ((t (:foreground "#000000" :background "#7fdc59" :weight normal))))
 ;;;;  '(magit-diff-added ((t (:extend t :foreground "forest green"))))
 ;;;;  '(magit-diff-added-highlight ((t (:extend t :background "black" :foreground "green"))))
 ;;;;  '(magit-diff-file-heading ((t (:extend t :weight normal))))
 ;;;;  '(magit-diff-file-heading-highlight ((t (:extend t :background "black" :weight bold))))
 ;;;;  '(magit-diff-hunk-heading ((t (:extend t :background "#252832" :foreground "yellow4"))))
 ;;;;  '(magit-diff-hunk-heading-highlight ((t (:extend t :background "black" :foreground "yellow"))))
 ;;;;  '(magit-diff-removed ((t (:extend t :foreground "indian red"))))
 ;;;;  '(magit-diff-removed-highlight ((t (:extend t :background "black" :foreground "red"))))
 ;;;;  '(mc/region-face ((t (:foreground "#ff77cc" :inverse-video t :weight normal))))
 ;;;;  '(minibuffer-prompt ((t (:inherit default :foreground "white" :background "#1E2127" :weight normal))))
 ;;;;  '(mode-line ((t (:background "#262831" :foreground "#7AA2F7" :overline "#374250" :box nil))))
 ;;;;  '(mode-line-active ((t :box nil)))
 ;;;;  '(mode-line-highlight ((t :box nil)))
 ;;;;  ;; '(mode-line-inactive ((t (:box nil))))
 ;;;;  '(mode-line-inactive ((t (:background "#262831" :foreground "#C4C4C4" :overline "#374250" :box nil))))
 ;;;;  '(next-error ((t (:foreground "#000000" :background "#00ff00"))))
 ;;;;  '(region ((t (:inverse-video t :foreground nil :background nil))))
 ;;;;  '(show-paren-match ((t (:foreground "black" :background "yellow"))))
 ;;;;  '(symbol-overlay-default-face ((t (:inherit my-highlight-font-chars-face))))
 ;;;;  '(tab-bar-tab ((t :box (:line-width 4 :color "grey85" :style nil))))
 ;;;;  '(tab-bar-tab-inactive ((t :box (:line-width 4 :color "grey75" :style nil))))
 ;;;;  '(tab-line ((t (:inherit variable-pitch :background "#1F2335" :foreground "black"))))
 ;;;;  '(tab-line-tab ((t)))
 ;;;;  '(tab-line-tab-active ((t)))
 ;;;;  '(tab-line-tab-inactive ((t)))
 ;;;;  '(term-color-black ((t (:foreground "#282a36" :background "#6272a4"))))
 ;;;;  '(term-color-blue ((t (:foreground "#bd93f9" :background "#bd93f9"))))
 ;;;;  '(term-color-cyan ((t (:foreground "#8be9fd" :background "#8be9fd"))))
 ;;;;  '(term-color-green ((t (:foreground "#50fa7b" :background "#50fa7b"))))
 ;;;;  '(term-color-magenta ((t (:foreground "#ff79c6" :background "#ff79c6"))))
 ;;;;  '(term-color-red ((t (:foreground "#ff5555" :background "#ff5555"))))
 ;;;;  '(term-color-white ((t (:foreground "#f8f8f2" :background "#656555"))))
 ;;;;  '(term-color-yellow ((t (:foreground "#f1fa8c" :background "#f1fa8c"))))
 ;;;;  '(term-default-bg-color ((t (:inherit term-color-black))))
 ;;;;  '(term-default-fg-color ((t (:inherit term-color-white))))
 ;;;;  '(tty-menu-enabled-face ((t (:inherit hl-line))))
 ;;;;  '(tty-menu-selected-face ((t (:inherit eglot-highlight-symbol-face))))
 ;;;;  '(vertical-border ((t :background "#161c23" :foreground "#161c23")))
 ;;;;  '(whitespace-trailing ((t (:background "black" :foreground "#42546A" :weight bold))))
 ;;;;  '(widget-field ((t (:extend t :background "gray" :foreground "black"))))
 ;;;;  '(window-divider ((t (:foreground "green"))))
 ;;;;  '(window-divider-first-pixel ((t (:background "#161c23" :foreground "#161c23"))))
 ;;;;  '(window-divider-last-pixel ((t (:background "#161c23" :foreground "#161c23"))))
 ;;;;  '(xref-match ((t (:inherit region))))
 ;;;;  '(yas-field-highlight-face ((t (:foreground "#000000" :background "#7fdc59" :weight normal))))








(require 'my-highlight-current-line)





(require 'init-nice-jumper)



(require 'init-mouse)



(require 'init-xref)



(with-eval-after-load 'pulse
  ;;   ;; (set-face-attribute 'pulse-highlight-face nil :foreground 'unspecified :background "#1f4670")
  ;;   ;; (set-face-attribute 'pulse-highlight-face nil :foreground 'unspecified :background 'unspecified :inverse-video t)
  ;;   ;; (set-face-attribute 'pulse-highlight-start-face nil :foreground "green" :background "black")
  (setq pulse-delay 0.01) ;; pulse fast!
  )


(require 'init-format-all)



(setq ansi-color-names-vector ["black" "tomato" "PaleGreen2" "gold1" "DeepSkyBlue1" "MediumOrchid1" "cyan" "white"])
(setq ansi-color-map (ansi-color-make-color-map))  ;; helped line




;; (setq display-buffer-alist
;;   `
;;   (
;;     ("*eldoc*"
;;       (display-buffer-in-side-window)
;;       (side . bottom)
;;       (window-height . 0.16)
;;       (slot . 0))))


(require 'init-eldoc)


(require 'custom-util-funcs)


(require 'init-eglot)

;; (require 'init-lang-java)
;; (require 'download-lombok)

(require 'init-lang-go)


(require 'init-lang-cpp)


(require 'init-lang-zig)


(require 'init-lang-swift)


(require 'init-company)


(require 'init-yasnippet)


;; (use-package transpose-frame
;;   :defer t)





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
    '(csv-mode inkpot-theme srcery-theme package-lint with-simulated-input solaire-mode dashboard dashboard-hackernews blamer paredit slime-company symbol-overlay elisp-autofmt corfu-terminal py-autopep8 popon format-all apheleia ivy-xref jsonrpc imenu-list treesit-auto highlight-numbers modus-themes nano-theme vs-dark-theme treemacs-all-the-icons centaur-tabs bazel general swift-mode color-theme-sanityinc-tomorrow lispy markdown-mode vscode-dark-plus-theme diminish eglot elisp-def elisp-refs slime elisp-slime-nav leetcode srefactor ivy-posframe counsel ivy popup-switcher popwin beacon rjsx-mode typescript-mode impatient-mode reformatter auto-dim-other-buffers atom-one-dark-theme jdecomp smart-jump ansible moe-theme selected benchmark-init with-proxy valign markdown-toc markdownfmt disable-mouse rainbow-delimiters key-chord google-c-style phi-search switch-buffer-functions yasnippet highlight-parentheses undo-tree nimbus-theme challenger-deep-theme afternoon-theme smooth-scrolling project There are no known projectsile-mode smart-mode-line cyberpunk-theme lsp-python-ms protobuf-mode vue-mode xclip mwim ripgrep neotree easy-kill helm-rg))
 '(pos-tip-background-color "#1d1d2b")
 '(pos-tip-foreground-color "#d4d4d6")
 '(projectile-globally-ignored-directories
    '("/opt/homebrew" "^\\.idea$" "^\\.vscode$" "^\\.ensime_cache$" "^\\.eunit$" "^\\.git$" "^\\.hg$" "^\\.fslckout$" "^_FOSSIL_$" "^\\.bzr$" "^_darcs$" "^\\.pijul$" "^\\.tox$" "^\\.svn$" "^\\.stack-work$" "^\\.ccls-cache$" "^\\.cache$" "^\\.clangd$" ".cache" "build"))
 '(recentf-save-file (expand-file-name "~/.emacs.d/.local/recentf"))
 '(warning-suppress-log-types '((emacs) (use-package) (lsp-mode)))
 '(warning-suppress-types '((use-package) (lsp-mode))))


;; lsp-mode session file
(setq lsp-session-file (expand-file-name "~/.emacs.d/.local/.lsp-session-v1"))


(require 'init-whitespace-mode)


(use-package iedit
  :defer t
  :bind (("C-M-'" . iedit-mode)))


(require 'init-impatient-markdown)


(require 'init-ace-window)


(require 'init-centaur)

;; (require 'init-tabline)


(require 'init-blamer)


(require 'init-diminish)


(require 'init-dashboard)


(require 'init-autopep8)



(use-package rust-mode
  :defer t :init)

(use-package scala-mode
  :defer t :interpreter ("scala" . scala-mode))

(use-package yaml-mode
  :defer t
  :hook
  (yaml-mode . display-line-numbers-mode)
  (yaml-ts-mode . display-line-numbers-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yml\\.j2\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\.j2\\'" . yaml-mode)))


(use-package ansible
  :defer t)


(require 'init-display-line-numbers)



(use-package yaml-mode
  :defer t
  :hook
  (prog-mode . highlight-numbers-mode))




(defun my-cmake-mode-hook ()
  (setq cmake-tab-width 4))

(add-hook 'cmake-mode-hook 'my-cmake-mode-hook)


(defun my-elisp-mode-hook ()
  (setq indent-tabs-mode nil)
  (setq lisp-indent-offset 2))

(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-hook)
(add-hook 'lisp-mode-hook 'my-elisp-mode-hook)


(require 'init-smartparens)


(require 'init-blink-search)


(require 'init-ivy)


(require 'init-flymake)




(delete-selection-mode 1)


(add-hook 'org-mode-hook #'valign-mode)

(add-hook 'markdown-mode-hook #'valign-mode)

(column-number-mode 1)

;; (add-hook 'markdown-mode-hook #'prog-mode)


(require 'init-scroll-keys)




;; truncate-lines right margin sign
(set-display-table-slot standard-display-table 0 ?→)





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
  (keyboard-quit-context+) ;; from custom-util-funcs.el
  )

;; (global-set-key [remap keyboard-quit] #'my-escape-key)

(bind-key (kbd "<escape>") #'my-escape-key)
(bind-key (kbd "<escape>") #'minibuffer-keyboard-quit minibuffer-local-map)
;; (define-key helm-map (kbd "<escape>") #'helm-keyboard-quit)


;; must be set as global
(bind-key (kbd "C-S-k") #'my-delete-to-beginning)
(bind-key (kbd "C-k") #'my-delete-to-end)
(bind-key (kbd "C-j") #'save-buffer)
(bind-key (kbd "<RET>") #'newline-and-indent)

(bind-key* (kbd "C-<wheel-up>") #'ignore)
(bind-key* (kbd "C-<wheel-down>") #'ignore)


(when (display-graphic-p)
  (bind-key [escape] 'my-escape-key)
  (define-key input-decode-map [?\C-\[] (kbd "<C-[>"))
  (bind-key (kbd "<C-[>") 'my-escape-key))


(setq smex-save-file (expand-file-name "~/.emacs.d/.local/smex-items.cache"))



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


(which-key-mode 1)


(xclip-mode 1)


(save-place-mode 1)

(require 'mwim)
(global-set-key [remap move-end-of-line] #'mwim-end-of-code-or-line)
(global-set-key [remap move-beginning-of-line] #'mwim-beginning-of-code-or-line)

(require 'yank-indent)
(global-yank-indent-mode 1)


;; semantic-refactor, use in c++ mode
(require 'srefactor)
(semantic-mode 1) ;; -> this is optional for Lisp

(define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)



(require 'my-toggle-code-intelligence)

(add-hook 'isearch-mode-hook #'my-disable-code-intelligence)
(add-hook 'isearch-mode-end-hook #'my-enable-code-intelligence)


(require 'init-emacs-lispy)


;; for hl-line+.el
(setq hl-line-inhibit-highlighting-for-modes
  '(dired-mode deadgrep-mode deadgrep-edit-mode treemacs-mode))

(global-hl-line-mode 0)


(set-face-background 'line-number (face-background 'default))
(set-face-background 'line-number-current-line (face-background 'hl-line))


(require 'init-modeline)


(toggle-truncate-lines t)


(global-auto-revert-mode 1)


;;;  treats underscores as part of words
(superword-mode 1)


(require 'init-all-the-icons)


(require 'init-neotree)


(require 'init-treemacs)


(require 'init-multi-cursor)


(require 'init-undo-tree)


(require 'init-hydra)


(require 'init-deadgrep)


(require 'highlight)


(require 'init-dired-ibuffer)



(add-hook 'view-mode-hook 'View-exit)
;; (add-hook 'view-mode-hook 'my-special-buffer-keys-minor-mode)


;; Diactive my all special keys for minibuffer
(add-hook 'minibuffer-setup-hook #'(lambda () (my-keys-minor-mode 0)))
(add-hook 'minibuffer-setup-hook #'(lambda () (my-special-buffer-keys-minor-mode 0)))
;; (add-hook 'helm-minibuffer-set-up-hook #'(lambda () (my-special-buffer-keys-minor-mode 0)))


;; remap TAB -> control-i
;; (define-key input-decode-map [?\C-i] [control-i])

(require 'init-selected)
(put 'scroll-left 'disabled nil)
