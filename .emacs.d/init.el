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


(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))


;; eshell with colors
;; SEE https://emacs.stackexchange.com/questions/51027/missing-color-support-for-exa-in-eshell
(setq comint-terminfo-terminal "dumb-emacs-ansi")

(let* ((terminfo-file (format "~/.terminfo/%s.ti" comint-terminfo-terminal))
        (default-directory (file-name-directory terminfo-file)))
  (unless (file-exists-p terminfo-file)
    (make-directory default-directory t)
    (with-temp-buffer
      (insert
        "dumb-emacs-ansi|Emacs dumb terminal with ANSI color codes,
    am,
    colors#8, it#8, ncv#13, pairs#64,
    bold=\\E[1m, cud1=^J, ht=^I, ind=^J, op=\\E[39;49m,
    ritm=\\E[23m, rmul=\\E[24m, setab=\\E[4%p1%dm,
    setaf=\\E[3%p1%dm, sgr0=\\E[m, sitm=\\E[3m, smul=\\E[4m,")
      (write-file terminfo-file)))
  (unless (file-exists-p (concat default-directory "d/" comint-terminfo-terminal))
    (start-process "*tic process*" "*Messages*" "tic"
      (expand-file-name terminfo-file))))

(add-hook 'eshell-mode-hook #'(lambda ()
                                (setenv "TERM" comint-terminfo-terminal)
                                (setenv "PAGER" "cat")))


(use-package benchmark-init
  :ensure t
  :config ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))


(require 'cl)
(require 's)



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



(require 'my-utils)




;; don't need it!!!
(electric-indent-mode -1)


(require 'init-god)



(require 'init-projectile)


(require 'init-treesit)


(require 'init-slime)


(require 'init-theme)




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





;;;;;; catch ESC in terminal(-nw) ;;;;;;;;;;;;
(defvar personal/fast-keyseq-timeout 1)
(defun personal/-tty-ESC-filter (map)
  (if (and (equal (this-single-command-keys) [?\e])
        (sit-for (/ personal/fast-keyseq-timeout 1000.0)))
    [escape]
    map))
(defun personal/-lookup-key (map key)
  (catch 'found
    (map-keymap (lambda (k b)
                  (if (equal key k)
                    (throw 'found b)))
      map)))
(defun personal/catch-tty-ESC ()
  "Setup key mappings of current terminal to turn a tty's ESC into `escape'."
  (when (memq (terminal-live-p (frame-terminal)) '(t pc))
    (let ((esc-binding (personal/-lookup-key input-decode-map ?\e)))
      (define-key input-decode-map [?\e] `(menu-item "" ,esc-binding :filter personal/-tty-ESC-filter)))))
(personal/catch-tty-ESC)



(require 'term-cursor)
(global-term-cursor-mode 1)



(setq visible-bell t)


(setq ring-bell-function #'ignore)


(set-default 'truncate-lines t)


;; compile log with colors
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)


(defun bury-compile-buffer-if-successful (buffer string)
  "Bury a compilation buffer if succeeded without warnings "
  (when (and
          (buffer-live-p buffer)
          (string-match "compilation" (buffer-name buffer))
          (string-match "finished" string)
          (not
            (with-current-buffer buffer
              (goto-char (point-min))
              (search-forward "warning" nil t))))
    (run-with-timer 1 nil
      (lambda (buf)
        (delete-windows-on buf)
        (bury-buffer buf)
        ;; (switch-to-prev-buffer (get-buffer-window buf) 'kill)
        )
      buffer)))
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)


(use-package expand-region :bind (("M-i" . 'er/expand-region)))


(advice-add 'er/expand-region :before (lambda (&rest r) (my-remove-all-highlight)))

(advice-add 'er/mark-inside-pairs :before (lambda (&rest r) (my-remove-all-highlight)))



(toggle-truncate-lines t)


(require 'init-imenu)


  ;;;; custom highlight for treemacs current line
(defface my-highlight-font-chars-face
  '((t (:foreground "green" :weight bold)))
  "")



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ahs-definition-face ((t (:inherit ahs-plugin-default-face))))
 '(ahs-definition-face-unfocused ((t (:inherit ahs-plugin-default-face))))
 '(ahs-face ((t (:inherit ahs-plugin-default-face))))
 '(ahs-plugin-default-face ((t (:background "#59dcb7" :foreground "Black"))))
 '(centaur-tabs-selected ((t (:inherit default :foreground "black" :background "#FFC44C" :weight normal))))
 '(centaur-tabs-selected-modified ((t (:inherit centaur-tabs-selected :foreground "black"))))
 '(centaur-tabs-unselected ((t (:foreground "#969696" :background "#262830"))))
 '(centaur-tabs-unselected-modified ((t (:inherit centaur-tabs-unselected :foreground "white"))))
 '(company-preview-common ((t (:inherit font-lock-comment :foreground "white" :weight normal))))
 '(corfu-default ((t (:inherit default))))
 '(counsel-outline-default ((t (:inherit green))))
 '(deadgrep-filename-face ((t (:inherit bold :foreground "green"))))
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
 '(eglot-highlight-symbol-face ((t (:inherit highlight))))
 '(eldoc-box-body ((t (:inherit default))))
 '(flymake-diagnostic-at-point-posframe-background-face ((t (:background "dark magenta"))))
 '(flymake-error ((t (:foreground "DeepPink" :underline (:color foreground-color :style line :position line)))))
 '(flymake-error-echo ((t nil)))
 '(flymake-warning ((t (weight normal))))
 '(flymake-warning-echo ((t nil)))
 '(helm-selection ((t (:foreground "white" :background "purple"))))
 '(help-argument-name ((t (:inherit italic :underline nil))))
 '(highlight ((t (:background "#7ED9B9" :foreground "black" :weight normal))))
 '(hl-line ((t (:extend t :background "#33485e" :underline nil))))
 '(hydra-face-red ((t (:foreground "chocolate" :weight bold))))
 '(isearch ((t (:background "orange1" :foreground "black" :weight normal :inverse-video nil))))
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
 '(minibuffer-prompt ((t (:inherit default :foreground "white" :background "#1E2127" :weight normal))))
 '(mode-line ((t (:background "#262831" :foreground "#7AA2F7" :overline "#374250" :box nil))))
 '(mode-line-inactive ((t (:background "#262831" :foreground "#7AA2F7" :overline "#374250" :box nil))))
 '(next-error ((t (:foreground "#000000" :background "#00ff00"))))
 '(region ((t (:inverse-video t :foreground nil :background nil))))
 '(show-paren-match ((t (:foreground "red" :background "green" :weight bold))))
 '(symbol-overlay-default-face ((t (:inherit my-highlight-font-chars-face))))
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
 '(whitespace-trailing ((t (:background "black" :foreground "#42546A" :weight bold))))
 '(widget-field ((t (:extend t :background "gray" :foreground "black"))))
 '(window-divider ((t (:foreground "green"))))
 '(xref-match ((t (:inherit region))))
 '(yas-field-highlight-face ((t (:foreground "#000000" :background "#7fdc59" :weight normal)))))


;; (set-face-attribute 'region nil :inverse-video 't)



;; (global-font-lock-mode -1)


(require 'my-highlight-current-line)



(defun my-remove-all-highlight ()
  (interactive)
  (remove-all-highlight)
  (my-disable-paren-highlight)
  (my-disable-eglot-highlight))

(defun my-enable-all-highlight ()
  (interactive)
  (my-enable-paren-highlight)
  (my-enable-eglot-highlight))


(defun my-recenter-scroll-to-top ()
  (interactive)
  (recenter-top-bottom 1)
  (setq recenter-last-op nil))


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




(require 'init-mouse)



;; quit xref buffer after enter
(with-eval-after-load 'xref
  (define-key
    xref--xref-buffer-mode-map (kbd "o")
    #'
    (lambda ()
      (interactive)
      (xref-goto-xref t)))
  ;; directly open it when there is only one candidate.
  ;; (setq xref-show-xrefs-function #'xref-show-definitions-buffer)
  ;; (setq xref-show-xrefs-function #'xref-show-definitions-buffer-at-bottom)

  ;; (add-to-list 'xref-after-return-hook 'my-recenter-scroll-to-top)
  ;; (setq xref-after-jump-hook (delete 'recenter xref-after-jump-hook))
  ;; (add-to-list 'xref-after-jump-hook 'my-recenter-scroll-to-top)
  )

(defun ivy-xref-call-or-done ()
  (interactive)
  (let
    (
      orig-point
      orig-buffer
      new-point
      new-buffer)
    (with-ivy-window
      (setq
        orig-point (point)
        orig-buffer (current-buffer)))

    (ivy-call)

    (with-ivy-window
      (setq
        new-point (point)
        new-buffer (current-buffer)))

    (when (and (eq new-point orig-point) (eq new-buffer orig-buffer))
      (ivy-done))))

(use-package ivy-xref
  :ensure t
  :after (ivy xref)
  :init
  (setq xref-show-definitions-function #'ivy-xref-show-defs)
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
  :bind
  (:map
    ivy-minibuffer-map
    ("C-l" . ivy-xref-call-or-done)
    ("M-l" . ivy-call-and-recenter)))


(with-eval-after-load 'pulse
  ;;   ;; (set-face-attribute 'pulse-highlight-face nil :foreground 'unspecified :background "#1f4670")
  ;;   ;; (set-face-attribute 'pulse-highlight-face nil :foreground 'unspecified :background 'unspecified :inverse-video t)
  ;;   ;; (set-face-attribute 'pulse-highlight-start-face nil :foreground "green" :background "black")
  (setq pulse-delay 0.01) ;; pulse fast!
  )


(use-package
  format-all
  :commands format-all-mode
  :hook (prog-mode . format-all-mode)
  ;;   :config
  ;;   (setq-default format-all-formatters
  ;;                 '(("C"     (astyle "--mode=c"))
  ;;                   ("Shell" (shfmt "-i" "4" "-ci"))))
  )





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


;; book-mode break isearch echo area!
;; (require 'book-mode)


(defun my-joindirs (root &rest dirs)
  "Joins a series of directories together, like Python's os.path.join,
  (dotemacs-joindirs \"/tmp\" \"a\" \"b\" \"c\") => /tmp/a/b/c"
  (if (not dirs)
    root
    (apply 'joindirs (expand-file-name (car dirs) root) (cdr dirs))))


;; company-mode
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'before-save-hook 'company-cancel)

;; company-posframe-mode
;  (require 'company-posframe)
;  (company-posframe-mode 1)

;; http://company-mode.github.io/manual/Getting-Started.html#Initial-Setup
(with-eval-after-load 'company
  (define-key
    company-active-map
    (kbd "<tab>")
    #'company-select-next-if-tooltip-visible-or-complete-selection)
  (define-key
    company-active-map
    (kbd "<backtab>")
    #'company-select-previous-or-abort)
  (define-key
    company-active-map
    (kbd "RET")
    #'company-complete-selection)

  (global-set-key (kbd "s-r") #'company-yasnippet))
;; Use (kbd "TAB") (or use (kbd "<tab>"), if you want to distinguish C-i from the <tab> key)


(use-package transpose-frame :defer t)


(use-package
  yasnippet
  :config
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook
    'yas-before-expand-snippet-hook
    'my-disable-eglot-highlight)
  (add-hook 'yas-after-exit-snippet-hook 'my-enable-eglot-highlight))


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
    '(blamer paredit slime-company symbol-overlay elisp-autofmt corfu-terminal py-autopep8 popon format-all apheleia ivy-xref jsonrpc imenu-list treesit-auto highlight-numbers modus-themes nano-theme vs-dark-theme treemacs-all-the-icons centaur-tabs bazel general swift-mode color-theme-sanityinc-tomorrow lispy markdown-mode vscode-dark-plus-theme diminish eglot elisp-def elisp-refs slime elisp-slime-nav leetcode srefactor ivy-posframe counsel ivy popup-switcher popwin beacon rjsx-mode typescript-mode impatient-mode reformatter auto-dim-other-buffers atom-one-dark-theme jdecomp smart-jump ansible moe-theme selected benchmark-init with-proxy valign markdown-toc markdownfmt disable-mouse rainbow-delimiters key-chord google-c-style phi-search switch-buffer-functions yasnippet highlight-parentheses undo-tree nimbus-theme challenger-deep-theme afternoon-theme smooth-scrolling project There are no known projectsile-mode smart-mode-line cyberpunk-theme lsp-python-ms protobuf-mode vue-mode xclip mwim ripgrep neotree easy-kill helm-rg))
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
(setq whitespace-display-mappings '((tab-mark ?\t [?\x203a ?\t] [?\\ ?\t]) ; tab
                                     (newline-mark ?\n [?\x203a ?\n] [?\\ ?\n])))
(setq-default tab-width 4)


(add-hook 'before-save-hook #'delete-trailing-whitespace)


(set-face-attribute 'whitespace-tab nil
  :background (face-background 'default)
  :foreground "#627D9D")


(use-package iedit :defer t :bind (("C-M-'" . iedit-mode)))


;; render like github
(defun markdown-html-github (buffer)
  (princ
    (with-current-buffer buffer
      (format
        "<!DOCTYPE html><html><script src=\"https://cdnjs.cloudflare.com/ajax/libs/he/1.1.1/he.js\"></script><link rel=\"stylesheet\" href=\"https://assets-cdn.github.com/assets/github-e6bb18b320358b77abe040d2eb46b547.css\"><link rel=\"stylesheet\" href=\"https://assets-cdn.github.com/assets/frameworks-95aff0b550d3fe338b645a4deebdcb1b.css\"><title>Impatient Markdown</title><div id=\"markdown-content\" style=\"display:none\">%s</div><div class=\"markdown-body\" style=\"max-width:968px;margin:0 auto;\"></div><script>fetch('https://api.github.com/markdown', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ \"text\": document.getElementById('markdown-content').innerHTML, \"mode\": \"gfm\", \"context\": \"knit-pk/homepage-nuxtjs\"}) }).then(response => response.text()).then(response => {document.querySelector('.markdown-body').innerHTML = he.decode(response)}).then(() => { fetch(\"https://gist.githubusercontent.com/FieryCod/b6938b29531b6ec72de25c76fa978b2c/raw/\").then(response => response.text()).then(eval)});</script></html>"
        (buffer-substring-no-properties (point-min) (point-max))))
    (current-buffer)))

(defun markdown-html (buffer)
  (princ
    (with-current-buffer buffer
      (format
        "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>"
        (buffer-substring-no-properties (point-min) (point-max))))
    (current-buffer)))

(use-package impatient-mode
  :config
  (add-hook
    'markdown-mode-hook
    #'
    (lambda ()
      (impatient-mode 1)
      (imp-set-user-filter 'markdown-html-github))))


(use-package ace-window
  :ensure t
  ;; must ensure, treemacs depend on it
  :delight
  :config
  (ace-window-display-mode 1)
  (setq aw-keys '(?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9 ?0))
  :bind (("M-o" . #'ace-window))
  )

;; alternatively, use Meta-<left> Meta-<right> to move cursor to window
;; for iTerms2 user, disable alt-> alt-< to send alt-f alt-b in `profile->keys`
(windmove-default-keybindings 'meta)


(require 'init-centaur)



(use-package blamer
  :defer t
  :bind (("s-i" . blamer-show-commit-info)
          ("C-c i" . blamer-show-posframe-commit-info))
  :defer 20
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                  :background nil
                  :height 140
                  :italic t)))
  ;; :config
  ;; (global-blamer-mode 1)
  )



(use-package py-autopep8
  :defer t
  :init
  :config (setq py-autopep8-options '("--max-line-length=100"))
  :hook
  (python-mode . py-autopep8-mode)
  (python-ts-mode . py-autopep8-mode))


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
  (mapc 'kill-buffer (delq
                       (current-buffer)
                       (remove-if-not 'buffer-file-name (buffer-list)))) ;; this keep * buffers alive
  (if (bound-and-true-p centaur-tabs-mode)
    (centaur-tabs-kill-other-buffers-in-current-group)))

;; delete all other buffers, only keep current one.
(defun my-only-current-buffer-include-specials ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq
                       (current-buffer)
                       (buffer-list))) ;; this destroy * buffers too
  (if (bound-and-true-p centaur-tabs-mode)
    (centaur-tabs-kill-other-buffers-in-current-group)))



(defun my-cmake-mode-hook ()
  (setq cmake-tab-width 4))

(add-hook 'cmake-mode-hook 'my-cmake-mode-hook)


(defun my-elisp-mode-hook ()
  (setq indent-tabs-mode nil)
  (setq lisp-indent-offset 2))

(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-hook)
(add-hook 'lisp-mode-hook 'my-elisp-mode-hook)


(require 'init-smartparens)


(unless (directory-empty-p (expand-file-name "~/.emacs.d/lisp/blink-search"))
  (setq blink-search-history-path
    (expand-file-name (concat user-emacs-directory ".local/blink-search/history.txt")))
  (setq blink-search-db-path
    (expand-file-name (concat user-emacs-directory ".local/blink-search/blink-search.db")))
  (require 'blink-search))


(require 'init-ivy)


;; (use-package
;;   flymake-posframe
;;   :load-path "~/.emacs.d/lisp/flymake-posframe.el"
;;   :hook (flymake-mode . flymake-posframe-mode))


(use-package flymake-diagnostic-at-point
  :load-path "~/.emacs.d/lisp/flymake-diagnostic-at-point.el"
  :after flymake
  :config
  (setq flymake-start-syntax-check-on-find-file nil)
  (setq flymake-diagnostic-at-point-error-prefix " > ")
  (setq flymake-diagnostic-at-point-display-diagnostic-function
    'flymake-diagnostic-at-point-display-posframe)
  (unless (display-graphic-p)
    (setq flymake-diagnostic-at-point-display-diagnostic-function
      'flymake-diagnostic-at-point-display-minibuffer))
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))


;;
;; deprecated, use flymake-posframe.
;;
;; (use-package flymake-diagnostic-at-point
;;   :after flymake
;;   :config
;;   (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))


(defun my-M-x ()
  (interactive)
  (counsel-M-x))

(defun my-occur ()
  (interactive)
  (counsel-grep))

(defun my-rg-at-point ()
  (interactive)
  (counsel-rg))

(defun my-find-files ()
  (interactive)
  (counsel-find-file))

(defun my-mark-ring ()
  (interactive)
  (counsel-mark-ring))



(advice-add 'my-M-x :before (lambda (&rest r) (refresh-current-mode))
  ; convenient name for identifying or removing this advice later
  '((name . "my-god-mode-before-m-x")))

(advice-add 'my-mark-ring :after (lambda (&rest r) (recenter))
  ; convenient name for identifying or removing this advice later
  '((name . "recenter-after-mark-ring")))


(delete-selection-mode 1)


(add-hook 'org-mode-hook #'valign-mode)

(add-hook 'markdown-mode-hook #'valign-mode)

(column-number-mode 1)

;; (add-hook 'markdown-mode-hook #'prog-mode)


(require 'init-scroll-keys)


(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))




(defun my-escape-key ()
  (interactive)
  (refresh-current-mode)
  (when isearch-mode (isearch-abort) (isearch-abort))  ;; must double abort
  (when (my-god-this-is-normal-editor-buffer (buffer-name))
    (when (bound-and-true-p multiple-cursors-mode) (multiple-cursors-mode -1))
    (when (bound-and-true-p iedit-mode) (iedit-done)) ;; exit iedit mode, if needed.
    (ignore-errors (company-cancel))
    (ignore-errors (remove-all-highlight)))
  (ignore-errors (flymake-start)) ;; but show errors
  (ignore-errors (blink-search-quit))
  (keyboard-quit)
  (keyboard-quit-context+) ;; from custom-util-funcs.el
  )

;; (global-set-key [remap keyboard-quit] #'my-escape-key)

(global-set-key (kbd "<escape>") #'my-escape-key)
;; (define-key helm-map (kbd "<escape>") #'helm-keyboard-quit)
(define-key minibuffer-local-map (kbd "<escape>") #'minibuffer-keyboard-quit)


;; must be set as global
(global-set-key (kbd "C-S-k") #'my-delete-to-beginning)
(global-set-key (kbd "C-k") #'my-delete-to-end)
(global-set-key (kbd "C-j") #'save-buffer)
(global-set-key (kbd "<RET>") #'newline-and-indent)


(when (display-graphic-p)
  (global-set-key [escape] 'my-escape-key)
  (define-key input-decode-map [?\C-\[] (kbd "<C-[>"))
  (global-set-key (kbd "<C-[>") 'my-escape-key))


(setq smex-save-file (expand-file-name "~/.emacs.d/.local/smex-items.cache"))





(defun my-hs-toggle-all ()
  "If anything isn't hidden, run `hs-hide-all', else run `hs-show-all'."
  (interactive)
  (hs-minor-mode 1)
  (let ((starting-ov-count
          (length (overlays-in (point-min) (point-max)))))
    (if (derived-mode-p 'c++-mode)
      (save-excursion
        (goto-char (point-min))
        (re-search-forward "namespace.*?{" nil t)
        (next-line)
        (hs-hide-level 1))
      (hs-hide-all))
    (when (equal
            (length (overlays-in (point-min) (point-max)))
            starting-ov-count)
      (hs-show-all)
      (recenter))))

(defun my-hs-toggle-hiding ()
  (interactive)
  (hs-minor-mode 1)
  (if (hs-already-hidden-p)
    (hs-show-block)
    (hs-hide-block)))

(defun my-hide-all ()
  (interactive)
  (hs-minor-mode 1)
  (hs-hide-all))

;; (add-hook 'prog-mode-hook 'my-hide-all)




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


(require 'init-avy)


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





(defvar my-code-intelligence 't
  "enable by default")


(defun my-disable-eglot-highlight ()
  (interactive)
  (ignore-errors
    (setq eglot-ignored-server-capabilities
      (add-to-list 'eglot-ignored-server-capabilities ':documentHighlightProvider))
    (set-face-attribute 'eglot-highlight-symbol-face nil :inherit nil)
    (set-face-attribute 'flymake-error nil :underline 'unspecified :foreground 'unspecified :background 'unspecified)
    ;; (flymake-mode-off)
    ))

(defun my-enable-eglot-highlight ()
  (interactive)
  (ignore-errors
    (setq eglot-ignored-server-capabilities
      (delete ':documentHighlightProvider eglot-ignored-server-capabilities))
    (set-face-attribute 'eglot-highlight-symbol-face nil :inherit 'my-highlight-font-chars-face)
    (set-face-attribute 'flymake-error nil :underline t :foreground "DeepPink" :background (face-background 'default))
    ;; (flymake-mode-on)
    ))


(defun my-enable-paren-highlight ()
  (interactive)
  (ignore-errors
    (set-face-attribute 'show-paren-match nil :foreground "red" :weight 'bold)))

(defun my-disable-paren-highlight ()
  (interactive)
  (ignore-errors
    (set-face-attribute 'show-paren-match nil :foreground 'unspecified :weight 'bold)))

(defun my-enable-symbol-overlay-highlight ()
  (interactive)
  (when (derived-mode-p 'emacs-lisp-mode)
    (ignore-errors
      (symbol-overlay-mode 1))))


(defun my-disable-symbol-overlay-highlight ()
  (interactive)
  (ignore-errors
    (symbol-overlay-mode 0)))


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


(require 'init-emacs-lispy)


(setq hl-line-inhibit-highlighting-for-modes
  '(dired-mode deadgrep-mode deadgrep-edit-mode treemacs-mode))

(global-hl-line-mode 0)


(set-face-background 'line-number (face-background 'default))
(set-face-background 'line-number-current-line (face-background 'hl-line))

(require 'init-modeline)


(setq blink-cursor-blinks 0)
(setq blink-cursor-interval 0.3)


(add-hook 'god-mode-enabled-hook 'my-god-mode-update-cursor-type)

(add-hook 'god-mode-disabled-hook 'my-god-mode-update-cursor-type)


(toggle-truncate-lines t)

(global-auto-revert-mode 1)

;;;  treats underscores as part of words
(superword-mode 1)



(use-package all-the-icons
  :config
  (setq all-the-icons-scale-factor 1.0)
  (setq all-the-icons-default-adjust 0.0))


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
