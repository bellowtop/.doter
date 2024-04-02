;; load emacs 24's package system. Add MELPA repository.
(define-key special-event-map [config-changed-event] #'ignore)

;; unset C-m, seperate it with the RET key
;; (define-key input-decode-map [?\C-m] [C-m])

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


(use-package
  exec-path-from-shell
  :config (exec-path-from-shell-initialize))


;; eshell with colors
;; SEE https://emacs.stackexchange.com/questions/51027/missing-color-support-for-exa-in-eshell
(setq comint-terminfo-terminal "dumb-emacs-ansi")

(let* ((terminfo-file (format "~/.terminfo/%s.ti" comint-terminfo-terminal))
       (default-directory (file-name-directory terminfo-file)))
  (unless (file-exists-p terminfo-file)
    (make-directory default-directory t)
    (with-temp-buffer
      (insert "dumb-emacs-ansi|Emacs dumb terminal with ANSI color codes,
    am,
    colors#8, it#8, ncv#13, pairs#64,
    bold=\\E[1m, cud1=^J, ht=^I, ind=^J, op=\\E[39;49m,
    ritm=\\E[23m, rmul=\\E[24m, setab=\\E[4%p1%dm,
    setaf=\\E[3%p1%dm, sgr0=\\E[m, sitm=\\E[3m, smul=\\E[4m,")
      (write-file terminfo-file)))
  (unless (file-exists-p (concat default-directory "d/" comint-terminfo-terminal))
    (start-process "*tic process*" "*Messages*" "tic" (expand-file-name terminfo-file))))

(add-hook 'eshell-mode-hook '(lambda ()
                               (setenv "TERM" comint-terminfo-terminal)
                               (setenv "PAGER" "cat")))




(use-package
  benchmark-init
  :ensure t
  :config ;; To disable collection of benchmark data after init is done.
  (add-hook
   'after-init-hook
   'benchmark-init/deactivate))


(require 'cl)
(require 's)


;; Minimize garbage collection during startup
(setq gc-cons-threshold
      most-positive-fixnum)

;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook
 'emacs-startup-hook
 (lambda ()
   (setq gc-cons-threshold
         (expt 2 23))))


;; (setq  x-meta-keysym 'super
;;         x-super-keysym 'meta)
;;
;; (when (eq system-type 'darwin)
;;    (setq mac-option-modifier 'super
;;          mac-command-modifier 'meta))




;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/.local/auto-save-list/" t)
(make-directory "~/.emacs.d/.local/autosaves/" t)
(make-directory "~/.emacs.d/.local/backups" t)




(add-to-list 'load-path (expand-file-name "~/.emacs.d/emacswiki.org"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/lisp"))




(defun darker-background-for-sidebar ()
  (face-remap-add-relative 'default '(:background "#1E2127") )
  )


;; don't need it!!!
(electric-indent-mode -1)



(require 'god-mode)
(setq god-exempt-major-modes nil)
(setq god-exempt-predicates nil)
(setq god-mode-alist
      '((nil . "C-")
        ("r" . "M-")
        ("R" . "C-M-")))


(setq ignored-projectile-projects (list "/opt/homebrew/" "Xcode.app"))
(defun ignored-projectile-project (project-root)
  (seq-filter
   (lambda (candidate) (string-search candidate project-root))
   ignored-projectile-projects))

(setq-default
   projectile-cache-file (expand-file-name "~/.emacs.d/.local/projectile.cache")
   projectile-known-projects-file (expand-file-name "~/.emacs.d/.local/projectile-bookmarks.eld")
   projectile-enable-caching t
   projectile-indexing-method 'native
   projectile-track-known-projects-automatically t
   projectile-ignored-project-function 'ignored-projectile-project
)
(require 'projectile)
(projectile-mode 1)


;;;; Deprecated: treesit-auto handle these automatically
;; download from https://github.com/emacs-tree-sitter/tree-sitter-langs
;; rename .dylib to libtree-sitter*: fd -t f dylib --exclude 'libtree*' --exec mv {} libtree-sitter-{/} \;
;;
;; you can also put them to ~/.emacs.d/tree-sitter, so without setting the treesit-extra-load-path



(use-package treesit
  :demand t
  :custom
  (treesit-font-lock-level 4) ;; skittles highlighting
  :init
  (push '(css-mode . css-ts-mode) major-mode-remap-alist)
  (push '(sh-mode . bash-ts-mode) major-mode-remap-alist)
  (push '(python-mode . python-ts-mode) major-mode-remap-alist)
  (push '(javascript-mode . js-ts-mode) major-mode-remap-alist)
  (push '(js-json-mode . json-ts-mode) major-mode-remap-alist)
  (push '(typescript-mode . typescript-ts-mode) major-mode-remap-alist)
  ;; (push '(go-mode . go-ts-mode) major-mode-remap-alist) ;; go-mode does not support treesitter yet.
  (push '(c-mode . c-ts-mode) major-mode-remap-alist)
  (push '(c++-mode . c++-ts-mode) major-mode-remap-alist)
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-ts-mode))  ;; tell h file to c++-ts-mode
  ;; (setq treesit-extra-load-path `( ,(expand-file-name "~/.emacs.d/.local/tree-sitter-grammars") ))
  )


;; invoke M-x treesit-auto-install-all to install treesit libs to ~/.emacs.d/tree-sitter/
(use-package treesit-auto
  :config
  (global-treesit-auto-mode))



(setq inferior-lisp-program (executable-find "sbcl"))




;;
;; remove wave and add PROPER underline
;;
;; https://www.reddit.com/r/emacs/comments/gn7br8/configure_wavy_underline/
;;
;; no waves, use underlines which look better
(defun theme-tweaks-flatten-underline+ (face)
  "Change underline style of FACE from wave to straight line."
  (let ((underline (face-attribute face :underline)))
    (when (eq (plist-get underline :style) 'wave)
      (plist-put underline :style 'line)
      (set-face-attribute face nil :underline underline))))
;; initial flattening
(mapatoms (lambda (atom)
            (when (facep atom)
              (theme-tweaks-flatten-underline+ atom))))
;; flatten on each face definition in the future
(define-advice custom-declare-face (:around (fun &rest args) flatten-face)
  (let ((face (apply fun args)))
    (theme-tweaks-flatten-underline+ face)
    face))





(defun which-active-modes ()
  "Give a message of which minor modes are enabled in the current buffer."
  (interactive)
  (let ((active-modes))
    (mapc
     (lambda (mode)
       (condition-case nil
           (if (and (symbolp mode)
                    (symbol-value mode))
               (add-to-list
                'active-modes
                mode))
         (error nil)))
     minor-mode-list)
    (message
     "Active modes are %s"
     active-modes)))

(require 'diminish)
(defun purge-minor-modes ()
    (diminish 'flymake-mode)
    (diminish 'my-ctrl-w-window-keys-minor-mode)
    (diminish 'ivy-mode)
    (diminish 'ivy-posframe-mode)
    (diminish 'which-key-mode)
    (diminish 'selected-minor-mode)
    (diminish 'selected-global-mode)
    (diminish 'my-keys-minor-mode)
    (diminish 'projectile-mode)
    (diminish 'global-hl-line-mode)
    (diminish 'highlight-parentheses-mode)
    (diminish 'undo-tree-mode)
    (diminish 'company-mode)
    (diminish 'company-posframe-mode)
    (diminish 'global-company-mode)
    (diminish 'line-number-mode)
    (diminish 'global-eldoc-mode)
    (diminish 'eldoc-mode)
    (diminish 'yas-minor-mode)
    (diminish 'smartparens-mode)
    (diminish 'smartparens-global-mode)
    (diminish 'show-paren-mode)
    (diminish 'abbrev-mode)
    (diminish 'electric-indent-mode))
(add-hook 'after-change-major-mode-hook 'purge-minor-modes)



(require 'my-key-bindings)


(global-unset-key [(control z)])

(setq warning-minimum-level :emergency)


;; (defun suspend-and-run ()
;;     (interactive)
;;     (suspend-emacs "echo test && sleep 5 && fg"))
;;
;; (global-set-key (kbd "<f5>") 'suspend-and-run)



;; (use-package vscode-dark-plus-theme
;;   :ensure t
;;   :config
;;   (load-theme 'vscode-dark-plus t))


(require 'autothemer)
(load-theme 'bogster t)

;; (load-theme 'spolsky t)

;; (require 'vs-dark-theme)
;; (load-theme 'vs-dark t)

;; (load-theme 'modus-vivendi-tinted t)

;; (if (display-graphic-p)
;;   ;; (load-theme 'doom-challenger-deep t)
;;

;; (require 'atom-one-dark-theme)
;; (setf atom-one-dark-colors-alist (assoc-delete-all "atom-one-dark-bg" atom-one-dark-colors-alist))
;; (add-to-list 'atom-one-dark-colors-alist '("atom-one-dark-bg" if nil "color-235" "#161C23"))
;; (load-theme 'atom-one-dark t)



(use-package doom-themes
   :ensure t
   :config
;;   (setq doom-themes-enable-bold nil    ; if nil, bold is universally disabled
;;         doom-themes-enable-italic nil) ; if nil, italics is universally disabled
   (doom-themes-neotree-config)
   ;; (doom-themes-treemacs-config)
   ;; (setq doom-themes-neotree-file-icons t)
   ;; (setq doom-themes-treemacs-theme "doom-colors")

;;   ;; (load-theme 'doom-xcode t)
;;   (load-theme 'doom-dracula t)
;;   ;; (load-theme 'doom-oceanic-next t)
   )

;; (load-theme 'kaolin-ocean t)

;; (load-theme 'spacemacs-dark t)
;; (load-theme 'dracula t)
;; (load-theme 'spacemacs-dark t)
;; (load-theme 'dracula t)
;; (load-theme 'kaolin-ocean t)
;; (load-theme 'cyberpunk t)
;; (load-theme 'atom-one-dark t)
;; (load-theme 'doom-molokai t)
;; (load-theme 'doom-palenight t)
;; (load-theme 'doom-material-dark t)
;; (load-theme 'doom-dracula t)
;; (load-theme 'kaolin-aurora t)
;; (load-theme 'challenger-deep t)
;; (load-theme 'kaolin-temple t)
;; (load-theme 'kaolin-ocean t)
;; (load-theme 'doom-material t)
;; (load-theme 'atom-one-dark t)
;; (load-theme 'one-dark-pro t)

;; (require 'color-theme-sanityinc-tomorrow)
;; (load-theme 'sanityinc-tomorrow-blue t)




;;
;; after load theme, clear the fringe color
;;

(defun my-clear-fringe-color ()
  (set-face-attribute 'fringe nil
                      :background (face-background 'default)
                      :foreground (face-foreground 'default)
                      ))
(my-clear-fringe-color)







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

(set-default 'truncate-lines t)



;; compile log with colors
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)






(use-package expand-region
  :bind
  (
   ("M-i" . 'er/expand-region)
   )
  )


(advice-add 'er/expand-region
            :before
            (lambda (&rest r) (my-remove-all-highlight)))

(advice-add 'er/mark-inside-pairs
            :before
            (lambda (&rest r) (my-remove-all-highlight)))


;;;;
;;;; already handled by selected-region-active-mode
;;;;
;;; (advice-add 'er--prepare-expanding
;;;     :before
;;;     (lambda (&rest r)
;;;       (my-disable-code-intelligence))
;;;     '((name . "er-start"))
;;; )
;;;
;;; ;; if er/contract-region is called with 0 as args, it means quit
;;; (advice-add 'er/contract-region
;;;     :before
;;;     (lambda (&rest args)
;;;       (if (eq (car args) 0) (my-enable-code-intelligence))
;;;       )
;;;     '((name . "er-end"))
;;; )





(toggle-truncate-lines t)




;; imenu size sidebar width, 0.20 of screen
;; NOTE: <SPC>-i to toggle imenu sidebar
(setq imenu-list-size 0.20)
(setq imenu-list-auto-update nil)

(defun my-enlarge-imenu-width()
  (interactive)
  (enlarge-window-horizontally (/ (frame-width) 3))
  )

(defun my-shrink-imenu-width()
  (interactive)
  (shrink-window-horizontally (/ (frame-width) 3))
  )

(defun my-fit-imenu-width()
  (interactive)
  (imenu-list-resize-window)
  )

(defun my-imenu-list-check-window-is-open()
  (interactive)
  (and
    (bound-and-true-p imenu-list-buffer-name)
    (get-buffer-window imenu-list-buffer-name t)
    t)
  )

(defun my-imenu-list-smart-toggle-refresh()
  (interactive)
  (when (my-imenu-list-check-window-is-open)
      (imenu-list-quit-window)
  )
  (imenu-list-minor-mode 1)
  (select-window (get-buffer-window (imenu-list-get-buffer-create)))
)

(use-package imenu-list
  :defer t
  :bind (
    (:map imenu-list-major-mode-map
         ("H" . my-enlarge-imenu-width)
         ("M" . my-fit-imenu-width)
         ("L" . my-shrink-imenu-width)
         ("m" . my-imenu-list-smart-toggle-refresh)
    )
  )
)




(defun my-set-bigger-spacing ()
  ;; (setq-local default-text-properties '(line-spacing 0.15 line-height 1.15))
  (setq-local default-text-properties '(line-spacing 0 line-height 1))
  )
(add-hook 'text-mode-hook 'my-set-bigger-spacing)
(add-hook 'prog-mode-hook 'my-set-bigger-spacing)





;; Check if system is Darwin/Mac OS X
(defun my-system-type-is-darwin ()
  "Return true if system is darwin-based (Mac OS X)"
  (string-equal
   system-type
   "darwin"))

;; Check if system is Microsoft Windows
(defun my-system-type-is-windows ()
  "Return true if system is Windows-based (at least up to Win7)"
  (string-equal
   system-type
   "windows-nt"))

;; Check if system is GNU/Linux
(defun my-system-type-is-gnu ()
  "Return true if system is GNU/Linux-based"
  (string-equal
   system-type
   "gnu/linux"))


(set-face-attribute 'default nil :font "IBM Plex Mono-16.0")
(add-to-list 'default-frame-alist '(font . "IBM Plex Mono-16.0"))

(when (my-system-type-is-darwin)
  (set-face-attribute 'default nil :font "IBM Plex Mono-16.0") ;;; :weight 'light)
  (add-to-list 'default-frame-alist '(font . "IBM Plex Mono-16.0")))


;; ;;; https://github.com/supercomputra/SF-Mono-Font
;; ;;;
;; (set-face-attribute 'default nil :font "SF Mono-16.0")
;; (add-to-list 'default-frame-alist '(font . "SF Mono-16.0"))
;;
;; (when (my-system-type-is-darwin)
;;   (set-face-attribute 'default nil :font "SF Mono-16.0" :weight 'light)
;;   (add-to-list 'default-frame-alist '(font . "SF Mono-16.0")))

(set-cursor-color "red")
(setq-default cursor-type 'bar)
(setq-default cursor-in-non-selected-windows nil)

;; (set-face-attribute 'region nil :background "#666")





(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(centaur-tabs-selected ((t (:inherit mode-line :inverse-video t))))
 '(centaur-tabs-selected-modified ((t (:inherit centaur-tabs-selected :foreground "pink"))))
 '(centaur-tabs-unselected ((t (:inherit mode-line))))
 '(centaur-tabs-unselected-modified ((t (:inherit centaur-tabs-unselected :foreground "pink"))))
 '(counsel-outline-default ((t (:inherit green))))
 '(deadgrep-match-face ((t (:foreground "#7fdc59" :background "#232d38" :weight normal))))
 '(deadgrep-search-term-face ((t (:foreground "#000000" :background "#7fdc59" :weight normal))))
 '(diff-added ((t (:extend t :foreground "green" :background "black"))))
 '(diff-indicator-added ((t (:extend t :foreground "green" :background "black"))))
 '(diff-indicator-removed ((t (:extend t :foreground "red" :background "black"))))
 '(diff-removed ((t (:extend t :foreground "red" :background "black"))))
 '(doom-modeline-buffer-file ((t (:inherit nil))))
 '(doom-modeline-buffer-major-mode ((t (:inherit nil))))
 '(doom-modeline-buffer-minor-mode ((t nil)))
 '(doom-modeline-buffer-modified ((t (:inherit nil))))
 '(doom-modeline-buffer-path ((t nil)))
 '(doom-modeline-god ((t (:foreground "red" :weight bold))))
 '(doom-modeline-info ((t (:inherit nil))))
 '(doom-modeline-project-dir ((t (:inherit nil))))
 '(doom-modeline-project-parent-dir ((t (:inherit nil))))
 '(doom-modeline-project-root-dir ((t (:inherit nil))))
 '(eglot-highlight-symbol-face ((t (:background "#59dcb7" :foreground "black" :weight normal))))
 '(eglot-mode-line ((t nil)))
 '(eldoc-box-body ((t (:inherit default))))
 '(flymake-diagnostic-at-point-posframe-background-face ((t (:background "dark magenta"))))
 '(flymake-error ((t (:foreground "DeepPink" :underline (:color foreground-color :style line :position line)))))
 '(flymake-error-echo ((t nil)))
 '(flymake-warning ((t (weight normal))))
 '(flymake-warning-echo ((t nil)))
 '(helm-selection ((t (:foreground "white" :background "purple"))))
 '(help-argument-name ((t (:inherit italic :underline nil))))
 '(highlight ((t (:background "#7ED9B9" :foreground "black" :weight normal))))
 '(hl-line ((t (:extend nil :background "#33485e" :underline nil))))
 '(hydra-face-red ((t (:foreground "chocolate" :weight bold))))
 '(isearch ((t (:background "orange1" :foreground "black" :weight normal))))
 '(ivy-current-match ((t (:inherit region :background nil :foreground nil))))
 '(ivy-posframe ((t (:background "black"))))
 '(ivy-posframe-border ((t (:background "green"))))
 '(lazy-highlight ((t (:background "light green" :foreground "black" :weight normal))))
 '(line-number ((t (:inherit default :foreground "#565575" :slant normal :weight normal))))
 '(line-number-current-line ((t (:inherit (hl-line default) :foreground "#CBE3E7" :slant normal :weight normal))))
 '(lsp-face-highlight-read ((t (:foreground "#000000" :background "#7fdc59" :weight normal))))
 '(lsp-face-highlight-textual ((t (:foreground "#000000" :background "#7fdc59" :weight normal))))
 '(lsp-face-highlight-write ((t (:foreground "#000000" :background "#7fdc59" :weight normal))))
 '(magit-diff-added ((t (:extend t :foreground "forest green"))))
 '(magit-diff-added-highlight ((t (:extend t :background "black" :foreground "green"))))
 '(magit-diff-file-heading ((t (:extend t :weight normal))))
 '(magit-diff-file-heading-highlight ((t (:extend t :background "black" :weight bold))))
 '(magit-diff-hunk-heading ((t (:extend t :background "#252832" :foreground "yellow4"))))
 '(magit-diff-hunk-heading-highlight ((t (:extend t :background "black" :foreground "yellow"))))
 '(magit-diff-removed ((t (:extend t :foreground "indian red"))))
 '(magit-diff-removed-highlight ((t (:extend t :background "black" :foreground "red"))))
 '(mc/region-face ((t (:foreground "#ff77cc" :inverse-video t :weight normal))))
 '(mode-line ((t (:background "#262831" :foreground "#7AA2F7" :overline "#374250" :box nil))))
 '(mode-line-inactive ((t (:background "#262831" :foreground "#7AA2F7" :overline "#374250" :box nil))))
 '(next-error ((t (:foreground "#000000" :background "#00ff00"))))
 '(region ((t (:inverse-video t :foreground nil :background nil))))
 '(show-paren-match ((t (:foreground "green" :weight bold))))
 '(tab-line ((t (:inherit variable-pitch :background "#1F2335" :foreground "black"))))
 '(term-color-black ((t (:foreground "#282a36" :background "#6272a4"))))
 '(term-color-blue ((t (:foreground "#bd93f9" :background "#bd93f9"))))
 '(term-color-cyan ((t (:foreground "#8be9fd" :background "#8be9fd"))))
 '(term-color-green ((t (:foreground "#50fa7b" :background "#50fa7b"))))
 '(term-color-magenta ((t (:foreground "#ff79c6" :background "#ff79c6"))))
 '(term-color-red ((t (:foreground "#ff5555" :background "#ff5555"))))
 '(term-color-white ((t (:foreground "#f8f8f2" :background "#656555"))))
 '(term-color-yellow ((t (:foreground "#f1fa8c" :background "#f1fa8c"))))
 '(term-default-bg-color ((t (:inherit term-color-black))))
 '(term-default-fg-color ((t (:inherit term-color-white))))
 '(tty-menu-enabled-face ((t (:inherit hl-line))))
 '(tty-menu-selected-face ((t (:inherit eglot-highlight-symbol-face))))
 '(whitespace-trailing ((t (:background "black" :foreground "yellow" :weight bold))))
 '(widget-field ((t (:extend t :background "gray" :foreground "black"))))
 '(window-divider ((t (:foreground "green"))))
 '(xref-match ((t (:inherit region))))
 '(yas-field-highlight-face ((t (:foreground "#000000" :background "#7fdc59" :weight normal)))))



;; (set-face-attribute 'region nil :inverse-video 't)


;; Display dividers between windows
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(add-hook 'window-setup-hook #'window-divider-mode)

(set-face-background 'vertical-border (face-background 'default))
(set-face-foreground 'vertical-border "#00ff00")


;; fix terminal vertical-border char gap
(defun my-change-window-divider ()
  (let ((display-table (or buffer-display-table standard-display-table)))
    (set-display-table-slot display-table 5 ?│)
    (set-window-display-table (selected-window) display-table)))

(add-hook 'window-configuration-change-hook 'my-change-window-divider)


;; (global-font-lock-mode -1)


;; Set symbol for the border
(set-display-table-slot standard-display-table
                        'vertical-border
                        (make-glyph-code ?│))








(defun find-overlays-specifying (prop pos)
  (let ((overlays (overlays-at pos))
        found)
    (while overlays
      (let ((overlay (car overlays)))
        (if (overlay-get overlay prop)
            (setq found (cons overlay found))))
      (setq overlays (cdr overlays)))
    found))

(defun highlight-current-line ()
  (interactive)
  (let ((overlay-highlight (make-overlay
                              (line-beginning-position)
                              (+ 1 (line-end-position)))))
        (overlay-put overlay-highlight 'face '(:inverse-video t))
        ;; (overlay-put overlay-highlight 'face '(:inherit hl-line))
        ;; (overlay-put overlay-highlight 'face '(:background "#1b5aa1"))
        (overlay-put overlay-highlight 'line-highlight-overlay-marker t))
  )

(defun dehighlight-current-line ()
  (interactive)
  (remove-overlays (line-beginning-position) (+ 1 (line-end-position)) 'line-highlight-overlay-marker t)
  )

(defun highlight-or-dehighlight-line ()
  (interactive)
  (if (find-overlays-specifying
       'line-highlight-overlay-marker
       (line-beginning-position))
      (dehighlight-current-line)
    (highlight-current-line)))

(defun remove-all-highlight ()
  (interactive)
  ;; (remove-overlays (point-min) (point-max) 'line-highlight-overlay-marker t)
  ;; this truly removes all, not restricted by the name
  (remove-overlays (point-min) (point-max))
  )

(global-set-key [f8] 'highlight-or-dehighlight-line)
(global-set-key [f9] 'remove-all-highlight)


;; (setq unhighlight-timer nil)
;; (defun my-highlight-line-momentarily (&optional ARG PRED)
;;   (interactive)
;;   ;; (recenter)
;;   (xref-pulse-momentarily)
;;   ;; (remove-all-highlight)
;;   ;; (my-disable-eglot-highlight)
;;   ;; (highlight-current-line)
;;   ;; (when (bound-and-true-p unhighlight-timer)
;;   ;;     (cancel-timer unhighlight-timer))
;;   ;; (setq unhighlight-timer (run-with-timer 0.3 nil #'(lambda() (remove-all-highlight) (my-enable-eglot-highlight))))
;; )



(defun my-remove-all-highlight()
  (interactive)
  (remove-all-highlight)
  (my-disable-paren-highlight)
  (my-disable-eglot-highlight)
  )

(defun my-enable-all-highlight()
  (interactive)
  (my-enable-paren-highlight)
  (my-enable-eglot-highlight)
  )




;; (defun my-recenter (&optional ARG PRED)
;;   (recenter)
;;   (xref-pulse-momentarily)
;; )

;; (advice-add 'xref-go-back                   :after 'my-highlight-line-momentarily)
;; (advice-add 'xref-pop-marker-stack          :after 'my-highlight-line-momentarily)
;; (advice-add 'lsp-ui-peek-find-definitions   :after 'my-highlight-line-momentarily)
;; (advice-add 'pop-global-mark                :after 'my-highlight-line-momentarily)




;; (advice-add 'xref-go-back                   :after 'my-enable-all-highlight)
;; (advice-add 'xref-find-definitions          :after #'(lambda(args) (my-enable-all-highlight)))
;; (advice-add 'xref-pop-marker-stack          :after 'my-enable-all-highlight)
;; (advice-add 'lsp-ui-peek-find-definitions   :after 'my-enable-all-highlight)
;; (advice-add 'pop-global-mark                :after 'my-enable-all-highlight)
;;
;;
;; (advice-add 'xref-go-back                   :before 'my-remove-all-highlight)
;; (advice-add 'xref-find-definitions          :before #'(lambda(args) (my-remove-all-highlight)))
;; (advice-add 'xref-pop-marker-stack          :before 'my-remove-all-highlight)
;; (advice-add 'lsp-ui-peek-find-definitions   :before 'my-remove-all-highlight)
;; (advice-add 'pop-global-mark                :before 'my-remove-all-highlight)






;; (setq xref-after-jump-hook           'my-highlight-line-momentarily)
;; (setq xref-after-jump-hook           'xref-pulse-momentarily)

;; (advice-add 'keyboard-quit                 :after 'remove-all-highlight)


;; quit xref buffer after enter
(with-eval-after-load 'xref
  (define-key xref--xref-buffer-mode-map(kbd "o") #'(lambda() (interactive) (xref-goto-xref t)))
  ;; directly open it when there is only one candidate.
  ;; (setq xref-show-xrefs-function #'xref-show-definitions-buffer)
  (setq xref-show-xrefs-function #'xref-show-definitions-buffer-at-bottom)
  (add-to-list 'xref-after-return-hook 'recenter)
)

(with-eval-after-load 'pulse
;;   ;; (set-face-attribute 'pulse-highlight-face nil :foreground 'unspecified :background "#1f4670")
;;   ;; (set-face-attribute 'pulse-highlight-face nil :foreground 'unspecified :background 'unspecified :inverse-video t)
;;   ;; (set-face-attribute 'pulse-highlight-start-face nil :foreground "green" :background "black")
    (setq pulse-delay 0.01) ;; pulse fast!
)

(define-key global-map (kbd "<s-mouse-1>")
            #'(lambda ()
                (interactive)
                (mouse-set-point last-input-event)
                (xref-find-definitions-at-mouse last-input-event)))

(define-key global-map (kbd "<s-mouse-3>")
            #'(lambda ()
                (interactive)
                (xref-go-back)
                ))

(define-key global-map (kbd "<C-mouse-3>")
            #'(lambda ()
                (interactive)
                (mouse-set-point last-input-event)
                (xref-find-references-at-mouse last-input-event)
                ))
(global-unset-key [C-down-mouse-3])




;;; swipe to go backward and forward
;;;
(defun my-start-cold-down-wheel()
  (my-unbind-swipe-actions)
  (run-with-timer 1 nil #'(lambda()
                              (my-bind-swipe-actions))))

(defun my-swipe-backward-with-cold-down ()
  (interactive)
    (xref-go-back)
    (recenter)
    (my-start-cold-down-wheel))

(defun my-swipe-forward-with-cold-down ()
  (interactive)
    (xref-go-forward)
    (recenter)
    (my-start-cold-down-wheel))

(defun my-unbind-swipe-actions ()
  (global-unset-key [wheel-left])
  (global-unset-key [wheel-right])
  )

(defun my-bind-swipe-actions ()
  (define-key global-map (kbd "<wheel-left>") 'my-swipe-backward-with-cold-down)
  (define-key global-map (kbd "<wheel-right>") 'my-swipe-forward-with-cold-down)
  )

(when (my-system-type-is-darwin)
  (my-bind-swipe-actions)
)


;;; right click to open context-menu. disable mouse-3 to disable region behavior, which is annoying!
;;;
(global-unset-key [mouse-3])
(add-hook 'prog-mode-hook 'context-menu-mode)



;; enable mouse click in terminal
(unless (display-graphic-p)
    (xterm-mouse-mode 1)
  )



(setq display-buffer-alist
      `(("*eldoc*"
         (display-buffer-in-side-window)
         (side . bottom)
         (window-height . 0.16)
         (slot . 0))))


(setq eldoc-idle-delay 0.2)
(setq eldoc-box-clear-with-C-g t)
(require 'eldoc-box)

(require 'custom-util-funcs)

(require 'init-eglot)
(add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))

;; (require 'init-lang-java)
;; (require 'download-lombok)

(require 'init-lang-go)
(add-hook 'go-mode-hook #'my-go-mode-hook)
(add-hook 'go-ts-mode-hook #'my-go-mode-hook)

(add-hook 'go-ts-mode-hook #'(lambda () (setq go-ts-mode-indent-offset 4)))


(require 'init-lang-cpp)
(add-hook 'c++-ts-mode-hook #'my-c-ts-mode-hook)
(add-hook 'c-ts-mode-hook #'my-c-ts-mode-hook)


(require 'init-lang-zig)

(require 'init-lang-swift)


(use-package swift-mode
  :defer t
  )


;; book-mode break isearch echo area!
;; (require 'book-mode)



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
(add-hook 'before-save-hook 'company-cancel)

;; company-posframe-mode
(require 'company-posframe)
(company-posframe-mode 1)

;; http://company-mode.github.io/manual/Getting-Started.html#Initial-Setup
(with-eval-after-load 'company
  (define-key company-active-map (kbd "<tab>") #'company-select-next-if-tooltip-visible-or-complete-selection)
  (define-key company-active-map (kbd "<backtab>") #'company-select-previous-or-abort)
  (define-key company-active-map (kbd "RET") #'company-complete-selection)
  )
;; Use (kbd "TAB") (or use (kbd "<tab>"), if you want to distinguish C-i from the <tab> key)





(use-package transpose-frame
  :defer t)


(use-package yasnippet
  :config
    (add-hook 'prog-mode-hook 'yas-minor-mode)
    (add-hook 'yas-before-expand-snippet-hook 'my-disable-eglot-highlight)
    (add-hook 'yas-after-exit-snippet-hook    'my-enable-eglot-highlight)
  )


;; all themes safe
(setq custom-safe-themes t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#14141e" "#e84c58" "#35BF88" "#dbac66" "#4ca6e8" "#c79af4" "#6bd9db" "#e6e6e8"])
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/.local/autosaves/\\1" t)))
 '(auto-save-list-file-prefix (expand-file-name "~/.emacs.d/.local/auto-save-list/"))
 '(backup-directory-alist '((".*" . "~/.emacs.d/.local/backups/")))
 '(connection-local-criteria-alist
   '(((:application tramp :machine "MBP-14.local")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp :machine "MacBook-Pro-2.local")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp :protocol "flatpak")
      tramp-container-connection-local-default-flatpak-profile)
     ((:application tramp :machine "localhost")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp :machine "MacBook-Pro.local")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)
     ((:application eshell)
      eshell-connection-default-profile)))
 '(connection-local-profile-alist
   '((tramp-container-connection-local-default-flatpak-profile
      (tramp-remote-path "/app/bin" tramp-default-remote-path "/bin" "/usr/bin" "/sbin" "/usr/sbin" "/usr/local/bin" "/usr/local/sbin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/opt/bin" "/opt/sbin" "/opt/local/bin"))
     (tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))
     (eshell-connection-default-profile
      (eshell-path-env-list))))
 '(create-lockfiles nil)
 '(helm-minibuffer-history-key "M-p")
 '(inhibit-startup-screen t)
 '(leetcode-prefer-language "cpp")
 '(leetcode-save-solutions t)
 '(package-selected-packages
   '(jsonrpc imenu-list treesit-auto highlight-numbers modus-themes nano-theme vs-dark-theme treemacs-all-the-icons centaur-tabs bazel general swift-mode color-theme-sanityinc-tomorrow lispy markdown-mode vscode-dark-plus-theme diminish eglot elisp-def elisp-refs slime elisp-slime-nav leetcode srefactor ivy-posframe counsel ivy popup-switcher popwin beacon rjsx-mode typescript-mode impatient-mode reformatter auto-dim-other-buffers atom-one-dark-theme jdecomp smart-jump ansible moe-theme selected benchmark-init with-proxy valign markdown-toc markdownfmt disable-mouse rainbow-delimiters key-chord google-c-style phi-search switch-buffer-functions yasnippet highlight-parentheses undo-tree nimbus-theme challenger-deep-theme afternoon-theme smooth-scrolling project There are no known projectsile-mode smart-mode-line cyberpunk-theme lsp-python-ms protobuf-mode vue-mode xclip mwim ripgrep neotree easy-kill helm-rg))
 '(pos-tip-background-color "#1d1d2b")
 '(pos-tip-foreground-color "#d4d4d6")
 '(projectile-globally-ignored-directories
   '("/opt/homebrew" "^\\.idea$" "^\\.vscode$" "^\\.ensime_cache$" "^\\.eunit$" "^\\.git$" "^\\.hg$" "^\\.fslckout$" "^_FOSSIL_$" "^\\.bzr$" "^_darcs$" "^\\.pijul$" "^\\.tox$" "^\\.svn$" "^\\.stack-work$" "^\\.ccls-cache$" "^\\.cache$" "^\\.clangd$" ".cache" "build"))
 '(recentf-save-file (expand-file-name "~/.emacs.d/.local/recentf"))
 '(warning-suppress-log-types '((emacs) (use-package) (lsp-mode)))
 '(warning-suppress-types '((use-package) (lsp-mode))))




;; lsp-mode session file
(setq lsp-session-file (expand-file-name "~/.emacs.d/.local/.lsp-session-v1"))




(global-whitespace-mode 1)
(setq whitespace-style '(face trailing tabs tab-mark))
(setq whitespace-line-column 85)
(setq whitespace-display-mappings
      '(
        (tab-mark   ?\t   [?\x25B8 ?\t] [?\\ ?\t])	; tab
        ))
(setq-default tab-width 4)


(add-hook 'before-save-hook #'delete-trailing-whitespace)



(set-face-attribute 'whitespace-tab nil
                      :background (face-background 'default)
                      :foreground "#627D9D"
                      )



(use-package
  iedit
  :defer t
  :bind (("C-M-'" . iedit-mode)))




;; render like github
(defun markdown-html-github (buffer)
  (princ (with-current-buffer buffer
                              (format "<!DOCTYPE html><html><script src=\"https://cdnjs.cloudflare.com/ajax/libs/he/1.1.1/he.js\"></script><link rel=\"stylesheet\" href=\"https://assets-cdn.github.com/assets/github-e6bb18b320358b77abe040d2eb46b547.css\"><link rel=\"stylesheet\" href=\"https://assets-cdn.github.com/assets/frameworks-95aff0b550d3fe338b645a4deebdcb1b.css\"><title>Impatient Markdown</title><div id=\"markdown-content\" style=\"display:none\">%s</div><div class=\"markdown-body\" style=\"max-width:968px;margin:0 auto;\"></div><script>fetch('https://api.github.com/markdown', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ \"text\": document.getElementById('markdown-content').innerHTML, \"mode\": \"gfm\", \"context\": \"knit-pk/homepage-nuxtjs\"}) }).then(response => response.text()).then(response => {document.querySelector('.markdown-body').innerHTML = he.decode(response)}).then(() => { fetch(\"https://gist.githubusercontent.com/FieryCod/b6938b29531b6ec72de25c76fa978b2c/raw/\").then(response => response.text()).then(eval)});</script></html>"
                                      (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
                              (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

(use-package
  impatient-mode
  :config (add-hook
           'markdown-mode-hook
           #'(lambda ()
               (impatient-mode 1)
               (imp-set-user-filter
                'markdown-html-github))))




(use-package
  ace-window
  :ensure t
  ;; must ensure, treemacs depend on it
  :delight :config (ace-window-display-mode 1)
  (setq aw-keys
        '(?h ?j ?k ?l ?a ?s ?d ?f ?g))
  :bind (("M-`" . #'ace-window)))

;; alternatively, use Meta-<left> Meta-<right> to move cursor to window
;; for iTerms2 user, disable alt-> alt-< to send alt-f alt-b in `profile->keys`
 (windmove-default-keybindings 'meta)







(defun my-centaur-select-tab (n)
  (interactive)
  (let* (
         (tabs-view (centaur-tabs-view (centaur-tabs-current-tabset t)))
         (tabs-count (length tabs-view))
         (n (if (> tabs-count n) n tabs-count))
         (n (- n 1))
         (tab (nth n tabs-view))
        )
    (centaur-tabs-buffer-select-tab tab)
    ;; (message "n %d, tabs-view:%s, tab: %s" n tabs-view tab)
    ))

(defmacro def-centaur-select-tab-funs (numbers)
  `(progn
     ,@(cl-loop for number in numbers
        collect
        `(defun ,(read (format "my-centaur-select-tab-%s" number))
              ()
            (interactive)
            (my-centaur-select-tab ,number))
        )))

(def-centaur-select-tab-funs (1 2 3 4 5 6 7 8 9))


;; have to set here!
(setq centaur-tabs-bar-height 28)
(setq centaur-tabs-height 28)

(use-package centaur-tabs
  :demand
  :init
  (setq centaur-tabs-enable-key-bindings t)
  :config
  (setq
        ;; centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-set-icons nil
        ;; centaur-tabs-icon-scale-factor 0.8
        centaur-tabs-set-modified-marker nil
        centaur-tabs-set-close-button nil
        centaur-tabs-left-edge-margin nil
        centaur-tabs-right-edge-margin nil
        centaur-tabs-set-bar 'under
        x-underline-at-descent-line t
        centaur-tabs-show-jump-identifier nil
        )
  (centaur-tabs-headline-match)
  (centaur-tabs-mode t)
  (push "*scratch" centaur-tabs-excluded-prefixes)
  (push "*grep" centaur-tabs-excluded-prefixes)
  (push "*deadgrep" centaur-tabs-excluded-prefixes)
  (push "*Messages" centaur-tabs-excluded-prefixes)
  (push "*Warnings" centaur-tabs-excluded-prefixes)
  (push "*Backtrace" centaur-tabs-excluded-prefixes)
  (push "*Gofmt" centaur-tabs-excluded-prefixes)
  (push "*Semantic" centaur-tabs-excluded-prefixes)
  (push "*Flymake" centaur-tabs-excluded-prefixes)
  (push "*Customize" centaur-tabs-excluded-prefixes)
  (push "*xref" centaur-tabs-excluded-prefixes)
  (push "*Async-native-compile-log" centaur-tabs-excluded-prefixes)
  (push "*EGLOT" centaur-tabs-excluded-prefixes)
  (push "*Ilist*" centaur-tabs-excluded-prefixes)
  (push "*Occur*" centaur-tabs-excluded-prefixes)
  ;; (centaur-tabs-buffer-groups-function #'centaur-tabs-projectile-buffer-groups)
  (defun centaur-tabs-buffer-groups ()
    ;; only one group
    (list "GROUP"))
  :bind
  ("s-h" . centaur-tabs-backward)
  ("s-l" . centaur-tabs-forward)
  ("s-t" . centaur-tabs--create-new-tab)
  ("s-w" . centaur-tabs--kill-this-buffer-dont-ask)
  ("s-1" . my-centaur-select-tab-1)
  ("s-2" . my-centaur-select-tab-2)
  ("s-3" . my-centaur-select-tab-3)
  ("s-4" . my-centaur-select-tab-4)
  ("s-5" . my-centaur-select-tab-5)
  ("s-6" . my-centaur-select-tab-6)
  ("s-7" . my-centaur-select-tab-7)
  ("s-8" . my-centaur-select-tab-8)
  ("s-9" . my-centaur-select-tab-9)
)

(with-eval-after-load 'centaur-tabs
    (dolist (face '(centaur-tabs-default
                  centaur-tabs-unselected
                  centaur-tabs-selected
                  centaur-tabs-unselected-modified
                  centaur-tabs-selected-modified
                  centaur-tabs-close-unselected
                  centaur-tabs-close-selected
                  centaur-tabs-name-mouse-face
                  centaur-tabs-close-mouse-face
                  centaur-tabs-modified-marker-selected
                  centaur-tabs-modified-marker-unselected
                  centaur-tabs-active-bar-face
                  centaur-tabs-jump-identifier-selected
                  centaur-tabs-jump-identifier-unselected
                  centaur-tabs-dim-buffer-face))
        (set-face-attribute face nil :weight 'normal :family "IBM Plex Sans" :height 150)
    )

    ;; ;; modified tab foreground
    ;; (set-face-foreground 'centaur-tabs-selected-modified "#61AFEF")
    ;; (set-face-foreground 'centaur-tabs-unselected-modified "#61AFEF")

    ;; (set-face-background 'centaur-tabs-selected-modified "#161C23")
    ;; (set-face-background 'centaur-tabs-selected          "#161C23")

    ;; (set-face-attribute 'centaur-tabs-selected nil
    ;;                     :background "#161C23"
    ;;                     :foreground "#ABB2BF"
    ;;                     :overline nil
    ;;                     :underline "#528BFF"
    ;;                     :weight light)

    ;; modified tab underline
    (set-face-underline 'centaur-tabs-selected-modified "cyan" )
    (set-face-underline 'centaur-tabs-modified-marker-selected "cyan" )
    (unless (display-graphic-p)
      ;; no underline for selected tab, in terminal mode.
      (set-face-underline 'centaur-tabs-selected-modified nil )
      (set-face-underline 'centaur-tabs-selected nil )
      )

    (unless (display-graphic-p)
      (setq centaur-tabs-set-icons nil)
      (setq centaur-tabs-modified-marker "")
      (setq centaur-tabs-close-button "")
    )
)


(use-package
  py-autopep8
  :defer t
  :init)
(add-hook 'python-mode-hook 'py-autopep8-mode)




(use-package
  rust-mode
  :defer t
  :init)

(use-package
  scala-mode
  :defer t
  :interpreter ("scala" . scala-mode))

(use-package yaml-mode
  :ensure t
  :init
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yml\\.j2\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\.j2\\'" . yaml-mode)))


(use-package ansible :defer t)


;; line number fixed width
(setq display-line-numbers-width-start 100)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'markdown-mode-hook 'display-line-numbers-mode)
(add-hook 'nxml-mode-hook 'display-line-numbers-mode)
(add-hook 'yaml-mode-hook 'display-line-numbers-mode)
(add-hook 'yaml-mode-hook #'(lambda () (ansible 1)))
(add-hook 'conf-mode-hook 'display-line-numbers-mode)



(add-hook 'prog-mode-hook 'highlight-numbers-mode)



;; delete all other buffers, only keep current one.
(defun my-only-current-buffer ()
    "Kill all non-star other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer) (remove-if-not 'buffer-file-name (buffer-list))))      ;; this keep * buffers alive
    (centaur-tabs-display-update))

;; delete all other buffers, only keep current one.
(defun my-only-current-buffer-include-specials ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer) (buffer-list))))                                       ;; this destroy * buffers too






(defun my-cmake-mode-hook ()
  (setq cmake-tab-width 4))

(add-hook 'cmake-mode-hook 'my-cmake-mode-hook)


(defun my-elisp-mode-hook ()
  (setq indent-tabs-mode nil))

(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-hook)



(require 'smartparens-config)
(require 'sp-sublimetext-like)
(smartparens-global-mode 1)
(smartparens-mode 1)


(defun indent-between-pair (&rest _ignored)
  (newline)
  (indent-according-to-mode)
  (forward-line -1)
  (indent-according-to-mode))

(with-eval-after-load 'smartparens
  (sp-local-pair 'prog-mode "{" nil :post-handlers '((indent-between-pair "RET")))
  (sp-local-pair 'prog-mode "[" nil :post-handlers '((indent-between-pair "RET")))
  (sp-local-pair 'prog-mode "(" nil :post-handlers '((indent-between-pair "RET")))
  (setq sp-highlight-pair-overlay nil)
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





;; has to use require. it come from ./lisp/emacs-surround.el !!
(require 'emacs-surround)
(add-to-list 'emacs-surround-alist '("}" . ("{ " . " }")))
(add-to-list 'emacs-surround-alist '(")" . ("( " . " )")))
(add-to-list 'emacs-surround-alist '("]" . ("[ " . " ]")))
;; (global-set-key (kbd "C-c p") 'emacs-surround)







(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :bind
  (
    (:map ivy-minibuffer-map
        ;; ("C-'" . ivy-avy)
        ("TAB" . ivy-next-line)
        ("<backtab>" . ivy-previous-line)
    )
  )
  :config
  (ivy-mode 1)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq counsel-switch-buffer-preview-virtual-buffers nil)
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
        ;; allow input not in order
        '((t   . ivy--regex-ignore-order)))
  ;; donot show these buffers in counsel-switch-buffer
  (add-to-list 'ivy-ignore-buffers "\\*Messages\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Help\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Compile-Log\\*")
  (add-to-list 'ivy-ignore-buffers "\\*EGLOT")
  (add-to-list 'ivy-ignore-buffers "\\*rdm\\*" )
  (add-to-list 'ivy-ignore-buffers "\\*Backtrace\\*" )
  (add-to-list 'ivy-ignore-buffers "\\*Ibuffer\\*" )
  )



(require 'ivy-posframe)
(ivy-posframe-mode 1)

(setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
(defun ivy-format-function-default (cands)
  "Transform CANDS into a string for minibuffer."
  (concat "---------------------------------------------------\n"
          (ivy--format-function-generic
           (lambda (str)
             (concat " > " (ivy--add-face str 'ivy-current-match) ""))
           (lambda (str)
             (concat "   " str ""))
           cands
           "\n")
          "\n----------------------------------------------------\n\n"
          ))


(defun my-ivy-posframe-get-size ()
  "Set the ivy-posframe size according to the current frame."
  (let ((height (or ivy-posframe-height (or (+ ivy-height 2) 20)))
        (width  (or ivy-posframe-width (round (* .80 (frame-width))))))
    (list :height height :min-height height :min-width width)))
(setq ivy-posframe-size-function 'my-ivy-posframe-get-size)
(setq ivy-posframe-parameters '((:internal-border-width . 1) (:internal-border-color . "white")))




;; (use-package
;;   flymake-posframe
;;   :load-path "~/.emacs.d/lisp/flymake-posframe.el"
;;   :hook (flymake-mode . flymake-posframe-mode))

(setq flymake-start-syntax-check-on-find-file nil)

(use-package flymake-diagnostic-at-point
  :load-path "~/.emacs.d/lisp/flymake-diagnostic-at-point.el"
  :after flymake
  :config
  (setq flymake-diagnostic-at-point-error-prefix " > ")
  (setq flymake-diagnostic-at-point-display-diagnostic-function 'flymake-diagnostic-at-point-display-posframe)
  (unless (display-graphic-p)
    (setq flymake-diagnostic-at-point-display-diagnostic-function 'flymake-diagnostic-at-point-display-minibuffer))
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))


;;
;; deprecated, use flymake-posframe.
;;
;; (use-package flymake-diagnostic-at-point
;;   :after flymake
;;   :config
;;   (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))





(defun my-M-x()
  (interactive)
  (counsel-M-x))

(defun my-occur()
  (interactive)
  (counsel-grep))

(defun my-rg-at-point()
  (interactive)
  (counsel-rg))

(defun my-find-files()
  (interactive)
  (counsel-find-file))

(defun my-mark-ring()
  (interactive)
  (counsel-mark-ring))


(setq projectile-completion-system 'ivy)
(defun my-projectile-find-file ()
  (interactive)
  ;; (helm-projectile-find-file)
  (projectile-find-file))







(advice-add
  'my-M-x
  :before
  (lambda (&rest r) (my-god-mode))
  ; convenient name for identifying or removing this advice later
  '((name . "my-god-mode-before-m-x")))

(advice-add
  'my-mark-ring
  :after
  (lambda (&rest r) (recenter))
  ; convenient name for identifying or removing this advice later
  '((name . "recenter-after-mark-ring")))






(delete-selection-mode 1)

(add-hook 'org-mode-hook #'valign-mode)
(add-hook 'markdown-mode-hook #'valign-mode)

(column-number-mode 1)

;; (add-hook 'markdown-mode-hook #'prog-mode)






(pixel-scroll-precision-mode -1)

;; scroll with cursor not move
(defun gcm-scroll-down ()
  (interactive)
  (scroll-up 1))
(defun gcm-scroll-up ()
  (interactive)
  (scroll-down 1))



(setq scroll-margin 2
      scroll-conservatively 101
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      ;; scroll-preserve-screen-position 'always
      auto-window-vscroll nil)

(defun scroll-full-page-down ()
  "scroll down the page"
  (interactive)
  (scroll-down (* (/ (window-body-height) 5) 4)))

(defun scroll-full-page-up ()
  "scroll up the page"
  (interactive)
  (scroll-up (* (/ (window-body-height) 5) 4)))

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




(defun my-escape-key ()
  (interactive)
  (my-god-mode)
  (when isearch-mode (isearch-abort) (isearch-abort))
  (when (my-god-this-is-normal-editor-buffer (buffer-name))
    (when (bound-and-true-p multiple-cursors-mode) (multiple-cursors-mode -1))
    (when (bound-and-true-p iedit-mode) (iedit-done))  ;; exit iedit mode, if needed.
    ;; (delete-trailing-whitespace)
    (ignore-errors (company-cancel))
    (ignore-errors (remove-all-highlight)))
  ;; (ignore-errors (flymake-mode-on)) ;; but show errors
  (keyboard-quit)
  (keyboard-quit-context+) ;; from custom-util-funcs.el
  )

(global-set-key [remap keyboard-quit] #'my-escape-key)

(global-set-key (kbd "<escape>") #'my-escape-key)
;; (define-key helm-map (kbd "<escape>") #'helm-keyboard-quit)
(define-key minibuffer-local-map (kbd "<escape>") #'minibuffer-keyboard-quit)
(define-key ivy-minibuffer-map (kbd "<escape>") #'keyboard-escape-quit)







;; must be set as global
(global-set-key (kbd "C-S-k") #'my-delete-to-beginning)
(global-set-key (kbd "C-k") #'my-delete-to-end)

(global-set-key (kbd "<RET>") #'newline-and-indent)







(tool-bar-mode -1)
(menu-bar-mode -1)
(smerge-mode -1)
;; (scroll-bar-mode -1)
(tab-bar-mode -1)



(setq default-frame-alist '(
  ;; (undecorated . t)  ;;;;会导致所有边框全部消失无法拖动调整窗口大小 需要加上后面两句
  ;; (drag-internal-border . 1)
  ;; (internal-border-width . 5)
  (vertical-scroll-bars);隐藏滚动条
  (left-fringe);显示左fringe
  (right-fringe . 0);关闭右fringe
))



; (smerge-mode -1)
; (menu-bar-mode -1)
; (tool-bar-mode -1)

(when (display-graphic-p)
  ;;; ;; awesome-tray is from emacswiki sub-directory
  ;;; (setq awesome-tray-mode-line-active-color '"#00ff00")

  ;;; (require 'awesome-tray)
  ;;; (awesome-tray-mode 1)

  (when (my-system-type-is-darwin)
    (menu-bar-mode 1))

  (scroll-bar-mode -1)
  (fringe-mode -1)
  ;; (tab-bar-mode -1)
  ;; (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))  ;; dark themes use "dark"

  (global-set-key [escape] 'my-escape-key)
  (define-key input-decode-map [?\C-\[] (kbd "<C-[>"))
  (global-set-key (kbd "<C-[>") 'my-escape-key)

  ;; show relative filepath
  ;; (setq frame-title-format
  ;;       '(:eval (format-mode-line
  ;;                 (propertized-buffer-identification
  ;;                   (or
  ;;                     (when-let* ((buffer-file-truename buffer-file-truename)
  ;;                                 (prj (cdr-safe (project-current)))
  ;;                                 (prj-parent (file-name-directory (directory-file-name (expand-file-name prj)))))
  ;;                                (concat
  ;;                                  (file-relative-name
  ;;                                    (file-name-directory buffer-file-truename) prj-parent)
  ;;                                  (file-name-nondirectory buffer-file-truename))
  ;;                                )
  ;;                     "%b"))))
  ;;       )


  ;; show absolute filepath
  (setq frame-title-format
        `((buffer-file-name "%f" "%b")))

  )

(unless (display-graphic-p)
  ;; (setq doom-modeline-height 1)
  ;; (setq doom-modeline-icon nil)
  ;; (setq doom-modeline-bar-width -1)
  (setq doom-modeline-buffer-file-name-style
        'relative-from-project)
  (require 'doom-modeline)
  (doom-modeline-mode 1))





(setq smex-save-file (expand-file-name "~/.emacs.d/.local/smex-items.cache"))




(defun my/return-t (orig-fun &rest args)
  t)
(defun my/disable-yornp (orig-fun &rest args)
  (advice-add 'yes-or-no-p :around #'my/return-t)
  (advice-add 'y-or-n-p :around #'my/return-t)
  (let ((res (apply orig-fun args)))
    (advice-remove 'yes-or-no-p #'my/return-t)
    (advice-remove 'y-or-n-p #'my/return-t)
    res))

(advice-add 'projectile-compile-project :around #'my/disable-yornp)
(advice-add 'projectile-run-project :around #'my/disable-yornp)










(defun flip-buffer-to-window ()
  "Flips to the last-visited buffer in this window."
  (interactive)
  (switch-to-buffer
   (other-buffer (current-buffer))))



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
        (untabify
         (match-beginning 0)
         (match-end 0)))
      (when (looking-at "^    ")
        (replace-match "")))))




(defun my-hs-toggle-all ()
  "If anything isn't hidden, run `hs-hide-all', else run `hs-show-all'."
  (interactive)
  (hs-minor-mode 1)
  (let (
        (starting-ov-count (length (overlays-in (point-min) (point-max))))
        )
    (if (derived-mode-p 'c++-mode)
      ; find namespace, go below one line, and then hide
      (save-excursion
        (goto-char (point-min))
        (re-search-forward "namespace.*?{" nil t)
        (next-line)
        (hs-hide-level 1))
      (hs-hide-all))
    (when (equal (length (overlays-in (point-min) (point-max))) starting-ov-count)
      (hs-show-all)
      (recenter))))

(defun my-hs-toggle-hiding ()
  (interactive)
  (hs-minor-mode 1)
  (if (hs-already-hidden-p)
    (hs-show-block)
    (hs-hide-block)))

(defun my-hide-all()
  (interactive)
  (hs-minor-mode 1)
  (hs-hide-all))

;; (add-hook 'prog-mode-hook 'my-hide-all)



(defun my-show-file-name ()
  (interactive)
  (message (buffer-file-name)))


(defun my-copied-content-is-end-of-newline ()
  (interactive)
  (string-suffix-p
   "\n"
   (current-kill 0 'DONT-MOVE)))



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

(defun my-yank-but-check-newline-bellow (arg)
  (interactive "p")
  (if (use-region-p)
      (let ((beg (region-beginning))
            (end (copy-marker (region-end))))
        (delete-region beg end)
        (yank))
    (if (my-copied-content-is-end-of-newline)
        (progn
         (end-of-line)
         (newline)
         (beginning-of-line)
         (yank arg)
         (backward-delete-char 1))
      (yank arg))))

(defun my-yank-but-check-newline-above (arg)
  (interactive "p")
  (if (use-region-p)
      (let ((beg (region-beginning))
            (end (copy-marker (region-end))))
        (delete-region beg end)
        (yank))
    (if (my-copied-content-is-end-of-newline)
        (progn
         (beginning-of-line)
         (newline)
         (previous-line)
         (yank arg)
         (delete-char 1))
      (yank arg))))




(require 'avy)
(setq avy-keys (list ?a ?s ?d ?f ?g ?w ?e ?v ?m ?n ?i ?o ?h ?j ?k ?l ?\;))
(setq avy-background 't)
(add-to-list 'avy-ignored-modes 'treemacs-mode)


(advice-add 'avy-goto-word-0
 :before
 (lambda (&rest r) (my-disable-code-intelligence))
 '((name . "avy-start"))
)

;; avy aborted
(advice-add 'avy-handler-default
 :before
 (lambda (&rest r) (my-enable-code-intelligence))
 '((name . "avy-aborted-end"))
)
;; avy success
(advice-add 'avy-action-goto
 :before
 (lambda (&rest r) (my-enable-code-intelligence))
 '((name . "avy-success-end"))
)


(set-face-attribute 'avy-lead-face nil
                      :background (face-background 'default)
                      :foreground "#E20000"
                      )

(set-face-attribute 'avy-lead-face-0 nil
                      :background (face-background 'default)
                      :foreground "#FFB400"
                      )







(setq recenter-redisplay nil)




(which-key-mode 1)


(xclip-mode 1)


(require 'mwim)
(global-set-key [remap move-end-of-line] #'mwim-end-of-code-or-line)
(global-set-key [remap move-beginning-of-line] #'mwim-beginning-of-code-or-line)

(require 'yank-indent)
(global-yank-indent-mode t)



;; semantic-refactor, use in c++ mode
(require 'srefactor)
(semantic-mode 1) ;; -> this is optional for Lisp

(define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)



(defun buffer-mode (&optional buffer-or-name)
  "Returns the major mode associated with a buffer.
If buffer-or-name is nil return current buffer's mode."
  (with-current-buffer
      (if buffer-or-name
          (get-buffer buffer-or-name)
        (current-buffer))
    major-mode))




;; special-buffers are not affected by god-mode bindings, but affected by my-special-buffer-keys-minor-mode-map
(setq special-buffer-modes (list
                            "dired-mode"
                            ))
(setq special-buffers (list
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
                        "*Ivy"
                        "*Occur*"
                        "*info*"
                        "*Warnings*"
                        "helm-*"
                        ;; "*helm-mode-switch-to-buffer*"
                        "*Helm Help*"
                        "*Flymake diagnostics"
                        "*ansi-term*"
                        "*fzf*"
                        "*Ilist*"
                        "*NeoTree*"))

;; legendary-buffers are not affected by god-mode AND my-special-buffer-keys-minor-mode-map
(setq legendary-buffers (list
                          "*this-buffer-is-left-alone-without-god-mode-at-all"
                          "*Minibuf"
                          "*terminal*"
                          "*eshell*"
                          "magit"
                          "git-rebase-todo"
                          "*Backtrace*"
                          "menu"
                          "*ielm*"
                          "*slime-repl"
                          "*Customize"))

(setq legendary-modes (list "*this-buffer-is-left-alone-without-god-mode-at-all" "cfrs-input-mode" "minibuffer-mode"))


(defun my-god-this-is-special-buffer (bufname)
  (interactive)
  (let ((this-buffer-name (string-trim bufname))
        (this-buffer-mode (symbol-name
                           (buffer-mode bufname))))
    (or (seq-filter
         (lambda (n) (string-prefix-p n this-buffer-name)) special-buffers)
        (seq-filter
         (lambda (n) (string-prefix-p n this-buffer-mode)) special-buffer-modes))))

(defun* my-god-this-is-legendary-buffer (bufname)
  (interactive)
  ;; (message "buffer-mode type is %s" (type-of (buffer-mode bufname))) ==> symbol
;;;; use symbol-name convert symbol to string; And for the reverse, (intern "some-string") to get symbol
  (let ((this-buffer-name (string-trim bufname))
        (this-buffer-mode (symbol-name
                           (buffer-mode bufname))))
    ;; (message "this-buffer-name %s" this-buffer-name)
    ;; (message "this-buffer-mode %s" this-buffer-mode)
    (or (seq-filter
         (lambda (n) (string-prefix-p n this-buffer-name)) legendary-buffers)
        (seq-filter
         (lambda (n) (string-prefix-p n this-buffer-mode)) legendary-modes))))


(defun my-god-this-is-normal-editor-buffer (bufname)
  (interactive)
  (not (or (my-god-this-is-special-buffer bufname) (my-god-this-is-legendary-buffer bufname)))
)


(defun* my-god-mode ()
  (interactive)
  (my-ctrl-w-window-keys-minor-mode 1)

  (when (my-god-this-is-legendary-buffer (buffer-name))
    ;; (message "%s is legendary buffer" (buffer-name))
    (my-keys-minor-mode 0)
    (my-special-buffer-keys-minor-mode 0)
    (cl-return-from my-god-mode))

  (if (my-god-this-is-special-buffer (buffer-name))
    (progn
      ;; (message "%s is special buffer" (buffer-name))
      (ignore)
      (god-local-mode 0)                  ;; start local mode
      (my-keys-minor-mode 0)
      (my-special-buffer-keys-minor-mode 1)
      )
    (progn
      ;; (message "%s not a special buffer" (buffer-name))
      (god-local-mode 1)                  ;; start local mode
      (setq my-god-mode-is-active-flag t)
      (my-special-buffer-keys-minor-mode 0)
      ;; (visual-line-mode 1)
      ;; (global-visual-line-mode 1) ;;
      )
    nil)
  )

(add-hook 'find-file-hook 'my-god-mode)

(defun my-quit-god-mode()
  (interactive)
  (my-ctrl-w-window-keys-minor-mode 0)

  (god-local-mode -1)
  ;; my-god-mode is meant to have value, but it's not set, maybe god-mode bug?
  ;; anyway, we use our own flags here
  (setq my-god-mode-is-active-flag nil)
  )

(defun my-toggle-god-mode()
  (interactive)
  (if (bound-and-true-p god-local-mode)
    (my-quit-god-mode)
    (my-god-mode)))




(defun my-god-mode-with-switch-any-buffer(prev curr)
  (cl-assert (eq curr (current-buffer)))  ;; Always t
  ;; (message "%S -> %S -> %S" prev curr (string-trim (buffer-name curr)))
  (my-god-mode)
  )
(add-hook 'switch-buffer-functions #'my-god-mode-with-switch-any-buffer)




(defun my-god-below-newline-and-insert-mode ()
  (interactive)
  (end-of-line)
  (newline-and-indent)
  (my-quit-god-mode))

(defun my-god-above-newline-and-insert-mode ()
  (interactive)
  (beginning-of-line)
  (newline)
  (previous-line)
  (my-quit-god-mode))

(defun my-god-mwin-end-and-insert-mode ()
  (interactive)
  (mwim-end-of-code-or-line)
  (my-quit-god-mode))

(defun my-god-mwin-beginning-and-insert-mode ()
  (interactive)
  (mwim-beginning-of-code-or-line)
  (my-quit-god-mode))

(defun my-god-char-forward-and-insert-mode ()
  (interactive)
  (forward-char)
  (my-quit-god-mode))

(defun my-move-to-end-of-word ()
  "Move to the next 'last character' of a word."
  (interactive)
  (forward-char)
  (re-search-forward "\\w\\b" nil t)
  (goto-char (match-beginning 0)))

(defun my-delete-to-beginning (args)
  (interactive "p")
  (set-mark-command nil)
  (mwim-beginning-of-code-or-line)
  (delete-region
   (region-beginning)
   (region-end)))

(defun my-delete-to-end (args)
  (interactive "p")
  (set-mark-command nil)
  (mwim-end-of-line)
  (delete-region
   (region-beginning)
   (region-end)))

(defun increment-number-at-point ()
  (interactive)
  (skip-chars-backward "0-9")
  (or (looking-at "[0-9]+")
      (error "No number at point"))
  (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))

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
;; this variable make sure RET exit isearch-mode immediately

(define-key isearch-mode-map (kbd "RET") #'isearch-exit)
(define-key isearch-mode-map (kbd "C-l") #'recenter-top-bottom)

(define-key isearch-mode-map (kbd "C-s") 'isearch-repeat-forward+)
(define-key isearch-mode-map (kbd "C-r") 'isearch-repeat-backward+)
;; like vim
;; reset all other keys. then add our specific keys.
(set-char-table-range (nth 1 god-mode-isearch-map) t #'ignore)
(define-key god-mode-isearch-map (kbd "n") 'isearch-repeat-forward+)
(define-key god-mode-isearch-map (kbd "N") 'isearch-repeat-backward+)
(define-key god-mode-isearch-map (kbd "p") 'yank)
(define-key god-mode-isearch-map (kbd "u") 'undo)
(define-key god-mode-isearch-map (kbd "d") 'kill-whole-line)
(define-key god-mode-isearch-map (kbd "j") #'(lambda() (interactive)(isearch-exit)(next-line)))
(define-key god-mode-isearch-map (kbd "k") #'(lambda() (interactive)(isearch-exit)(previous-line)))
(define-key god-mode-isearch-map (kbd "h") #'(lambda() (interactive)(isearch-exit)(my-forward-char-no-cross-line)))
;; (define-key god-mode-isearch-map (kbd "l") #'(lambda() (interactive)(isearch-exit)(my-backward-char-no-cross-line)))
(define-key god-mode-isearch-map (kbd "l") 'recenter-top-bottom)
(define-key god-mode-isearch-map (kbd "C-l") 'recenter-top-bottom)
(define-key god-mode-isearch-map (kbd ";") 'scroll-up-command)
(define-key god-mode-isearch-map (kbd "'") 'scroll-down-command)
(define-key god-mode-isearch-map (kbd "s") 'isearch-repeat-forward+)
(define-key god-mode-isearch-map (kbd "r") 'isearch-repeat-backward+)
(define-key god-mode-isearch-map (kbd "RET") #'isearch-exit)





(defun my-search-selection ()
  "search for selected text"
  (interactive)
  (if (region-active-p)
      (let ((selection (buffer-substring-no-properties
                        (mark)
                        (point)))
            (case-fold-search 'default))
        (message
         "search the marked region")
        (deactivate-mark)
        (isearch-mode t nil nil nil)
        ;; activate god-mode-isearch
        (god-mode-isearch-activate)
        (isearch-yank-string selection))
    (progn
      (isearch-forward-symbol-at-point)
      (god-mode-isearch-activate))))


(defun my-isearch-forward ()
  (interactive)
  (isearch-mode t nil nil nil)
  (god-mode-isearch-activate)
  (isearch-repeat-forward+))


(defun my-isearch-backward ()
  (interactive)
  (isearch-mode nil nil nil nil)
  (god-mode-isearch-activate)
  (isearch-repeat-backward+))


(defvar my-code-intelligence 't "enable by default")



(defun my-disable-eglot-highlight()
  (interactive)
  (ignore-errors
    (setq eglot-ignored-server-capabilities (add-to-list 'eglot-ignored-server-capabilities ':documentHighlightProvider ))
    (set-face-attribute 'eglot-highlight-symbol-face nil :background 'unspecified :foreground 'unspecified)
    (set-face-attribute 'flymake-error nil :underline 'unspecified :foreground 'unspecified :background 'unspecified)
    ;; (flymake-mode-off)
    ))

(defun my-enable-eglot-highlight()
  (interactive)
  (ignore-errors
    (setq eglot-ignored-server-capabilities (delete ':documentHighlightProvider eglot-ignored-server-capabilities ))
    (set-face-attribute 'eglot-highlight-symbol-face nil :background "#59dcb7" :foreground "black" :weight 'normal)
    (set-face-attribute 'flymake-error nil :underline t :foreground "DeepPink" :background (face-background 'default))
    ;; (flymake-mode-on)
    ))



(defun my-enable-paren-highlight()
  (interactive)
  (ignore-errors
    (set-face-attribute 'show-paren-match nil :foreground "green" :weight 'bold)
    ))


(defun my-disable-paren-highlight()
  (interactive)
  (ignore-errors
    (set-face-attribute 'show-paren-match nil :foreground 'unspecified :weight 'bold)
    ))





(defun my-disable-code-intelligence ()
  (interactive)
  (when my-code-intelligence
    (my-disable-eglot-highlight)
    (smartparens-global-mode -1)
    (smartparens-mode -1)
    ;; (electric-indent-mode -1)
    ;; (global-undo-tree-mode -1)
    (undo-tree-mode -1)
    (setq my-code-intelligence nil)
    ;; (message "code-intelligence is disabled.")
    ))

(defun my-enable-code-intelligence ()
  (interactive)
  (unless my-code-intelligence
    (my-enable-eglot-highlight)
    (smartparens-global-mode 1)
    (smartparens-mode 1)
    ;; (electric-indent-mode 1)
    ;; (global-undo-tree-mode 1)
    (undo-tree-mode 1)
    (setq my-code-intelligence 't)
    ;; (message "code-intelligence is enabled.")
    ))

(add-hook 'isearch-mode-hook #'my-disable-code-intelligence)
(add-hook 'isearch-mode-end-hook #'my-enable-code-intelligence)




(use-package lispy
  :hook (emacs-lisp-mode . lispy-mode)
  :config
  (setcdr lispy-goto-mode-map nil)
  (setcdr lispy-other-mode-map nil)
  (setcdr lispy-mode-map nil)
  (setcdr lispy-mode-map-oleh nil)
  (setcdr lispy-mode-map-base nil)
  (setcdr lispy-mode-map-lispy nil)
  (setcdr lispy-mode-map-evilcp nil)
  (setcdr lispy-mode-map-special nil)
  (setcdr lispy-mode-map-paredit nil)
  (setcdr lispy-mode-map-parinfer nil)
  (setcdr lispy-mode-map-c-digits nil)
         (define-key lispy-mode-map (kbd "M") 'special-lispy-alt-multiline)
         (define-key lispy-mode-map (kbd "s-m") 'special-lispy-alt-multiline)
         (define-key lispy-mode-map (kbd "s-j") 'lispy-down)
         (define-key lispy-mode-map (kbd "s-k") 'lispy-up)
  )








(setq hl-line-inhibit-highlighting-for-modes '(dired-mode deadgrep-mode deadgrep-edit-mode treemacs-mode))
(global-hl-line-mode 1)


(set-face-background 'line-number (face-background 'default))
(set-face-background 'line-number-current-line (face-background 'hl-line))





(defun my-buffer-identification (fmt)
  (list (propertize
         fmt
         'face (if (let ((window (selected-window)))
                     (or (eq window (old-selected-window))
                         (and (minibuffer-window-active-p (minibuffer-window))
                              (with-selected-window (minibuffer-window)
                                (eq window (minibuffer-selected-window))))))
                   (if (bound-and-true-p god-local-mode)
                       'error
                       '(:foreground "#7fdc59")
                     )
                 'mode-line-buffer-id)
         'mouse-face 'mode-line-highlight
         'local-map mode-line-buffer-identification-keymap)))

;; (setq-default mode-line-buffer-identification
;;               '(:eval (my-buffer-identification "%12b")))


(defvar buffer-filename-with-git-directory nil
  "Parent directory of the current directory.
This variable is nil if the current buffer isn't visiting a file.")
(make-variable-buffer-local 'buffer-filename-with-git-directory)
(put 'buffer-filename-with-git-directory 'permanent-local t)
(defun set-buffer-filename-with-git-directory ()
  (when buffer-file-name
    (setq buffer-filename-with-git-directory
          (or
           (when-let* ((buffer-file-truename buffer-file-truename)
                                  (prj (cdr-safe (project-current)))
                                  (prj-parent (file-name-directory (directory-file-name (expand-file-name prj)))))
                                 (concat
                                   (file-relative-name
                                     (file-name-directory buffer-file-truename) prj-parent)
                                   (file-name-nondirectory buffer-file-truename))
                                 )
           buffer-file-name))))

(add-hook 'find-file-hook 'set-buffer-filename-with-git-directory)

(setq-default mode-line-buffer-identification
              `(:eval (my-buffer-identification (or buffer-filename-with-git-directory ""))))


(require 'term-cursor)
(global-term-cursor-mode 1)

(setq blink-cursor-blinks 0)
(setq blink-cursor-interval 0.3)

;; (setq window-devider-color "#57a331")
;; (setq window-divider-color "green")
(setq window-divider-color "#06C668")

(defun my-god-mode-update-cursor-type ()
  ;; (when (display-graphic-p)
    ;; (setq cursor-type (if (or (bound-and-true-p god-local-mode) buffer-read-only) 'box 'bar))
    ;; (set-cursor-color (if (or (bound-and-true-p god-local-mode) buffer-read-only) "red" "red"))
    ;; (blink-cursor-mode (if (or (bound-and-true-p god-local-mode) buffer-read-only) -1 -1))
    (setq cursor-type (if (bound-and-true-p god-local-mode) 'bar 'bar))
    (set-cursor-color (if (bound-and-true-p god-local-mode) "red" "red"))
    (blink-cursor-mode (if (bound-and-true-p god-local-mode) -1 1))
  ;; )
  ;; (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar))
  (if (bound-and-true-p god-local-mode)
    (progn
      ;; (set-face-attribute 'hl-line nil :foreground 'unspecified :background "#262626")
      ;; (set-face-attribute 'line-number-current-line nil :foreground "#5fffd7" :background "#3a3a3a")
      (when (display-graphic-p)
        (set-face-attribute 'window-divider nil     :foreground window-divider-color)
        ;; (set-face-attribute 'mode-line nil          :background "#7AA2F7" :foreground "#262831" :overline "#374250"   :box nil) ;; draw a line above mode-line
        ;; (set-face-attribute 'mode-line-inactive nil :background "#262831" :foreground "#7AA2F7" :overline "#374250"  :box nil)
        ;; (set-face-attribute 'mode-line-buffer-id nil :distant-foreground "#262831" :foreground "#7AA2F7")
        )
      ;; (unless (display-graphic-p)
      ;;   (set-face-attribute 'mode-line          nil :foreground "black" :background "#00AFFF")
      ;;   (set-face-attribute 'mode-line-inactive nil :foreground "#00AFFF" :background "black")
      ;;   )
      ;; (setq cursor-type 'bar)
      ;; (set-cursor-color "red")
      ;; (set-face-attribute 'mode-line nil :box '(:line-width 1 :color "gray" ))
      ;; (set-face-attribute 'mode-line nil :background "#38424B")
      (set-face-foreground 'vertical-border window-divider-color)
      ;; (set-face-foreground 'vertical-border "#374250")
      )
    (progn
      ;; (set-face-attribute 'hl-line nil :background (face-background 'default))
      ;; (set-face-attribute 'line-number-current-line nil :foreground "black" :background "#7fdc59")
      (when (display-graphic-p)
        (set-face-attribute 'window-divider nil     :foreground window-divider-color)
        ;; (set-face-attribute 'mode-line nil          :background "#7fdc59" :foreground "black" :overline "green"   :box nil) ;; draw a line above mode-line
        ;; (set-face-attribute 'mode-line-inactive nil :background "#262831" :foreground "#7AA2F7" :overline "#374250"  :box nil)
        ;; (set-face-attribute 'mode-line-buffer-id nil :distant-foreground "#7AA2F7" :foreground "black")
        )
      ;; (unless (display-graphic-p)
      ;;   (set-face-attribute 'mode-line          nil :foreground "black" :background "cyan")
      ;;   (set-face-attribute 'mode-line-inactive nil :foreground "#00AFFF" :background "black")
      ;;   )
      ;; (setq cursor-type 'bar)
      ;; (set-cursor-color "red")
      ;; (set-face-attribute 'mode-line nil :box '(:line-width 1 :color "green" ))
      ;;(set-face-attribute 'mode-line nil :background "#38424B")
      ;; (set-face-foreground 'vertical-border "#7fdc59")
      (set-face-foreground 'vertical-border window-divider-color)
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



(defun my-neotree-window-narrow ()
  (interactive)
  (setq neo-window-width 25)
  (neo-window--zoom 'minimize)  ;; private method here.
  ;; (neotree-hide)
  ;; (neotree-show)
  )

(defun my-neotree-window-enlarge ()
  (interactive)
  (setq neo-window-width
        (/ (frame-width) 4))
  (neo-window--zoom 'minimize)  ;; private method here.
  ;; (neotree-hide)
  ;; (neotree-show)
  )

(use-package
  neotree
  :ensure t
  :init (setq neo-theme 'arrow)
  ;; (setq neo-auto-indent-point 't)
  (setq neo-confirm-create-file 'off-p)
  (setq neo-confirm-create-directory 'off-p)
  (setq neo-smart-open 't)
  (setq neo-window-fixed-size nil)
  (setq neo-show-hidden-files t)
  ;; (add-hook 'neotree-mode-hook #'darker-background-for-sidebar)
  ;; (setq neo-window-width (/ (display-pixel-width) 4))
  ;; (setq neo-window-width 45)
  ;; (setq neo-toggle-window-keep-p 't)
  :bind (:map neotree-mode-map
              ("L" . 'my-neotree-window-enlarge)
              ("H" . 'my-neotree-window-narrow)
              ("u" . 'neotree-select-up-node)
              ("f" . 'neotree-hidden-file-toggle)
              ("c n" . 'neotree-create-node)
              ("a"   . 'neotree-create-node)
              ))


(defun neotree-project-dir ()
    "Open NeoTree using the git root."
    (interactive)
    (let ((project-dir (projectile-project-root))
          (file-name (buffer-file-name)))
      (neotree-toggle)
      (if project-dir
          (when (neo-global--window-exists-p)
                (neotree-dir project-dir)
                (neotree-find file-name))
        (message "Could not find git project root."))))

(defun my-neotree-toggle ()
  (interactive)
  (if (and (fboundp 'neo-global--window-exists-p)
           (neo-global--window-exists-p))
      (neotree-project-dir)
    (neotree-show)))

(defun my-neotree-find ()
  (interactive)
  (unless (fboundp 'neo-global--window-exists-p)
    (neotree-show))
  (unless (neo-global--window-exists-p)
    (neotree-show))
  (neotree-find))



(defun my-add-padding-for-neotree()
    (set-window-margins
      (get-buffer-window " *NeoTree*" 'visible) 1)
)
(advice-add 'neotree-show :after 'my-add-padding-for-neotree)



(setq-default left-margin-width 0 right-margin-width 0)



(defun my-add-padding-for-treemacs()
  (set-window-margins (treemacs-get-local-window) 1 1))

(defun my-add-hl-line-for-treemacs()
  (interactive)
  (setq-local face-remapping-alist '((hl-line (:inherit hl-line)))))

(defun my-decrease-treemacs-width()
  (interactive)
  ;; call inner api
  (treemacs--set-width 25)
  )

(defun my-increase-treemacs-width()
  (interactive)
  ;; call inner api
  (treemacs--set-width (/ (frame-width) 3))
  )



(defun display-treemacs-widow-in-ace-window-selection()
    (setq aw-ignored-buffers (delete 'treemacs-mode aw-ignored-buffers)))


(use-package treemacs
  :init
  :config
    (setq treemacs-hide-gitignored-files-mode 1)
    (setq treemacs-space-between-root-nodes nil)
    (setq treemacs-show-hidden-files t)
    (setq treemacs-show-cursor t)
    (setq treemacs-persist-file (expand-file-name "~/.emacs.d/.local/treemacs-persist"))
    (setq treemacs-last-error-persist-file (expand-file-name "~/.emacs.d/.local/treemacs-persist-at-last-error"))
    (setq treemacs-expand-after-init nil)
    (global-set-key (kbd "C-c C-p") treemacs-project-map)
    (global-set-key (kbd "C-c C-w") treemacs-workspace-map)
    ;; (treemacs-resize-icons 26)
    (add-hook 'treemacs-mode-hook #'my-add-padding-for-treemacs)
    (add-hook 'treemacs-mode-hook #'my-add-hl-line-for-treemacs)
    (add-hook 'treemacs-mode-hook #'display-treemacs-widow-in-ace-window-selection)
    (add-hook 'treemacs-mode-hook #'my-set-bigger-spacing)
    (treemacs-follow-mode -1)
  :bind
    (:map treemacs-mode-map
          ("C-c h" . my-add-hl-line-for-treemacs)
          ("H" . my-decrease-treemacs-width)
          ("L" . my-increase-treemacs-width)
          ;; add-hook no work????
          ("<mouse-1>" . treemacs-single-click-expand-action))
  )

(with-eval-after-load 'treemacs
   (dolist (face '(treemacs-root-face
                    treemacs-git-unmodified-face
                    treemacs-git-modified-face
                    treemacs-git-renamed-face
                    treemacs-git-ignored-face
                    treemacs-git-untracked-face
                    treemacs-git-added-face
                    treemacs-git-conflict-face
                    treemacs-directory-face
                    treemacs-directory-collapsed-face
                    treemacs-file-face
                    treemacs-tags-face))
      (set-face-attribute face nil :family "IBM Plex Mono" :weight 'normal :height 150 :underline nil))
   (when (display-graphic-p)
        (require 'treemacs-nerd-icons)
        (treemacs-load-theme "nerd-icons")
        ;; (require 'treemacs-all-the-icons)
        ;; (treemacs-load-theme "all-the-icons")
        ;; (require 'treemacs-compatibility)
        ;; (treemacs-load-all-the-icons-with-workaround-font "Segoe UI")
     )
   (unless (display-graphic-p)
        (require 'treemacs-nerd-icons)
        (treemacs-load-theme "nerd-icons")
     )
)



(defun my-treemacs-add-and-display-current-project ()
  (interactive)
  (with-selected-window
      (get-buffer-window
       (current-buffer))
    (treemacs-add-and-display-current-project))
  (treemacs-find-file)
  (treemacs-select-window)
  (when (display-graphic-p)
    (setq cursor-type 'box)))








;; Source: https://www.emacswiki.org/emacs/misc-cmds.el
(defun my-revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  (revert-buffer
   :ignore-auto :noconfirm)
  (my-god-mode))





(setq mc/list-file (expand-file-name "~/.emacs.d/.local/.mc-lists.el"))
(setq mc/match-cursor-style nil)
(use-package multiple-cursors
  :ensure t
  :config :bind (("C-x C-n" . mc/mark-next-like-this)
                 ("C-c C-SPC" . mc/edit-lines))
  :init
  (add-hook 'multiple-cursors-mode-enabled-hook #'my-disable-code-intelligence)
  (add-hook 'multiple-cursors-mode-disabled-hook #'my-enable-code-intelligence))

(use-package
  multiple-cursors-core
  :bind (:map mc/keymap
              ("TAB" . 'mc/cycle-forward)
              ("<backtab>" . 'mc/cycle-backward)
              ("RET" . 'newline)
              ;; give RET back to the newline function, use C-c C-c to exit
              ("C-c C-c" . 'multiple-cursors-mode)
              ;; exit
              ("C-x C-n" . 'my-mc/mark-next-like-this)
              ("C-x C-p" . 'my-mc/mark-previous-like-this)
              ("C-x C-a" . 'mc/mark-all-like-this)
              ("C-x C-s" . 'my-mc/skip-to-next-like-this)
              ("C-x C-r" . 'mc/skip-to-previous-like-this)
              ("C-x C-x" . 'mc/unmark-next-like-this)
              ("C-x C-d" . 'mc/unmark-previous-like-this)))





(defun my-mc/mark-next-like-this (arg)
  (interactive "p")
  (if (region-active-p)
      (message
       "search the marked region")
    (er/mark-symbol))
  (mc/mark-next-like-this-word
   arg)
  ;; copy from .emacs.d/elpa/multiple-cursors-20230113.835/mc-mark-more.el
  (let ((end (if mark-active
                 (max (mark) (point))
               (point)))
        furthest)
    (mc/for-each-fake-cursor
     (when (> (mc/cursor-end cursor) end)
       (setq end
             (mc/cursor-end cursor))
       (setq furthest cursor)))
    ;; if end point is not visible in window, then cycle to it.
    (or (pos-visible-in-window-p
         end
         (selected-window))
        (mc/cycle
         furthest
         (mc/first-fake-cursor-after
          (point-min))
         "We're already at the last cursor."))))



(defun my-mc/mark-previous-like-this (arg)
  (interactive "p")
  (if (region-active-p)
      (message
       "search the marked region")
    (er/mark-symbol))
  (mc/mark-previous-like-this-word arg)
  ;; copy from multiple-cursors-20211112.2223/mc-cycle-cursors.el
  (mc/cycle
   (mc/furthest-cursor-before-point)
   (mc/last-fake-cursor-before
    (point-max))
   "We're already at the last cursor"))

(defun my-mc/skip-to-next-like-this (arg)
  (interactive "p")
  ;; copy from multiple-cursors-20211112.2223/mc-cycle-cursors.el
  (mc/cycle
   (mc/furthest-cursor-before-point)
   (mc/last-fake-cursor-before
    (point-max))
   "We're already at the last cursor")
  (mc/skip-to-next-like-this)
  ;; copy from multiple-cursors-20211112.2223/mc-cycle-cursors.el
  (mc/cycle
   (mc/furthest-cursor-after-point)
   (mc/first-fake-cursor-after
    (point-min))
   "We're already at the last cursor."))





(use-package undo-tree
    :config
    (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/.local/.undo-tree-files")))
    (setq undo-tree-auto-save-history nil)
    :init
    (add-hook 'prog-mode-hook #'undo-tree-mode)
    (add-hook 'cmake-mode-hook #'undo-tree-mode)
    (add-hook 'conf-mode-hook #'undo-tree-mode)
    (add-hook 'markdown-mode-hook #'undo-tree-mode)   ;; these modes are not prog mode...
    (advice-add #'undo-tree-load-history :around #'radian--undo-tree-suppress-buffer-modified-message)
)

;; (global-undo-tree-mode)

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





;; Have to use require, not use-package
(require 'hydra)
(defhydra undo-tree-menu (global-map "C-c u")
  "
_u_: undo      _r_: redo
"
  ("u" undo-tree-undo)
  ("r" undo-tree-redo))

(defhydra hydra-cw-o-window-menu (global-map "C-c C-w")
  "
_o_: other-window
"
  ("o" other-window)
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






(defun my-deadgrep-edit-enter()
  (interactive)
  (my-disable-code-intelligence)
  (god-local-mode -1)
  (remove-hook 'before-save-hook #'delete-trailing-whitespace)
  (remove-hook 'switch-buffer-functions #'my-god-mode-with-switch-any-buffer)
  (my-special-buffer-keys-minor-mode 0)
  )


(defun my-deadgrep-edit-exit()
  (interactive)
  (my-enable-code-intelligence)
  (god-local-mode 1)
  (add-hook 'before-save-hook #'delete-trailing-whitespace)
  (add-hook 'switch-buffer-functions #'my-god-mode-with-switch-any-buffer)
  (my-special-buffer-keys-minor-mode 1)
  (deadgrep-mode)
  )

(use-package
  deadgrep
  :ensure t
  :config (setq-default
           deadgrep--context
           (cons 3 3))
  :bind (("C-c g" . deadgrep)
         :map deadgrep-mode-map
         ("RET" . deadgrep-visit-result)
         ("o" . deadgrep-visit-result-other-window)
         ("v" . (lambda ()
                  (interactive)
                  (deadgrep-visit-result-other-window)
                  (other-window 1)))
         ("S" . deadgrep-search-term)
         ("D" . deadgrep-directory)
         ("g" . deadgrep-restart)
         ("n" . deadgrep-forward-match)
         ("r" . deadgrep-backward-match)
         ("p" . deadgrep-backward-match)
         ("N" . deadgrep-forward-filename)
         ("P" . deadgrep-backward-filename)
         ("C-x C-q" . deadgrep-edit-mode)
         :map deadgrep-edit-mode-map
         ("C-c C-c" . my-deadgrep-edit-exit))
  :hook (deadgrep-edit-mode . my-deadgrep-edit-enter)
  :init
  (advice-add 'deadgrep-visit-result :after 'xref-pulse-momentarily)
  (advice-add 'deadgrep-visit-result :after 'my-delete-other-windows)
  (advice-add 'deadgrep-visit-result-other-window :after 'xref-pulse-momentarily))



;;;  treats underscores as part of words
(superword-mode 1)


(require 'highlight)






;; (use-package
;;   highlight-parentheses
;;   :ensure t
;;   :init (add-hook
;;          'prog-mode-hook
;;          #'highlight-parentheses-mode))



(defun my-ibuffer-hook ()
  ;; add another sorting method for ibuffer (allow the grouping of
  ;; filenames and dired buffers
  (define-ibuffer-sorter
      filename-or-dired
    "Sort the buffers by their pathname."
    (:description "filenames plus dired")
    (string-lessp
     (with-current-buffer
         (car a)
       (or buffer-file-name
           (if (eq major-mode 'dired-mode)
               (expand-file-name
                dired-directory))
           ;; so that all non pathnames are at the end
           "~"))
     (with-current-buffer
         (car b)
       (or buffer-file-name
           (if (eq major-mode 'dired-mode)
               (expand-file-name
                dired-directory))
           ;; so that all non pathnames are at the end
           "~"))))
  (define-key ibuffer-mode-map (kbd "s p")
              'ibuffer-do-sort-by-filename-or-dired)
  ;; sort now please!
  (ibuffer-do-sort-by-filename-or-dired))

(add-hook 'ibuffer-mode-hook 'my-ibuffer-hook)

(with-eval-after-load 'dired
  (setq dired-dwim-target t)
  )

(add-hook 'view-mode-hook 'View-exit)
(add-hook 'view-mode-hook 'my-special-buffer-keys-minor-mode)




;; Diactive my all special keys for minibuffer
(add-hook 'minibuffer-setup-hook #'(lambda () (my-keys-minor-mode 0)))
(add-hook 'minibuffer-setup-hook #'(lambda () (my-special-buffer-keys-minor-mode 0)))
;; (add-hook 'helm-minibuffer-set-up-hook #'(lambda () (my-special-buffer-keys-minor-mode 0)))


;; remap TAB -> control-i
;; (define-key input-decode-map [?\C-i] [control-i])




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




(use-package
  selected
  :ensure t
  :commands selected-minor-mode
  :bind ((:map selected-keymap
               ("C-c i" . clang-format-region)
               ("C-c f" . clang-format-buffer)
               ("(" . my-wrap-region-with-parens)
               ("[" . my-wrap-region-with-brackets)
               ("{" . my-wrap-region-with-braces)
               ("'" . my-wrap-region-with-single-quotes)
               ("\"" . my-wrap-region-with-double-quotes)
               ("_" . my-wrap-region-with-underscores)
               ("`" . my-wrap-region-with-back-quotes)))
)
(selected-global-mode 1)



(defun my-toggle-selected-keybinding()
  "add special keybindings for visual selected mode"
  (interactive)
  (if (bound-and-true-p selected-region-active-mode)
    (progn

      ;; only non-special buffer need this timer.
      (when (my-god-this-is-normal-editor-buffer (buffer-name))
          (when (bound-and-true-p selected-active-timer) (cancel-timer selected-active-timer))
          (setq selected-active-timer
                (run-with-timer 0.05 nil #'(lambda() (when (region-active-p)
                                                      (remove-all-highlight)
                                                      (my-disable-paren-highlight)
                                                      (my-disable-eglot-highlight)))))
          )

      (if (bound-and-true-p my-god-mode-is-active-flag)
        (progn
          ;; (message "god mode, & selected-region-active mode")
          ;; (define-key selected-keymap (kbd "i p") #'er/mark-text-paragraph)
          ;; (define-key selected-keymap (kbd "i w") #'er/mark-symbol)
          ;; (define-key selected-keymap (kbd "v") #'keyboard-quit)
          (define-key selected-keymap (kbd "d") #'kill-region)
          ;; (define-key selected-keymap (kbd "x") #'kill-region)
          ;; (define-key selected-keymap (kbd "C-n") #'my-mc/mark-next-like-this)
          ;; (define-key selected-keymap (kbd "C-p") #'my-mc/mark-previous-like-this)
          )
        (progn
          ;; (message "not god mode, & selected-region-active mode")
          ;; (message "is not god-local-mode")
          ;; (define-key selected-keymap (kbd "i p") nil)
          ;; (define-key selected-keymap (kbd "i w") nil)
          ;; (define-key selected-keymap (kbd "v") nil)
          ;; (define-key selected-keymap (kbd "d") nil)
          ;; (define-key selected-keymap (kbd "x") nil)
          ;; (define-key selected-keymap (kbd "C-n") nil)
          ;; (define-key selected-keymap (kbd "C-p") nil)
          )
        ))
    (progn
      ;; (message "not selected-region-active mode")
      (my-enable-eglot-highlight)
      (my-enable-paren-highlight)
      )))
;;;;
(setq selected-region-active-mode-hook #'my-toggle-selected-keybinding)
