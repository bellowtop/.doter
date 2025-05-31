(require 'god-mode)

(setq god-exempt-major-modes nil)
(setq god-exempt-predicates nil)
(setq god-mode-alist '((nil . "C-") ("r" . "M-") ("R" . "C-M-")))




;; special-buffers are not affected by god-mode bindings, but affected by my-special-buffer-keys-minor-mode-map
(setq special-buffer-modes (list "dired-mode" "ibuffer-mode" "special-mode"))
(setq special-buffers (list
                        "*Pos-Frame-Read*"
                        "*Treemacs"
                        "*Messages*"
                        "*compilation*"
                        "HELLO"
                        "*Ibuffer*"
                        "*deadgrep"
                        "*xref"
                        "*Buffer"
                        "*Annotate"
                        "*Completions*"
                        "*vc-diff*"
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
                        "*Flymake"
                        "*ansi-term*"
                        "*fzf*"
                        "*Ilist*"
                        "*NeoTree*"))

;; legendary-buffers are not affected by god-mode AND my-special-buffer-keys-minor-mode-map
(setq legendary-buffers (list
                          "*this-buffer-is-left-alone-without-god-mode-at-all"
                          "*Minibuf"
                          "*Compile"
                          "*EGLOT"
                          "*terminal*"
                          "*vterm"
                          "*emacs"
                          "*eshell*"
                          "*blink-search"
                          "*ripgrep-search*"
                          "*blink search"
                          "*shell*"
                          "*dashboard*"
                          "*slime"
                          "*sldb"
                          "*leetcode"
                          "magit"
                          "git-rebase-todo"
                          "*Backtrace*"
                          "menu"
                          "*ielm*"
                          "*Gofmt"
                          "*slime-repl"
                          "*Customize"))

(setq legendary-modes (list
                        "*this-buffer-is-left-alone-without-god-mode-at-all"
                        "cfrs-input-mode"
                        "fundamental-mode"
                        "help-mode"
                        "lisp-mode"
                        "slime-mode"
                        "minibuffer-mode"
                        "inferior-python-mode"
                        "deadgrep-edit-mode"))





(defun my-god-this-is-special-buffer (bufname)
  (interactive)
  (let ((this-buffer-name (string-trim bufname))
         (this-buffer-mode (symbol-name (buffer-mode bufname))))
    (or
      (seq-filter
        (lambda (n) (string-prefix-p n this-buffer-name))
        special-buffers)
      (seq-filter
        (lambda (n) (string-prefix-p n this-buffer-mode))
        special-buffer-modes))))

(defun* my-god-this-is-legendary-buffer (bufname)
  (interactive)
  ;; (message "buffer-mode type is %s" (type-of (buffer-mode bufname))) ==> symbol
  ;;;; use symbol-name convert symbol to string; And for the reverse, (intern "some-string") to get symbol
  (let ((this-buffer-name (string-trim bufname))
         (this-buffer-mode (symbol-name (buffer-mode bufname))))
    ;; (message "this-buffer-name %s" this-buffer-name)
    ;; (message "this-buffer-mode %s" this-buffer-mode)
    (or
      (seq-filter
        (lambda (n) (string-prefix-p n this-buffer-name))
        legendary-buffers)
      (seq-filter
        (lambda (n) (string-prefix-p n this-buffer-mode))
        legendary-modes))))


(defun my-god-this-is-normal-editor-buffer (bufname)
  (interactive)
  (not
    (or (my-god-this-is-special-buffer bufname)
      (my-god-this-is-legendary-buffer bufname))))

(defun my-god-should-enable-hi-line-mode ()
  (interactive)
  (not (bound-and-true-p smerge-mode))
  )

(defun my-god-should-enable-line-number-mode()
  t
  )


(setq should-not-display-dark-background-modes (list
                                                 "dired-mode"
                                                 "vterm-mode"
                                                 "minibuffer-mode"
                                                 "dashboard-mode"
                                                 ))


(defun my-god-this-is-dark-background-buffer (bufname)
  (interactive)
  (let ((this-buffer-name (string-trim bufname))
         (this-buffer-mode (symbol-name (buffer-mode bufname))))
    (and
      (eq buffer-read-only t)
      (not (seq-filter
             (lambda (n) (string-prefix-p n this-buffer-mode))
             should-not-display-dark-background-modes))
      (not (derived-mode-p 'prog-mode))
      )))


(setq my-god-mode-is-active-flag nil)

(defun* refresh-current-mode ()
  (interactive)
  (if (my-god-this-is-dark-background-buffer (buffer-name))
    (set (make-local-variable 'face-remapping-alist) `((default :background ,darker-window-bg-color)
                                                        (fringe :background ,darker-window-bg-color)
                                                        (line-number :background ,darker-window-bg-color :foreground "#627d9d")
                                                        (line-number-current-line :background ,darker-window-bg-color :foreground "#627d9d")
                                                        ))
    (set (make-local-variable 'face-remapping-alist) `((fringe :background ,(face-background 'default))
                                                        )))
  (cond
    ((my-god-this-is-legendary-buffer (buffer-name))
      ;; (message "%s is legendary buffer" (buffer-name))
      (god-local-mode 0)
      (my-keys-minor-mode 0)
      (my-special-buffer-keys-minor-mode 0))
    ((my-god-this-is-special-buffer (buffer-name))
      ;; (message "%s is special buffer" (buffer-name))
      (god-local-mode 0)
      (my-keys-minor-mode 0)
      (my-special-buffer-keys-minor-mode 1))
    (t
      ;; (message "%s not a special buffer" (buffer-name))
      (god-local-mode 1) ;; start local mode
      (my-keys-minor-mode 1)
      (setq my-god-mode-is-active-flag t)
      (my-special-buffer-keys-minor-mode 0))
    ))

(add-hook 'find-file-hook 'refresh-current-mode)

(defun my-quit-god-mode ()
  (interactive)
  (god-local-mode 0)
  (setq my-god-mode-is-active-flag nil))

(defun my-toggle-god-mode ()
  (interactive)
  (if (bound-and-true-p god-local-mode)
    (my-quit-god-mode)
    (refresh-current-mode)))




(defun my-god-mode-with-switch-any-buffer (prev curr)
  (cl-assert (eq curr (current-buffer))) ;; Always t
  ;; (message "%S -> %S -> %S" prev curr (string-trim (buffer-name curr)))
  (refresh-current-mode))

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
  (indent-for-tab-command)
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
(define-key god-mode-isearch-map (kbd "j") #'(lambda ()
                                               (interactive)
                                               (isearch-exit)
                                               (next-line)))
(define-key god-mode-isearch-map (kbd "k") #'(lambda ()
                                               (interactive)
                                               (isearch-exit)
                                               (previous-line)))
(define-key god-mode-isearch-map (kbd "h") #'(lambda ()
                                               (interactive)
                                               (isearch-exit)
                                               (my-forward-char-no-cross-line)))
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
    (let ((selection (buffer-substring-no-properties (mark) (point)))
           (case-fold-search 'default))
      (message "search the marked region")
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





(defun my-god-mode-update-cursor-type ()
  ;; (setq cursor-type (if (bound-and-true-p god-local-mode) 'box 'bar))
  (setq cursor-type (if (display-graphic-p) 'box 'box))
  (set-cursor-color (if (bound-and-true-p god-local-mode) "red" "red"))
  (blink-cursor-mode (if (bound-and-true-p god-local-mode) -1 -1))
  (sp--maybe-init)
  (if (bound-and-true-p god-local-mode)
    (progn
      ;; (set-face-attribute 'hl-line nil :background (face-background 'default))
      (set-face-background 'hl-line hl-line-bg-color)
      ;; reset
      (when (my-god-this-is-normal-editor-buffer (buffer-name))
        (if (my-god-should-enable-hi-line-mode) (hl-line-mode 1) (hl-line-mode 0))
        (when (my-god-should-enable-line-number-mode)
          (display-line-numbers-mode 1)
          ;; (set-face-foreground 'line-number-current-line "gray33")
           ;;;;  (set-face-attribute 'line-number-current-line nil
           ;;;;    :foreground (or (face-foreground 'line-number) 'unspecified)
           ;;;;    :background (or (face-background 'line-number) 'unspecified))
          )
        )
      ;; (when (display-graphic-p)
      ;;  (set-face-attribute 'window-divider nil :foreground window-divider-right-color)
      ;;  (set-face-attribute 'window-divider-last-pixel nil :foreground window-divider-right-color)
      ;;  (set-face-attribute 'window-divider-first-pixel nil :foreground "green")
      ;;  ;; (set-face-attribute 'mode-line nil          :background "#7AA2F7" :foreground "#262831" :overline "#374250"   :box nil) ;; draw a line above mode-line
      ;;  ;; (set-face-attribute 'mode-line-inactive nil :background "#262831" :foreground "#7AA2F7" :overline "#374250"  :box nil)
      ;;  ;; (set-face-attribute 'mode-line-buffer-id nil :distant-foreground "#262831" :foreground "#7AA2F7")
      ;;)
      ;; (unless (display-graphic-p)
      ;;   (set-face-attribute 'mode-line          nil :foreground "black" :background "#00AFFF")
      ;;   (set-face-attribute 'mode-line-inactive nil :foreground "#00AFFF" :background "black")
      ;;   )
      ;; (setq cursor-type 'bar)
      ;; (set-cursor-color "red")
      ;; (set-face-attribute 'mode-line nil :box '(:line-width 1 :color "gray" ))
      ;; (set-face-attribute 'mode-line nil :background "#38424B")
      ;; (set-face-foreground 'vertical-border "#353535")
      (set-face-foreground 'tab-bar-tab "#FFFFFF")
      (set-face-background 'tab-bar-tab nil)

      ;; (set-face-foreground 'vertical-border "#374250")
      )
    (progn
      ;; (set-face-attribute 'hl-line nil :background (face-background 'default))
      ;; (set-face-background 'hl-line hl-line-bg-color)
      (when (my-god-this-is-normal-editor-buffer (buffer-name))
        ;; (set-face-foreground 'vertical-border "#7fdc59")
        (set-face-foreground 'tab-bar-tab "black")
        (set-face-background 'tab-bar-tab "yellow")
        (when (my-god-should-enable-line-number-mode)
          (display-line-numbers-mode 1)
          ;; (set-face-foreground 'line-number-current-line "#7fdc59")
          ;;;;; (set-face-attribute 'line-number-current-line nil :foreground "black" :background "#7fdc59")
          )
        )
      ;; (when (display-graphic-p)
      ;;   (set-face-attribute 'window-divider nil :foreground window-divider-right-color)
      ;;   (set-face-attribute 'window-divider-last-pixel nil :foreground window-divider-right-color)
      ;;   (set-face-attribute 'window-divider-first-pixel nil :foreground "green")
      ;;   ;; (set-face-attribute 'mode-line nil          :background "#7fdc59" :foreground "black" :overline "green"   :box nil) ;; draw a line above mode-line
      ;;   ;; (set-face-attribute 'mode-line-inactive nil :background "#262831" :foreground "#7AA2F7" :overline "#374250"  :box nil)
      ;;   ;; (set-face-attribute 'mode-line-buffer-id nil :distant-foreground "#7AA2F7" :foreground "black")
      ;;   )
      ;; (unless (display-graphic-p)
      ;;   (set-face-attribute 'mode-line          nil :foreground "black" :background "cyan")
      ;;   (set-face-attribute 'mode-line-inactive nil :foreground "#00AFFF" :background "black")
      ;;   )
      ;; (setq cursor-type 'bar)
      ;; (set-cursor-color "red")
      ;; (set-face-attribute 'mode-line nil :box '(:line-width 1 :color "green" ))
      ;;(set-face-attribute 'mode-line nil :background "#38424B")
      ;; (set-face-foreground 'vertical-border window-divider-color)
      )
    ))



(add-hook 'god-mode-enabled-hook 'my-god-mode-update-cursor-type)
(add-hook 'god-mode-disabled-hook 'my-god-mode-update-cursor-type)


(provide 'init-god)
