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

(setq mac-command-modifier 'super)


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
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/lisp"))


(global-unset-key [(control z)])

(setq warning-minimum-level :emergency)



(require 'autothemer)
;; (load-theme 'bogster t)


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


;; compile log with colors
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)






(require 'expand-region)
(global-set-key (kbd "M-i") 'er/expand-region)

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

;; (load-theme 'spacemacs-dark t)
;; (load-theme 'dracula t)
;; (load-theme 'spacemacs-dark t)
;; (load-theme 'dracula t)
;; (load-theme 'kaolin-ocean t)
;; (load-theme 'cyberpunk t)
;; (load-theme 'atom-one-dark t)
;; (load-theme 'doom-molokai t)
;; (load-theme 'doom-palenight t)
;; (load-theme 'doom-material t)
;; (load-theme 'doom-dracula t)
;; (load-theme 'kaolin-aurora t)
;; (load-theme 'challenger-deep t)
;; (load-theme 'kaolin-temple t)
;; (load-theme 'kaolin-ocean t)
;; (load-theme 'doom-material t)
;; (load-theme 'atom-one-dark t)
(load-theme 'one-dark-pro t)


(setq-default line-spacing 0)

(set-face-attribute 'default nil :font "Source Code Pro for Powerline-16")
(add-to-list 'default-frame-alist '(font . "Source Code Pro for Powerline-16"))
(set-cursor-color "red")

;; (set-face-attribute 'region nil :background "#666")





(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-dim-other-buffers-face ((t (:background "#232d38"))))
 '(avy-lead-face ((t (:foreground "#ff77cc" :background nil))))
 '(avy-lead-face-0 ((t (:foreground "#ff77cc" :background nil))))
 '(deadgrep-match-face ((t (:foreground "#7fdc59" :background "#232d38" :weight normal))))
 '(deadgrep-search-term-face ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(eglot-highlight-symbol-face ((t (:foreground "#000000" :background "#7fdc59" :weight normal))))
 '(hydra-face-red ((t (:foreground "chocolate" :weight bold))))
 '(iedit-occurrence ((t (:background "yellow" :foreground "black" :inverse-video nil))))
 '(lsp-face-highlight-read ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(lsp-face-highlight-textual ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(lsp-face-highlight-write ((t (:foreground "#000000" :background "#00ff00" :weight normal))))
 '(mc/region-face ((t (:foreground "#ff77cc" :inverse-video t :weight normal))))
 '(next-error ((t (:foreground "#000000" :background "#00ff00"))))
 '(show-paren-match ((t (:foreground "#000000" :background "#00ff00"))))
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
 '(treemacs-root-face ((t :inherit font-lock-constant-face :underline t :bold t :height 1.0)))
 '(window-divider ((t (:foreground "green"))))
 '(yas-field-highlight-face ((t (:foreground "#000000" :background "#7fdc59" :weight normal)))))





;; (set-face-attribute 'mode-line :underline "#00ff00")
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
  (xref-pulse-momentarily)
  ;; from crosshairs.el
  ;; (flash-crosshairs)
)

(advice-add 'xref-go-back                   :after 'my-recenter)
(advice-add 'xref-pop-marker-stack          :after 'my-recenter)
(advice-add 'lsp-ui-peek-find-definitions   :after 'my-recenter)
(advice-add 'pop-global-mark                :after 'my-recenter)
(advice-add 'xref-after-jump-hook           :after 'my-recenter)


;; quit xref buffer after enter
(with-eval-after-load 'xref
  (define-key xref--xref-buffer-mode-map(kbd "o") #'(lambda() (interactive) (xref-goto-xref t)))
)








(setq dap-java-test-runner (expand-file-name "~/.emacs.d/.local/eclipse.jdt.ls/test-runner/junit-platform-console-standalone.jar"))
(setq dap-breakpoints-file (expand-file-name "~/.emacs.d/.local/.dap-breakpoints"))


(setq eglot-java-junit-platform-console-standalone-jar (expand-file-name "~/.emacs.d/.local/eclipse.jdt.ls/test-runner/junit-platform-console-standalone.jar"))




(require 'eldoc-box)

(require 'init-funcs)

(require 'init-eglot)

(require 'init-lang-java)

(require 'download-lombok)

(require 'init-lang-go)

(require 'init-lang-cpp)

(require 'init-lang-zig)


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

;; http://company-mode.github.io/manual/Getting-Started.html#Initial-Setup
(with-eval-after-load 'company
  (define-key company-active-map (kbd "<tab>") #'company-select-next-if-tooltip-visible-or-complete-selection)
  (define-key company-active-map (kbd "<backtab>") #'company-select-previous-or-abort)
  (define-key company-active-map (kbd "RET") #'company-complete-selection))
;; Use (kbd "TAB") (or use (kbd "<tab>"), if you want to distinguish C-i from the <tab> key)





(require 'transpose-frame)


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
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/.local/autosaves/\\1" t)))
 '(auto-save-list-file-prefix (expand-file-name "~/.emacs.d/.local/auto-save-list/"))
 '(backup-directory-alist '((".*" . "~/.emacs.d/.local/backups/")))
 '(create-lockfiles nil)
 '(helm-minibuffer-history-key "M-p")
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(beacon rjsx-mode typescript-mode impatient-mode reformatter auto-dim-other-buffers flymake-diagnostic-at-point atom-one-dark-theme jdecomp smart-jump ansible moe-theme selected benchmark-init with-proxy valign markdown-toc markdownfmt disable-mouse rainbow-delimiters key-chord google-c-style phi-search switch-buffer-functions yasnippet highlight-parentheses undo-tree nimbus-theme challenger-deep-theme afternoon-theme smooth-scrolling projectile-mode smart-mode-line cyberpunk-theme lsp-python-ms protobuf-mode vue-mode xclip mwim ripgrep neotree easy-kill helm-rg))
 '(pos-tip-background-color "#1d1d2b")
 '(pos-tip-foreground-color "#d4d4d6")
 '(recentf-save-file (expand-file-name "~/.emacs.d/.local/recentf"))
 '(safe-local-variable-values
   '((projectile-project-root . "~/deploy")
     (eval progn
       (pp-buffer)
       (indent-buffer))))
 '(warning-suppress-log-types '((emacs) (use-package) (lsp-mode)))
 '(warning-suppress-types '((use-package) (lsp-mode))))




;; lsp-mode session file
(setq lsp-session-file (expand-file-name "~/.emacs.d/.local/.lsp-session-v1"))




(global-whitespace-mode -1)
(setq whitespace-style '(face trailing tabs tab-mark))
(setq whitespace-line-column 85)

(add-hook 'before-save-hook #'delete-trailing-whitespace)



(use-package iedit
  :defer t
  :bind
  ("M-'" . iedit-mode)
)




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

(use-package impatient-mode
  :config
  (add-hook 'markdown-mode-hook #'(lambda ()
                                    (impatient-mode 1)
                                    (imp-set-user-filter 'markdown-html-github)
                                    ))
  )




(use-package ace-window
  :defer t
  :delight
  :config
  (ace-window-display-mode 1)
  )

;; alternatively, use Meta-<left> Meta-<right> to move cursor to window
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
    "Kill all non-star other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer) (remove-if-not 'buffer-file-name (buffer-list)))))     ;; this keep * buffers alive

;; delete all other buffers, only keep current one.
(defun my-only-current-buffer-include-specials ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer) (buffer-list))))                                       ;; this destroy * buffers too








;; (global-auto-revert-mode t)


(defun my-go-mode-hook ()
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)


(defun my-clang-format-buffer-if-need ()
  (if (derived-mode-p 'c++-mode)
        (clang-format-buffer)
        (ignore)
    )
)

(defun my-c-mode-hook ()
  (add-hook 'before-save-hook 'my-clang-format-buffer-if-need)
)

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)






(defun my-tab-4-indent ()
    (setq tab-width 4)                  ;; Default is 2
    (setq c-basic-offset 4)                  ;; Default is 2
    (setq c-indent-level 4)                  ;; Default is 2
    (setq indent-tabs-mode nil)              ;; use spaces only if nil
)



(require 'smartparens-config)

(defun indent-between-pair (&rest _ignored)
  (newline)
  (indent-according-to-mode)
  (forward-line -1)
  (indent-according-to-mode))

(with-eval-after-load 'smartparens
  (sp-local-pair 'prog-mode "{" nil :post-handlers '((indent-between-pair "RET")))
  (sp-local-pair 'prog-mode "[" nil :post-handlers '((indent-between-pair "RET")))
  (sp-local-pair 'prog-mode "(" nil :post-handlers '((indent-between-pair "RET")))
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
(setq helm-buffer-max-length 40)
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


(require 'helm-projectile)
(helm-projectile-on)
(setq helm-projectile-truncate-lines t)





;; (use-package ivy
;;   :ensure t
;;   :diminish ivy-mode
;;   :hook (after-init . ivy-mode))



(delete-selection-mode 1)

(add-hook 'org-mode-hook #'valign-mode)
(add-hook 'markdown-mode-hook #'valign-mode)

(add-hook 'markdown-mode-hook #'prog-mode)



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
;; (scroll-bar-mode -1)
(tab-bar-mode -1)


; (smerge-mode -1)
; (menu-bar-mode -1)
; (tool-bar-mode -1)

(when (display-graphic-p)
    ;;; ;; awesome-tray is from emacswiki sub-directory
    ;;; (setq awesome-tray-mode-line-active-color '"#00ff00")

    ;;; (require 'awesome-tray)
    ;;; (awesome-tray-mode 1)

    (scroll-bar-mode -1)
    ;; (tab-bar-mode -1)
    (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
    (add-to-list 'default-frame-alist '(ns-appearance . dark))  ;; dark themes use "dark"

    (global-set-key [escape] 'my-escape-key)
    (define-key input-decode-map [?\C-\[] (kbd "<C-[>"))
    (global-set-key (kbd "<C-[>") 'my-escape-key)
)

(unless (display-graphic-p)
    ;; (setq doom-modeline-height 1)
    ;; (setq doom-modeline-icon nil)
    ;; (setq doom-modeline-bar-width -1)
    (setq doom-modeline-buffer-file-name-style 'relative-from-project)
    (require 'doom-modeline)
    (doom-modeline-mode 1)
)





(projectile-mode 1)
(setq projectile-enable-caching t)
(setq projectile-cache-file          (expand-file-name "~/.emacs.d/.local/projectile.cache"))
(setq projectile-known-projects-file (expand-file-name "~/.emacs.d/.local/projectile-bookmarks.eld"))


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



(use-package flymake-diagnostic-at-point
  :after flymake
  :config
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))





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
    (if (derived-mode-p 'c++-mode)
        ; find namespace, go below one line, and then hide
        (save-excursion
            (goto-char (point-min))
            (re-search-forward "namespace.*?{" nil t)
            (next-line)
            (hs-hide-level 1)
          )
        (hs-hide-all)
      )
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
(setq avy-keys (list ?a ?c ?d ?e ?f ?h ?i ?j ?k ?l ?m ?n ?o ?s ?v ?w ?\;))
(setq avy-background 't)


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






(setq recenter-redisplay nil)



;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/.local/auto-save-list/" t)
(make-directory "~/.emacs.d/.local/autosaves/" t)
(make-directory "~/.emacs.d/.local/backups" t)




(which-key-mode 1)


(xclip-mode 1)



(require 'mwim)




(defun buffer-mode (&optional buffer-or-name)
  "Returns the major mode associated with a buffer.
If buffer-or-name is nil return current buffer's mode."
  (with-current-buffer (if buffer-or-name (get-buffer buffer-or-name) (current-buffer))
     major-mode))




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
                        "*Warnings*"
                        "helm-*"
                        ;; "*helm-mode-switch-to-buffer*"
                        "*Helm Help*"
                        "*Flymake diagnostics"
                        "*ansi-term*"
                        "*fzf*"
                        "*NeoTree*"))

;; legendary-buffers are not affected by god-mode AND my-special-buffer-keys-minor-mode-map
(setq legendary-buffers (list "*this-buffer-is-left-alone-without-god-mode-at-all" "*Minibuf" "*terminal*" "*eshell*"))

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
            (my-keys-minor-mode 0)
            (my-special-buffer-keys-minor-mode 0)
            (cl-return-from my-god-mode)
        )
        (progn
            ;; (message "%s is not legendary buffer, continue" (buffer-name))
         )
    )

  (if (my-god-this-is-special-buffer (buffer-name))
            (progn
                ;; (message "%s is special buffer" (buffer-name))
                (ignore)
                (my-keys-minor-mode 0)
                (my-special-buffer-keys-minor-mode 1)
            )
            (progn
                ;; (message "%s not a special buffer" (buffer-name))
                (god-local-mode 1)                  ;; start local mode
                (setq my-god-mode-is-active-flag t)
                (my-special-buffer-keys-minor-mode 0)
             )
    nil)

)

(defun my-quit-god-mode()
  (interactive)
  (god-local-mode -1)
  ;; my-god-mode is meant to have value, but it's not set, maybe god-mode bug?
  ;; anyway, we use our own flags here
  (setq my-god-mode-is-active-flag nil)
  )

(defun my-toggle-god-mode()
  (interactive)
  (if (bound-and-true-p god-local-mode)
      (progn
        (message "is local-mode, quit it")
        (my-quit-god-mode)
    )
    (progn
      (message "is not local-mode, start it")
      (my-god-mode)
      )
    )
  )




(defun my-god-mode-with-switch-any-buffer(prev curr)
    (cl-assert (eq curr (current-buffer)))  ;; Always t
    ;; (message "%S -> %S -> %S" prev curr (string-trim (buffer-name curr)))
    (my-god-mode)
  )
(add-hook 'switch-buffer-functions #'my-god-mode-with-switch-any-buffer)




(defun my-god-below-newline-and-insert-mode()
  (interactive)
  (end-of-line)
  (newline-and-indent)
  (my-quit-god-mode)
  )

(defun my-god-above-newline-and-insert-mode()
  (interactive)
  (previous-line)
  (my-god-below-newline-and-insert-mode)
  (my-quit-god-mode)
  )

(defun my-god-mwin-end-and-insert-mode()
  (interactive)
  (mwim-end-of-code-or-line)
  (my-quit-god-mode)
  )

(defun my-god-mwin-beginning-and-insert-mode()
  (interactive)
  (mwim-beginning-of-code-or-line)
  (my-quit-god-mode)
  )

(defun my-god-char-forward-and-insert-mode()
  (interactive)
  (forward-char)
  (my-quit-god-mode)
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


(defvar my-code-intelligence 't "enable by default")

(defun my-disable-eglot-highlight()
  (interactive)
        (set-face-attribute 'eglot-highlight-symbol-face nil :foreground 'unspecified :background 'unspecified)
  )
(defun my-enable-eglot-highlight()
  (interactive)
        (set-face-attribute 'eglot-highlight-symbol-face nil :foreground "#000000" :background "#7fdc59")
  )

(defun my-disable-code-intelligence()
  (interactive)
    (if my-code-intelligence
      (progn
        (my-disable-eglot-highlight)
        (smartparens-global-mode -1)
        (smartparens-mode -1)
        (electric-indent-mode -1)
        ;; (global-undo-tree-mode -1)
        (undo-tree-mode -1)

        (setq my-code-intelligence nil)
        (message "code-intelligence is disabled.")
      )
    )
)

(defun my-enable-code-intelligence()
  (interactive)
    (if (not my-code-intelligence)
      (progn
        (my-enable-eglot-highlight)
        (smartparens-global-mode 1)
        (smartparens-mode 1)
        (electric-indent-mode 1)
        ;; (global-undo-tree-mode 1)
        (undo-tree-mode 1)

        (setq my-code-intelligence 't)
        (message "code-intelligence is enabled.")
      )
    )
)

(add-hook 'isearch-mode-hook #'my-disable-code-intelligence)
(add-hook 'isearch-mode-end-hook #'my-enable-code-intelligence)








(setq hl-line-inhibit-highlighting-for-modes '(dired-mode deadgrep-mode deadgrep-edit-mode treemacs-mode))
(global-hl-line-mode 1)

;;; from emacswiki
(require 'crosshairs)



(beacon-mode 1)






(defun my-god-mode-update-cursor-type ()
  ;; (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar))
    (if (bound-and-true-p god-local-mode)
      (progn
                (set-face-attribute 'hl-line nil :foreground 'unspecified :background "#313f4e")
                (set-face-attribute 'line-number-current-line nil :foreground "#7fdc59" :background "#232d38")
                ;; (set-face-attribute 'mode-line nil :background "#38424B")
                ;; (set-face-attribute 'mode-line-active nil :foreground "yellow" :background "#364D2D")
                ;; (set-face-attribute 'mode-line-inactive nil :foreground "yellow" :background "#364D2D")
                (set-face-attribute 'window-divider nil :foreground "gray")
                (set-face-foreground 'vertical-border "#627d9d")
                (setq cursor-type 'box)
      )
      (progn
                (set-face-attribute 'hl-line nil :foreground 'unspecified :background (face-background 'default))
                (set-face-attribute 'line-number-current-line nil :foreground "black" :background "#7fdc59")
                ;;(set-face-attribute 'mode-line nil :background "#38424B")
                ;; (set-face-attribute 'mode-line-active nil :foreground 'unspecified :background "#161c23")
                ;; (set-face-attribute 'mode-line-inactive nil :foreground 'unspecified :background "#161c23")
                (set-face-attribute 'window-divider nil :foreground "green")
                (set-face-foreground 'vertical-border "#00ff00")
                (setq cursor-type 'bar)
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
  ;; (setq neo-window-width 45)
  ;; (setq neo-toggle-window-keep-p 't)
)
(with-eval-after-load 'neotree
  ;; (define-key neotree-mode-map (kbd "L") #'(lambda () (interactive) (setq neo-window-width (/ (display-pixel-width) 2)) (neotree-hide) (my-neotree-find)))
  ;; (define-key neotree-mode-map (kbd "H") #'(lambda () (interactive) (setq neo-window-width 35) (neotree-hide) (my-neotree-find)))
  (define-key neotree-mode-map (kbd "L") #'(lambda () (interactive) (setq neo-window-width 25) (neotree-hide) (my-neotree-find)))
  (define-key neotree-mode-map (kbd "H") #'(lambda () (interactive) (setq neo-window-width (/ (display-pixel-width) 4)) (neotree-hide) (my-neotree-find)))
  (define-key neotree-mode-map (kbd "f") #'(lambda () (interactive) (neotree-hidden-file-toggle)))
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

(defun treemacs-mode-handler()
  (set (make-local-variable 'face-remapping-alist)
    '(
        (default :background  "#252832")
    )
))

(add-hook 'treemacs-mode-hook 'treemacs-mode-handler)




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




;; Source: https://www.emacswiki.org/emacs/misc-cmds.el
(defun my-revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm)
    (my-god-mode)
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
    (define-key mc/keymap (kbd "RET") 'newline) ;; give RET back to the newline function, use C-c C-c to exit
    (define-key mc/keymap (kbd "C-c C-c") 'multiple-cursors-mode) ;; exit

    (define-key mc/keymap (kbd "C-x C-n") 'my-mc/mark-next-like-this)
    (define-key mc/keymap (kbd "C-x C-p") 'my-mc/mark-previous-like-this)
    (define-key mc/keymap (kbd "C-x C-a") 'mc/mark-all-like-this)
    (define-key mc/keymap (kbd "C-x C-s") 'my-mc/skip-to-next-like-this)
    (define-key mc/keymap (kbd "C-x C-r") 'mc/skip-to-previous-like-this)
    (define-key mc/keymap (kbd "C-x C-x") 'mc/unmark-next-like-this)
    (define-key mc/keymap (kbd "C-x C-d") 'mc/unmark-previous-like-this)

    (add-hook 'multiple-cursors-mode-enabled-hook #'my-disable-code-intelligence)
    (add-hook 'multiple-cursors-mode-disabled-hook #'my-enable-code-intelligence)
  )




(require 'undo-tree)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/.local/.undo-tree-files")))
(setq undo-tree-auto-save-history nil)
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
(advice-add #'undo-tree-load-history :around
            #'radian--undo-tree-suppress-buffer-modified-message)

(add-hook 'prog-mode-hook #'undo-tree-mode)



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
  (my-disable-code-intelligence)
  (my-quit-god-mode)
  (remove-hook 'before-save-hook #'delete-trailing-whitespace)
  (remove-hook 'switch-buffer-functions #'my-god-mode-with-switch-any-buffer)
  (my-special-buffer-keys-minor-mode 0)
  )


(defun my-deadgrep-edit-exit()
  (interactive)
  (my-enable-code-intelligence)
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



(defun my-enlarge-half-height ()
  "Expand current window to use half of the other window's lines."
  (interactive)
  (enlarge-window (/ (window-body-height) 4)))

(defun my-enlarge-half-width ()
  "Expand current window to use half of the other window's lines."
  (interactive)
  (enlarge-window-horizontally (/ (window-body-width) 4)))

(defun my-shrink-half-height ()
  "Expand current window to use half of the other window's lines."
  (interactive)
  (shrink-window (/ (window-body-height) 4)))

(defun my-shrink-half-width ()
  "Expand current window to use half of the other window's lines."
  (interactive)
  (shrink-window-horizontally (/ (window-body-width) 4)))




(defun my-delete-other-windows ()
  (interactive)
  (delete-other-windows)
  (recenter-top-bottom)
  )






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

    (define-key dired-mode-map (kbd "k") #'previous-line)
    (define-key dired-mode-map (kbd "j") #'next-line)

    (define-key dired-mode-map (kbd "SPC b") #'switch-to-buffer)
    (define-key dired-mode-map (kbd "SPC B") #'ibuffer)
    (define-key dired-mode-map (kbd "SPC k") #'kill-this-buffer)
    (define-key dired-mode-map (kbd "SPC K") #'my-only-current-buffer)
    (define-key dired-mode-map (kbd "SPC M-k") #'my-only-current-buffer-include-specials)

    (define-key dired-mode-map (kbd "SPC f") #'helm-projectile)  ;;  projectile-find-file
    (define-key dired-mode-map (kbd "SPC p") #'helm-find-files)
    (define-key dired-mode-map (kbd "SPC m") #'deadgrep)
    (define-key dired-mode-map (kbd "SPC L") #'display-line-numbers-mode)
    (define-key dired-mode-map (kbd "SPC x") #'delete-window)   ;; delete this window
  ))




(advice-add
 'helm-M-x
 :before
 (lambda (&rest r) (my-god-mode))
 '((name . "my-god-mode-before-m-x")) ; convenient name for identifying or removing this advice later
 )




(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-x") #'helm-M-x)
    (define-key map (kbd "C-h SPC") #'helm-all-mark-rings)

    (define-key map (kbd "C-M-.") #'xref-find-definitions-other-window )

    (define-key map (kbd "s-d") #'my-mc/mark-next-like-this)


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
    (define-key map (kbd "C-c C-v") 'set-rectangular-region-anchor)

    (define-key map (kbd "C-c o") 'helm-occur)
    (define-key map (kbd "C-c s") 'my-helm-ag-thing-at-point)
    (define-key map (kbd "C-c C-o") 'helm-occur)
    (define-key map (kbd "C-c C-s") 'my-helm-ag-thing-at-point)

    ;; (define-key map (kbd "M-i") #'er/mark-symbol)
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

    (define-key god-local-mode-map (kbd "<RET>") #'next-line)

    (define-key god-local-mode-map (kbd "z o") #'my-hs-toggle-hiding)
    (define-key god-local-mode-map (kbd "z m") #'my-hs-toggle-all)
    (define-key god-local-mode-map (kbd "z z") #'recenter-top-bottom)
    (define-key god-local-mode-map (kbd "z .") #'end-of-buffer)
    (define-key god-local-mode-map (kbd "z ,") #'beginning-of-buffer)

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

    (define-key god-local-mode-map (kbd "C-n") #'my-mc/mark-next-like-this)

    (define-key god-local-mode-map (kbd "C-x C-n") #'my-mc/mark-next-like-this)
    (define-key god-local-mode-map (kbd "C-x C-p") #'my-mc/mark-previous-like-this)

    (define-key god-local-mode-map (kbd "SPC SPC") #'helm-all-mark-rings)
    (define-key god-local-mode-map (kbd "SPC b") #'switch-to-buffer)
    (define-key god-local-mode-map (kbd "SPC B") #'ibuffer)
    (define-key god-local-mode-map (kbd "SPC k") #'kill-this-buffer)
    (define-key god-local-mode-map (kbd "SPC K") #'my-only-current-buffer)
    (define-key god-local-mode-map (kbd "SPC P P") #'my-show-file-name)
    (define-key god-local-mode-map (kbd "SPC M-k") #'my-only-current-buffer-include-specials)

    (define-key god-local-mode-map (kbd "SPC ,") #'eldoc-box-eglot-help-at-point)
    (define-key god-local-mode-map (kbd "SPC R") #'my-revert-buffer-no-confirm)

    (define-key god-local-mode-map (kbd "SPC f") #'helm-projectile)  ;;  projectile-find-file
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

    ;;  (define-key god-local-mode-map (kbd "q l") #'windmove-right)
    ;;  (define-key god-local-mode-map (kbd "q h") #'windmove-left)
    ;;  (define-key god-local-mode-map (kbd "q k") #'windmove-up)
    ;;  (define-key god-local-mode-map (kbd "q j") #'windmove-down)
    ;;  (define-key god-local-mode-map (kbd "q v") #'split-window-right)
    ;;  (define-key god-local-mode-map (kbd "q s") #'split-window-below)
    ;;  (define-key god-local-mode-map (kbd "q t") #'transpose-frame)
    ;;  (define-key god-local-mode-map (kbd "q x") #'delete-window)         ;; delete this window
    ;;  (define-key god-local-mode-map (kbd "q d") #'delete-other-windows)  ;; delete other window
    ;;  (define-key god-local-mode-map (kbd "q q") #'other-window)

    (define-key god-local-mode-map (kbd "C-w l") #'windmove-right)
    (define-key god-local-mode-map (kbd "C-w h") #'windmove-left)
    (define-key god-local-mode-map (kbd "C-w k") #'windmove-up)
    (define-key god-local-mode-map (kbd "C-w j") #'windmove-down)
    (define-key god-local-mode-map (kbd "C-w v") #'split-window-right)
    (define-key god-local-mode-map (kbd "C-w s") #'split-window-below)
    (define-key god-local-mode-map (kbd "C-w t") #'transpose-frame)
    (define-key god-local-mode-map (kbd "C-w x") #'delete-window)         ;; delete this window
    (define-key god-local-mode-map (kbd "C-w d") #'delete-other-windows)  ;; delete other window
    (define-key god-local-mode-map (kbd "C-w q") #'other-window)

    (define-key god-local-mode-map (kbd "C-w ]") #'my-enlarge-half-width)
    (define-key god-local-mode-map (kbd "C-w [") #'my-shrink-half-width)
    (define-key god-local-mode-map (kbd "C-w =") #'my-enlarge-half-height)
    (define-key god-local-mode-map (kbd "C-w -") #'my-shrink-half-height)

    (define-key god-local-mode-map (kbd "C-w C-l") #'windmove-right)
    (define-key god-local-mode-map (kbd "C-w C-h") #'windmove-left)
    (define-key god-local-mode-map (kbd "C-w C-k") #'windmove-up)
    (define-key god-local-mode-map (kbd "C-w C-j") #'windmove-down)

    (define-key god-local-mode-map (kbd ", w") #'my-save-buffer)
    (define-key god-local-mode-map (kbd ", b") #'flip-buffer-to-window)
    (define-key god-local-mode-map (kbd ", o") #'cff-find-other-file)    ;; switch between c header/source file

    (define-key god-local-mode-map (kbd ", s") #'emacs-surround)

    (define-key god-local-mode-map (kbd ", r r") #'httpd-start)
    (define-key god-local-mode-map (kbd ", r k") #'httpd-stop)

    (define-key god-local-mode-map (kbd ", ,") #'my-delete-other-windows)
    (define-key god-local-mode-map (kbd ", g d") #'xref-find-definitions)
    (define-key god-local-mode-map (kbd ", g r") #'xref-find-references)
    (define-key god-local-mode-map (kbd ", g R") #'eglot-rename)
    (define-key god-local-mode-map (kbd ", g i") #'eglot-find-implementation)

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

    (define-key map (kbd "M-;") #'avy-goto-word-0)
    (define-key map (kbd "M-o") #'other-window)
    (define-key map (kbd "M-x") #'helm-M-x)

    (define-key map (kbd "C-w l") #'windmove-right)
    (define-key map (kbd "C-w h") #'windmove-left)
    (define-key map (kbd "C-w k") #'windmove-up)
    (define-key map (kbd "C-w j") #'windmove-down)
    (define-key map (kbd "C-w Q") #'delete-window)      ;; delete this window
    (define-key map (kbd "C-w d") #'delete-other-windows)  ;; delete other window
    (define-key map (kbd "C-w v") #'split-window-right)
    (define-key map (kbd "C-w s") #'split-window-below)
    (define-key map (kbd "C-w t") #'transpose-frame)
    (define-key map (kbd "C-w w") #'other-window)

    (define-key map (kbd "C-w ]") #'my-enlarge-half-width)
    (define-key map (kbd "C-w [") #'my-shrink-half-width)
    (define-key map (kbd "C-w =") #'my-enlarge-half-height)
    (define-key map (kbd "C-w -") #'my-shrink-half-height)

    (define-key map (kbd "C-w C-l") #'windmove-right)
    (define-key map (kbd "C-w C-h") #'windmove-left)
    (define-key map (kbd "C-w C-k") #'windmove-up)
    (define-key map (kbd "C-w C-j") #'windmove-down)

    (define-key map (kbd "C-w ,") #'flip-buffer-to-window)

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
              ("C-c i" . clang-format-region)
              ("C-c f" . clang-format-buffer)
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



(defun my-process()
  (interactive)
  (if (bound-and-true-p selected-region-active-mode)
      (progn
        ;;(message "is active mode")
        (my-disable-eglot-highlight)
        (if (bound-and-true-p my-god-mode-is-active-flag)
            (progn
              ;; (message "is god-local-mode")
              (define-key selected-keymap (kbd "v") #'keyboard-quit)
              (define-key selected-keymap (kbd "d") #'kill-region)
              (define-key selected-keymap (kbd "x") #'kill-region)
              (define-key selected-keymap (kbd "i p") #'er/mark-text-paragraph)
              (define-key selected-keymap (kbd "i w") #'er/mark-symbol))
          (progn
            ;; (message "is not god-local-mode")
            (define-key selected-keymap (kbd "v") nil)
            (define-key selected-keymap (kbd "d") nil)
            (define-key selected-keymap (kbd "x") nil)
            (define-key selected-keymap (kbd "i p") nil)
            (define-key selected-keymap (kbd "i w") nil))
          ))
    (progn
      (message "is deactive mode")
      (my-enable-eglot-highlight))
    )
  )


(setq selected-region-active-mode-hook #'my-process)


