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



;; (setq  x-meta-keysym 'super
;;         x-super-keysym 'meta)
;;
;; (when (eq system-type 'darwin)
;;    (setq mac-option-modifier 'super
;;          mac-command-modifier 'meta))





(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))




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



(require 'expand-region)



(toggle-truncate-lines t)


(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold nil    ; if nil, bold is universally disabled
        doom-themes-enable-italic nil) ; if nil, italics is universally disabled
  (doom-themes-neotree-config)
  )

;;  ;; copy background from vim's bogster
;;  (setq spacemacs-theme-custom-colors
;;    '((bg1        .    "#161c23" ))
;;  )

;;  (unless (display-graphic-p)
;;      (load-theme 'doom-xcode t)
;;      ;; (load-theme 'spacemacs-dark t)
;;      ;;(load-theme 'dracula t)
;;  )
;;  (when (display-graphic-p)
;;      (load-theme 'doom-xcode t)
;;      ;; (load-theme 'spacemacs-dark t)
;;      ;; (load-theme 'dracula t)
;;      ;; (load-theme 'kaolin-ocean t)
;;  )

;; (load-theme 'spacemacs-dark t)
(load-theme 'doom-xcode t)

;;  (unless (display-graphic-p)
;;    ; (set-face-attribute 'default nil :background "nil")
;;    ;; (set-face-attribute 'line-number nil :background "nil")
;;    ;; (set-face-attribute 'line-number-current-line nil :background "nil")
;;  )


(setq-default line-spacing 0)
;; (when (display-graphic-p)
;;   (set-face-attribute 'default nil :font "Dejavu Sans Mono for Powerline-14")
;;   (set-cursor-color "red")
;; )

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



(global-set-key [remap lsp-ui-peek-find-definitions] 'my-lsp-ui-peek-find-definitions )
(global-set-key [remap xref-pop-marker-stack] 'my-xref-pop-marker-stack )
(global-set-key [remap xref-go-back] 'my-xref-go-back)
(defun my-lsp-ui-peek-find-definitions()
  (interactive)
  (lsp-ui-peek-find-definitions)
  (recenter)
)
(defun my-xref-pop-marker-stack()
  (interactive)
  (xref-pop-marker-stack)
  (recenter)
)
(defun my-xref-go-back()
  (interactive)
  (xref-go-back)
  (recenter)
)




;; override jump hook
(setq xref-after-jump-hook '(hs-show-all recenter xref-pulse-momentarily))

;; never goto view mode
(add-hook 'view-mode-hook (lambda () (View-exit)))


(add-hook 'go-mode-hook 'lsp-deferred)
(add-hook 'rust-mode-hook 'lsp-deferred)
(add-hook 'c-mode-hook 'lsp-deferred)
(add-hook 'c++-mode-hook 'lsp-deferred)
(add-hook 'erlang-mode-hook 'lsp-deferred)
(add-hook 'java-mode-hook 'lsp-deferred)
(add-hook 'python-mode-hook 'lsp-deferred)



;; https://emacs.stackexchange.com/questions/64970/how-can-i-disable-lsp-headerline
;; (add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)

(use-package lsp-mode
  :defer t
  :init
  (setq lsp-enable-links nil)
  (setq lsp-keymap-prefix "C-c l" )
  (setq lsp-signature-auto-activate nil)
  (setq lsp-diagnostics-provider :none)
  (setq lsp-imenu-sort-methods '(position))
  (setq lsp-headerline-breadcrumb-enable nil)
  :config
  (lsp-headerline-breadcrumb-mode -1)
  :hook
)

(use-package lsp-ui
  :defer t
  :init
  (setq lsp-ui-doc-enable                 nil
        lsp-ui-doc-include-signature      t
        lsp-ui-doc-position               'top
        lsp-ui-doc-header                 nil
        lsp-ui-doc-border                 "white"
        lsp-ui-sideline-enable            nil
        lsp-ui-peek-enable                nil
        lsp-ui-sideline-delay             1
        lsp-ui-sideline-ignore-duplicate  t
        lsp-ui-peek-always-show           nil
        lsp-ui-flycheck-enable            nil
        lsp-enable-snippet                nil
   )
  :bind
  (:map lsp-ui-mode-map
        ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
        ([remap xref-find-references] . lsp-ui-peek-find-references)
        ;; ("C-c u" . lsp-ui-imenu)
        ("C-c k" . lsp-ui-doc-show)
   )
  :config
  (setq lsp-ui-sideline-ignore-duplicate t)
)



;; 0.57.0 works with java 1.8
;; (setq lsp-java-jdt-download-url  "https://download.eclipse.org/jdtls/milestones/0.57.0/jdt-language-server-0.57.0-202006172108.tar.gz")

;; (setq lsp-java--download-root "https://gitee.com/liujiacai/lsp-java/raw/master/install/")
(setq lsp-java-jdt-download-url  "https://download.eclipse.org/jdtls/milestones/1.9.0/jdt-language-server-1.9.0-202203031534.tar.gz")
(use-package lsp-java
    :defer t
    :init
    ; (setq lsp-java-format-settings-url (lsp--path-to-uri (substitute-in-file-name "file://$HOME/.emacs.d/.eclipse-java-formatter.xml" )))      ;; not work!
    ; (setq lsp-java-format-settings-profile '"GoogleStyle")                                                                                    ;; not work!
)

(use-package lsp-python-ms
  :defer t
  :init
  (setq lsp-python-ms-auto-install-server t)
)








(yas-global-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#14141e" "#e84c58" "#35BF88" "#dbac66" "#4ca6e8" "#c79af4" "#6bd9db" "#e6e6e8"])
 '(custom-safe-themes
   '("333958c446e920f5c350c4b4016908c130c3b46d590af91e1e7e2a0611f1e8c5" "76ed126dd3c3b653601ec8447f28d8e71a59be07d010cd96c55794c3008df4d7" "da186cce19b5aed3f6a2316845583dbee76aea9255ea0da857d1c058ff003546" "6c98bc9f39e8f8fd6da5b9c74a624cbb3782b4be8abae8fd84cbc43053d7c175" "a0be7a38e2de974d1598cf247f607d5c1841dbcef1ccd97cded8bea95a7c7639" "1436985fac77baf06193993d88fa7d6b358ad7d600c1e52d12e64a2f07f07176" "25a62bce420d4964a8c5c8079d989d33e708bd70c90977041dce9da10c41ab4a" "9faadda7354abf39736f1f70a0b671219c20406f3c83c76162bc2f5256319ff5" "aae54abad4ea9b61e6ce2591732331d93c2cac7a154d11fd1b44cdd0be69b4e4" "a61f08cfc7728d2cb21e12132acb05b21ed6e9f14e1342b936e9c03616a2b401" "2cc34c4e0033e1dd26c41c9f2dc0acd8bcfbb3edeb30c686c941cc4fa540c5ab" "626492d87426dbe828dc3ed886fe913c13600c55c04b1d62bdb1680869633785" "3080956d3b44a537fa2af292806c239304acb84959be129f8014c9470f8a3ca6" "d2b3341ed2c786cefe1b9a4b9d4a023b68e3f2c3f2ace7f2a4cdaa5021c35c57" "e09b0d90563545be26823d77b303d7f862d4e298374d7903fbf310c102192add" "b5f8f2440106661f5a29695602f867c61b015bce8add3eb79ddfc8f6592e723d" "cbdf8c2e1b2b5c15b34ddb5063f1b21514c7169ff20e081d39cf57ffee89bc1e" "3ab20589e7267ac9d2762402c794c9d9038c1c14c74361265283caf3b367efea" "06ed754b259cb54c30c658502f843937ff19f8b53597ac28577ec33bb084fa52" "e266d44fa3b75406394b979a3addc9b7f202348099cfde69e74ee6432f781336" "e8567ee21a39c68dbf20e40d29a0f6c1c05681935a41e206f142ab83126153ca" "d516f1e3e5504c26b1123caa311476dc66d26d379539d12f9f4ed51f10629df3" "2050674326d536ddd3dcea87e077d27071cfbbe974a4540b1a57b6b672f64c51" "f00a605fb19cb258ad7e0d99c007f226f24d767d01bf31f3828ce6688cbdeb22" "6128465c3d56c2630732d98a3d1c2438c76a2f296f3c795ebda534d62bb8a0e3" "11cc65061e0a5410d6489af42f1d0f0478dbd181a9660f81a692ddc5f948bf34" "3c7a784b90f7abebb213869a21e84da462c26a1fda7e5bd0ffebf6ba12dbd041" "249e100de137f516d56bcf2e98c1e3f9e1e8a6dce50726c974fa6838fbfcec6b" "733ef3e3ffcca378df65a5b28db91bf1eeb37b04d769eda28c85980a6df5fa37" "c95813797eb70f520f9245b349ff087600e2bd211a681c7a5602d039c91a6428" "d9a28a009cda74d1d53b1fbd050f31af7a1a105aa2d53738e9aa2515908cac4c" "57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693" "5f19cb23200e0ac301d42b880641128833067d341d22344806cdad48e6ec62f6" "e8df30cd7fb42e56a4efc585540a2e63b0c6eeb9f4dc053373e05d774332fc13" "8d7b028e7b7843ae00498f68fad28f3c6258eda0650fe7e17bfb017d51d0e2a2" "da53441eb1a2a6c50217ee685a850c259e9974a8fa60e899d393040b4b8cc922" "cf922a7a5c514fad79c483048257c5d8f242b21987af0db813d3f0b138dfaf53" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" "8146edab0de2007a99a2361041015331af706e7907de9d6a330a3493a541e5a6" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "e6f3a4a582ffb5de0471c9b640a5f0212ccf258a987ba421ae2659f1eaa39b09" "47db50ff66e35d3a440485357fb6acb767c100e135ccdf459060407f8baea7b2" "1d44ec8ec6ec6e6be32f2f73edf398620bb721afeed50f75df6b12ccff0fbb15" "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" "23c806e34594a583ea5bbf5adf9a964afe4f28b4467d28777bcba0d35aa0872e" "97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "b3775ba758e7d31f3bb849e7c9e48ff60929a792961a2d536edec8f68c671ca5" "b89a4f5916c29a235d0600ad5a0849b1c50fab16c2c518e1d98f0412367e7f97" "96998f6f11ef9f551b427b8853d947a7857ea5a578c75aa9c4e7c73fe04d10b4" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(helm-minibuffer-history-key "M-p")
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(benchmark-init with-proxy exec-path-from-shell lsp-java valign markdown-toc markdownfmt disable-mouse rainbow-delimiters key-chord google-c-style lua-mode phi-search doom-modeline dracula-theme switch-buffer-functions iedit scala-mode multiple-cursors rtags yasnippet erlang highlight-parentheses all-the-icons undo-tree nimbus-theme challenger-deep-theme kaolin-themes spacemacs-theme afternoon-theme ivy golden-ratio-scroll-screen smooth-scrolling yaml-mode projectile-mode doom-themes smart-mode-line cyberpunk-theme cmake-mode magit lsp-python-ms protobuf-mode vue-mode web-mode centaur-tabs xclip smartparens god-mode rust-mode flycheck mwim which-key deadgrep ripgrep lsp-ui neotree expand-region easy-kill projectile helm-rg helm-ag use-package helm fzf company lsp-mode go-mode))
 '(pos-tip-background-color "#1d1d2b")
 '(pos-tip-foreground-color "#d4d4d6")
 '(safe-local-variable-values '((eval progn (pp-buffer) (indent-buffer))))
 '(warning-suppress-log-types '((comp) (use-package) (lsp-mode)))
 '(warning-suppress-types '((use-package) (lsp-mode))))




(global-whitespace-mode -1)
(setq whitespace-style '(face trailing tabs tab-mark))
(setq whitespace-line-column 85)


(use-package iedit
  :defer t
  :bind
  ("C-c i" . iedit-mode)
)



;; line number fixed width
(setq display-line-numbers-width-start t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'markdown-mode-hook 'display-line-numbers-mode)



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
    :defer t
    :init
    :config
    (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
)



;; delete all other buffers, only keep current one.
(defun my-only-current-buffer ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer)
                (remove-if-not 'buffer-file-name (buffer-list)))))


(add-hook 'before-save-hook #'delete-trailing-whitespace)


;; (global-auto-revert-mode t)
;; (global-hl-line-mode t)


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
(add-hook 'c-mode-hook 'google-set-c-style)
(add-hook 'c++-mode-hook 'google-set-c-style)


(defun my-java-mode-hook ()
     (setq c-basic-offset 4)                  ;; Default is 2
     (setq c-indent-level 4)                  ;; Default is 2
     (setq indent-tabs-mode nil)              ;; use spaces only if nil
)
(add-hook 'java-mode-hook 'my-java-mode-hook)



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
  :bind
  (
    ("C-c p d" . sp-splice-sexp)
    ("C-c p s" . sp-rewrap-sexp)
   )
)




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






;; if graphic mode, use awesome-tray
(when (display-graphic-p)
    (setq awesome-tray-mode-line-active-color '"#00ff00")
    (require 'awesome-tray)
    (awesome-tray-mode 1)

    (global-set-key [escape] 'my-god-mode)
    (define-key input-decode-map [?\C-\[] (kbd "<C-[>"))
    (global-set-key (kbd "<C-[>") 'my-god-mode)

)
;; if terminal mode, use doom modeline
(unless (display-graphic-p)
    (setq doom-modeline-height 1)
    (setq doom-modeline-icon nil)
    (setq doom-modeline-bar-width -1)
    (require 'doom-modeline)
    (doom-modeline-mode 1)
)









(projectile-mode 1)
(setq projectile-enable-caching t)



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
  (let ((starting-ov-count (length (overlays-in (point-min) (point-max)))))
    (hs-hide-all)
    (when (equal (length (overlays-in (point-min) (point-max))) starting-ov-count)
        (hs-show-all)
        (recenter)
      )))



(defun my-hs-toggle-hiding ()
  (interactive)
   (if (hs-already-hidden-p)
       (hs-show-block)
     (hs-hide-block)))



(defun my-hide-all()
  (interactive)
  (hs-minor-mode)
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






(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))
(setq recenter-redisplay nil)


(which-key-mode 1)


(xclip-mode 1)


(smerge-mode -1)


(menu-bar-mode -1)
(tool-bar-mode -1)

(when (display-graphic-p)
(scroll-bar-mode -1)
(tab-bar-mode -1)
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))  ;; dark themes use "dark"

)




(require 'mwim)



;; (setq special-buffers (list "*Minibuf" "*deadgrep" "*xref" "*Buffer" "*Packages" "*scratch" "*Help*" "*lsp-log*"))
(setq special-buffers (list "*Ibuffer*" "*Minibuf" "*deadgrep" "*xref" "*Buffer" "*Packages" "*lsp-log*" "*Help*" "helm-*"))
(require 'god-mode)
(setq god-exempt-major-modes nil)
(setq god-exempt-predicates nil)

(defun my-test-if-special-buffer(bufname)
  (interactive)
  (seq-filter
    (lambda (n) (string-prefix-p n bufname))
    special-buffers)
)

(defun my-god-mode ()
  (interactive)
  (if (my-test-if-special-buffer (string-trim (buffer-name)))
            (progn
                ;; (message "%s is special buffer" (buffer-name))
                (ignore)
            )
            (progn
                ;; (message "%s not a special buffer" (buffer-name))
                (god-local-mode 1)                  ;; start local mode
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
      (progn
        (my-quit-god-mode)
        )
      (progn
        (my-god-mode)
        )
    )
  )





(defun my-god-above-newline-and-insert-mode()
  (interactive)
  (previous-line)
  (end-of-line)
  (newline-and-indent)
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
                 (er/mark-word)
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



(defun my-quit-mc-mode-if-need ()
    (interactive)
    (if (bound-and-true-p multiple-cursors-mode)
      (progn (mc/keyboard-quit) (mc/keyboard-quit))  ;; have to double quit, i don't know why
    )
  )



(defun my-quit ()
    (interactive)
    (my-god-mode)
    (if isearch-mode (isearch-abort))
    (ignore-errors (helm-keyboard-quit))
    (ignore-errors (minibuffer-keyboard-quit))
    (ignore-errors (keyboard-quit))
)



;; (global-set-key (kbd "C-q")      '(lambda () (interactive)
;;                                     (my-quit-mc-mode-if-need)
;;                                     (my-quit))
;; )
(global-set-key (kbd "<escape>") #'(lambda () (interactive)
                                    (my-quit-mc-mode-if-need)
                                    (my-quit))
)


(add-hook 'switch-buffer-functions
        (lambda (prev curr)
          (cl-assert (eq curr (current-buffer)))  ;; Always t
          ;; (message "%S -> %S -> %S" prev curr (string-trim (buffer-name curr)))
          (my-god-mode)
        ))


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
  (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar))

    ;; (if (bound-and-true-p god-local-mode)
    ;;     (set-face-attribute 'line-number nil :foreground "#00ff00")
    ;;     (set-face-attribute 'line-number nil :foreground "#3f4040")
    ;; )

    (if (bound-and-true-p god-local-mode)
        (set-face-attribute 'line-number-current-line nil :foreground "#00ff00")
        (set-face-attribute 'line-number-current-line nil :foreground "#3f4040")
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
  :ensure t
  :init
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-confirm-create-file 'off-p)
  (setq neo-confirm-create-directory 'off-p)
  (setq neo-smart-open 't)
  (setq neo-window-fixed-size nil)
  ;; (setq neo-toggle-window-keep-p 't)
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
;;;
;;; (defun my-neotree-find()
;;;   (interactive)
;;;   (unless (fboundp 'neo-global--window-exists-p) (neotree-show))
;;;   (unless (neo-global--window-exists-p) (neotree-show))
;;;   (neotree-find)
;;; )
;;;
;;;


(use-package treemacs
  :ensure t
  :init
  :config
  (treemacs-resize-icons 18)
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


(use-package multiple-cursors
  :ensure   t
  :config
  (setq mc/match-cursor-style nil)
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
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/.undo-tree-files")))
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






(defun my-deadgrep-visit-result ()
  (interactive)
  (deadgrep-visit-result)
  (hs-show-all)
  (recenter)
  )

(defun my-deadgrep-visit-file-other-window ()
  (interactive)
  (deadgrep-visit-result-other-window)
  (hs-show-all)
  (recenter)
  )

(defun my-deadgrep-view-file ()
  "View result under cursor in other window."
  (interactive)
  (deadgrep-visit-result-other-window)

  (hs-show-all)
  (recenter)
  (other-window 1)
  )

(defun my-deadgrep-edit-enter()
  (interactive)
  (global-undo-tree-mode -1)
  (remove-hook 'before-save-hook #'delete-trailing-whitespace)
  (deadgrep-edit-mode)
  )

(defun my-deadgrep-edit-exit()
  (interactive)
  (global-undo-tree-mode 1)
  (add-hook 'before-save-hook #'delete-trailing-whitespace)
  (deadgrep-mode)
  )

(use-package deadgrep
  :ensure t
  :config
    (setq-default deadgrep--context (cons 3 3))
  :bind(
    ("C-c g" . deadgrep)
    (:map deadgrep-mode-map
          ("RET"  . my-deadgrep-visit-result)
          ("o"    . my-deadgrep-visit-file-other-window)
          ("v"    . my-deadgrep-view-file)
          ("S"    . deadgrep-search-term)
          ("D"    . deadgrep-directory)
          ("g"    . deadgrep-restart)
          ("n"    . deadgrep-forward-match)
          ("p"    . deadgrep-backward-match)
          ("N"    . deadgrep-forward-filename)
          ("P"    . deadgrep-backward-filename)
          ("C-x C-q" . my-deadgrep-edit-enter)
    :map deadgrep-edit-mode-map
         ("C-c C-c" . my-deadgrep-edit-exit)
    )
  )
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






;; must be set as global
(global-set-key (kbd "M-k") #'my-delete-to-beginning )
(global-set-key (kbd "C-k") #'my-delete-to-end )
(global-set-key (kbd "C-g") #'(lambda ()
                               (interactive)
                               (when (bound-and-true-p iedit-mode) (iedit-done))  ;; exit iedit mode, if needed.
                               (keyboard-quit)
                            ))



(defun my-last-in-word ()
  "Move to the next 'last character' of a word."
  (interactive)
  (forward-char)
  (re-search-forward "\\w\\b" nil t)
  (goto-char (match-beginning 0)))



(defun my-replace-char ()
  "delete current char, goto insert mode"
  (interactive)
  (delete-forward-char 1)
  ;; (call-interactively (key-binding (kbd "q")))
  (my-quit-god-mode)
  )


(defun my-kill-word (arg)
  "delete current word, goto insert mode"
  (interactive "p")
  (kill-word arg)
  (my-quit-god-mode)
  )


(defun my-save-buffer ()
  "delete current word, goto insert mode"
  (interactive)
  (save-buffer)
  (my-god-mode)
  (my-quit-mc-mode-if-need)
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

    (define-key map (kbd "M-;") 'avy-goto-word-0)
    (define-key map (kbd "M-s") 'my-save-buffer)
    (define-key map (kbd "M-n") 'gcm-scroll-down)
    (define-key map (kbd "M-p") 'gcm-scroll-up)
    (define-key map (kbd "M-o") 'ace-select-window)
    (define-key map (kbd "C-q") 'my-toggle-god-mode)


    (define-prefix-command 'my-god-mode-leader-key)
    (define-prefix-command 'my-god-mode-dummmy-key)
    (define-prefix-command 'my-god-mode-viewer-key)
    (define-key god-local-mode-map (kbd "SPC") 'my-god-mode-leader-key)
    (define-key god-local-mode-map (kbd ",")   'my-god-mode-dummmy-key)
    (define-key god-local-mode-map (kbd "z")   'my-god-mode-viewer-key)

    ;; God mode key mappings
    (define-key god-local-mode-map (kbd "f") #'avy-goto-word-0)
    (define-key god-local-mode-map (kbd "w") #'forward-word)
    (define-key god-local-mode-map (kbd "b") #'backward-word)
    (define-key god-local-mode-map (kbd "k") #'previous-line)
    (define-key god-local-mode-map (kbd "j") #'next-line)
    (define-key god-local-mode-map (kbd "l") #'forward-char)
    (define-key god-local-mode-map (kbd "h") #'backward-char)
    (define-key god-local-mode-map (kbd "v") #'set-mark-command)
    (define-key god-local-mode-map (kbd "V") #'my-select-current-line-and-forward-line)
    (define-key god-local-mode-map (kbd "J") #'my-join-lines)
    (define-key god-local-mode-map (kbd "y") #'kill-ring-save)
    (define-key god-local-mode-map (kbd "p") #'yank)
    (define-key god-local-mode-map (kbd "u") #'undo-tree-undo)
    (define-key god-local-mode-map (kbd "C-r") #'undo-tree-redo)
    (define-key god-local-mode-map (kbd "o") #'my-god-below-newline-and-insert-mode)
    (define-key god-local-mode-map (kbd "O") #'my-god-above-newline-and-insert-mode)
    ;; (define-key god-local-mode-map (kbd "a") #'my-god-char-forward-and-insert-mode)
    ;; (define-key god-local-mode-map (kbd "A") #'my-god-mwin-end-and-insert-mode)
    (define-key god-local-mode-map (kbd "i") #'my-quit-god-mode) ; toggle to disable god-mod globally
    ;; (define-key god-local-mode-map (kbd "I") #'my-god-mwin-beginning-and-insert-mode)

    ;; (define-key god-local-mode-map (kbd "x") #'delete-forward-char)
    (define-key god-local-mode-map (kbd "s") #'my-replace-char)
    (define-key god-local-mode-map (kbd "C-c C-w") #'my-kill-word)

    (define-key god-local-mode-map (kbd "d") #'kill-region)
    (define-key god-local-mode-map (kbd "-") #'delete-char)
    ;; (define-key god-local-mode-map (kbd "X") #'kill-region)
    ;; (define-key god-local-mode-map (kbd "D") #'delete-char)
    ;; (define-key god-local-mode-map (kbd "d") #'(lambda () (interactive)()))   ;; placeholder
    ;; (my-key-chord-define god-local-mode-map "dd"  #'kill-region)
    ;; (my-key-chord-define god-local-mode-map "dw"  #'kill-word)
    ;; (my-key-chord-define god-local-mode-map "dL"  #'my-delete-to-end)   ;; delete to end
    ;; (my-key-chord-define god-local-mode-map "dH"  #'my-delete-to-beginning)  ;; delete to begin
    ;; (my-key-chord-define god-local-mode-map "de"  #'my-delete-to-end)   ;; delete to end
    ;; (my-key-chord-define god-local-mode-map "da"  #'my-delete-to-beginning)  ;; delete to begin


    (define-key god-local-mode-map (kbd "r") #'my-hs-toggle-hiding)
    (define-key god-local-mode-map (kbd "m") #'my-goto-match-paren)
    (define-key god-local-mode-map (kbd "z m") #'my-hs-toggle-all)
    (define-key god-local-mode-map (kbd "z z") #'recenter-top-bottom)
    (define-key god-local-mode-map (kbd "z b") #'end-of-buffer)                     ;; , j   to bottom
    (define-key god-local-mode-map (kbd "z t") #'beginning-of-buffer)               ;; , k   to bottom

    (define-key god-local-mode-map (kbd "C-c C-v") #'set-rectangular-region-anchor)
    (define-key god-local-mode-map (kbd "C-c C-o") #'helm-occur)
    (define-key god-local-mode-map (kbd "C-c C-s") #'my-helm-ag-thing-at-point)

    (define-key god-local-mode-map (kbd "L") #'mwim-end-of-code-or-line)          ;; , l   to line right
    (define-key god-local-mode-map (kbd "H") #'mwim-beginning-of-code-or-line)    ;; , h   to line left


    (define-key god-local-mode-map (kbd "*") #'my-search-selection)
    (define-key god-local-mode-map (kbd "/") #'isearch-forward)

    (define-key god-local-mode-map (kbd ":") #'helm-M-x)


    (define-key god-local-mode-map (kbd "A") #'beginning-of-defun)    ;; , h   to line left
    (define-key god-local-mode-map (kbd "E") #'end-of-defun)    ;; , h   to line left

    (define-key god-local-mode-map (kbd "C-.") #'repeat)
    (define-key god-local-mode-map (kbd "C-~") #'upcase-char)

    (define-key god-local-mode-map (kbd "C-x C-n") #'my-mc/mark-next-like-this)
    (define-key god-local-mode-map (kbd "C-x C-p") #'my-mc/mark-previous-like-this)
    ;;  (define-key god-local-mode-map (kbd "C-, C-p") #'my-mc/mark-previous-like-this)
    ;;  (define-key god-local-mode-map (kbd "C-, C-s") #'mc/skip-to-next-like-this)
    ;;  (define-key god-local-mode-map (kbd "C-, C-r") #'mc/skip-to-previous-like-this)
    ;;  (define-key god-local-mode-map (kbd "C-, C-a") #'mc/mark-all-like-this)

    (define-key god-local-mode-map (kbd "SPC b") #'switch-to-buffer)
    (define-key god-local-mode-map (kbd "SPC k") #'kill-this-buffer)
    (define-key god-local-mode-map (kbd "SPC K") #'my-only-current-buffer)
    (define-key god-local-mode-map (kbd "SPC f") #'projectile-find-file)
    (define-key god-local-mode-map (kbd "SPC m") #'deadgrep)
    (define-key god-local-mode-map (kbd "SPC L") #'display-line-numbers-mode)

    (define-key god-local-mode-map (kbd "SPC t") #'treemacs)
    (define-key god-local-mode-map (kbd "SPC n") #'my-neotree-toggle)

    (define-key god-local-mode-map (kbd "@") #'(lambda() (interactive) (treemacs-find-file) (treemacs-select-window)))
    (define-key god-local-mode-map (kbd "SPC @") #'treemacs-add-and-display-current-project)

    (define-key god-local-mode-map (kbd "SPC w l") #'windmove-right)
    (define-key god-local-mode-map (kbd "SPC w h") #'windmove-left)
    (define-key god-local-mode-map (kbd "SPC w k") #'windmove-up)
    (define-key god-local-mode-map (kbd "SPC w j") #'windmove-down)
    (define-key god-local-mode-map (kbd "SPC w q") #'delete-window)      ;; delete this window
    (define-key god-local-mode-map (kbd "SPC w d") #'delete-other-windows)  ;; delete other window
    (define-key god-local-mode-map (kbd "SPC w v") #'split-window-right)
    (define-key god-local-mode-map (kbd "SPC w s") #'split-window-below)
    (define-key god-local-mode-map (kbd "SPC w w") #'ace-select-window)

    ;;
    ;; dummmy key
    ;;
    (define-key god-local-mode-map (kbd ", w") #'my-save-buffer)
    (define-key god-local-mode-map (kbd ", b") #'flip-buffer-to-window)
    (define-key god-local-mode-map (kbd ", ,") #'er/mark-symbol)             ;; b a   last buffer

    ;; (define-key god-local-mode-map (kbd "C-, C-h") #'switch-to-prev-buffer)
    ;; (define-key god-local-mode-map (kbd "C-, C-l") #'switch-to-next-buffer)


    ;; (my-key-chord-define god-local-mode-map ",,"  #'er/mark-symbol)

    ;; (define-key god-local-mode-map (kbd "C-m") #'next-line)

    (define-key god-local-mode-map (kbd ";") #'scroll-up-command)
    (define-key god-local-mode-map (kbd "'") #'scroll-down-command)
    (define-key god-local-mode-map (kbd "\\") #'recenter-top-bottom)


    ;; projectile
    (define-key projectile-mode-map (kbd "C-c f") 'projectile-command-map)


    map)
  "my-keys-minor-mode keymap.")



(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " my-keys")
(my-keys-minor-mode 1)








(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)
