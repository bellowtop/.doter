(eval-after-load "dired"
  '(progn
     (define-prefix-command 'my-god-mode-leader-key-1)
     (define-key dired-mode-map (kbd "SPC") 'my-god-mode-leader-key-1)
     (define-key dired-mode-map (kbd "SPC b") #'switch-to-buffer)
     (define-key dired-mode-map (kbd "SPC B") #'ibuffer)
     (define-key dired-mode-map (kbd "SPC k") #'kill-this-buffer)
     (define-key dired-mode-map (kbd "SPC K") #'my-only-current-buffer)
     (define-key dired-mode-map (kbd "SPC M-k") #'my-only-current-buffer-include-specials)
     (define-key dired-mode-map (kbd "SPC f") #'my-projectile-find-file)
     (define-key dired-mode-map (kbd "SPC p") #'my-find-files)
     (define-key dired-mode-map (kbd "SPC m") #'deadgrep)
     (define-key dired-mode-map (kbd "SPC L") #'display-line-numbers-mode)
     (define-key dired-mode-map (kbd "SPC x") #'delete-window)   ;; delete this window
     ))



(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-x") #'my-M-x)
    (define-key map (kbd "C-M-.") #'xref-find-definitions-other-window )

    (define-key map (kbd "s-d") #'my-mc/mark-next-like-this)

    ;; (define-key map (kbd "C-M-f") #'projectile-find-file)
    ;; (define-key map (kbd "C-M-b") #'switch-to-buffer)
    ;; (define-key map (kbd "C-x C-b") #'switch-to-buffer)

    (define-key map (kbd "C-h .") #'eldoc-doc-buffer)
    (define-key map (kbd "C-h h") #'my-quit-other-window)
    (define-key map (kbd "C-h C-h") #'my-quit-other-window)

    (define-key map (kbd "C-x C-b") #'ibuffer)
    (define-key map (kbd "C-x C-f") #'my-find-files)
    (define-key map (kbd "C-x C-k") #'kill-this-buffer)

    (define-key map (kbd "C-c C-e") #'eval-region)

    (define-key map (kbd "C-a") 'mwim-beginning-of-code-or-line)
    (define-key map (kbd "C-e") 'mwim-end-of-code-or-line)
    (define-key map (kbd "<home>") 'mwim-beginning-of-line-or-code)
    (define-key map (kbd "<end>") 'mwim-end-of-line-or-code)

    (define-key map (kbd "C-c .") 'er/expand-region)

    (define-key map (kbd "C-c v") 'set-rectangular-region-anchor)
    (define-key map (kbd "C-c C-v") 'set-rectangular-region-anchor)

    (define-key map (kbd "C-c o") 'my-occur)
    (define-key map (kbd "C-c s") 'my-rg-at-point)
    (define-key map (kbd "C-c C-o") 'my-occur)
    (define-key map (kbd "C-c C-s") 'my-rg-at-point)

    ;; (define-key map (kbd "M-i") #'er/mark-symbol)
    (define-key map (kbd "M-;") 'avy-goto-word-0)
    (define-key map (kbd "M-s") 'my-save-buffer)
    (define-key map (kbd "C-j") 'my-save-buffer)
    (define-key map (kbd "M-j") 'gcm-scroll-down)
    (define-key map (kbd "M-k") 'gcm-scroll-up)
    (define-key map (kbd "M-o") 'other-window)
    (define-key map (kbd "M-q") 'my-toggle-god-mode)

    (define-key map (kbd "M-u") 'upcase-dwim)
    (define-key map (kbd "M-l") 'downcase-dwim)

    (define-prefix-command 'my-god-mode-leader-key)
    (define-prefix-command 'my-god-mode-dummmy-key)
    (define-prefix-command 'my-god-mode-viewer-key)
    ;; (define-prefix-command 'my-god-mode-window-key)
    (define-key god-local-mode-map (kbd "SPC") 'my-god-mode-leader-key)
    (define-key god-local-mode-map (kbd ",")   'my-god-mode-dummmy-key)
    (define-key god-local-mode-map (kbd "z")   'my-god-mode-viewer-key)
    ;; (define-key god-local-mode-map (kbd "q")   'my-god-mode-window-key)

    ;; God mode key mappings
    (define-key god-local-mode-map (kbd "f") #'avy-goto-word-0)
    (define-key god-local-mode-map (kbd "w") #'forward-word)
    (define-key god-local-mode-map (kbd "b") #'backward-word)
    (define-key god-local-mode-map (kbd "k") #'previous-line)
    (define-key god-local-mode-map (kbd "j") #'next-line)
    (define-key god-local-mode-map (kbd "q") #'my-pause-god-send-q-key-resume-god)
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

    ;; (define-key god-local-mode-map (kbd "<RET>") #'next-line)

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
    (define-key god-local-mode-map (kbd ":") #'my-M-x)

    (define-key god-local-mode-map (kbd "C-.") #'repeat)
    (define-key god-local-mode-map (kbd "C-~") #'upcase-char)

    ;; (define-key god-local-mode-map (kbd "C-n") #'my-mc/mark-next-like-this)

    (define-key god-local-mode-map (kbd "C-x C-n") #'my-mc/mark-next-like-this)
    (define-key god-local-mode-map (kbd "C-x C-p") #'my-mc/mark-previous-like-this)

    (define-key god-local-mode-map (kbd "SPC SPC") #'my-mark-ring)
    (define-key god-local-mode-map (kbd "SPC b") #'counsel-switch-buffer)
    (define-key god-local-mode-map (kbd "SPC B") #'ibuffer)
    (define-key god-local-mode-map (kbd "SPC k") #'kill-this-buffer)
    (define-key god-local-mode-map (kbd "SPC K") #'my-only-current-buffer)
    (define-key god-local-mode-map (kbd "SPC P P") #'my-show-file-name)
    (define-key god-local-mode-map (kbd "SPC M-k") #'my-only-current-buffer-include-specials)

    (define-key god-local-mode-map (kbd "SPC ,") #'eldoc-box-eglot-help-at-point)
    (define-key god-local-mode-map (kbd "SPC R") #'my-revert-buffer-no-confirm)

    (define-key god-local-mode-map (kbd "SPC f") #'my-projectile-find-file)
    (define-key god-local-mode-map (kbd "SPC p") #'my-find-files)
    (define-key god-local-mode-map (kbd "SPC m") #'deadgrep)
    (define-key god-local-mode-map (kbd "SPC L") #'display-line-numbers-mode)
    (define-key god-local-mode-map (kbd "SPC x") #'delete-window)   ;; delete this window

    (define-key god-local-mode-map (kbd "SPC l") #'previous-buffer)
    (define-key god-local-mode-map (kbd "SPC h") #'next-buffer)

    (define-key god-local-mode-map (kbd "SPC t") #'treemacs)
    (define-key god-local-mode-map (kbd "SPC n") #'my-neotree-toggle)
    (define-key god-local-mode-map (kbd "SPC N") #'my-neotree-find)


    (define-key god-local-mode-map (kbd "@") #'my-treemacs-add-and-display-current-project)
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
    (define-key god-local-mode-map (kbd "M-<RET>") #'eglot-code-actions)

    ;; (define-key god-local-mode-map (kbd "C-, C-h") #'switch-to-prev-buffer)
    ;; (define-key god-local-mode-map (kbd "C-, C-l") #'switch-to-next-buffer)

    ;; (my-key-chord-define god-local-mode-map ",,"  #'er/mark-symbol)

    ;; (define-key god-local-mode-map (kbd "C-m") #'next-line)

    (define-key god-local-mode-map (kbd ";") #'scroll-up-command)
    (define-key god-local-mode-map (kbd "'") #'scroll-down-command)
    ;; (define-key god-local-mode-map (kbd "\\") #'recenter-top-bottom)


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
    (define-key map (kbd "/") #'isearch-forward)
    (define-key map (kbd "k") #'previous-line)
    (define-key map (kbd "j") #'next-line)
    (define-key map (kbd "l") #'my-forward-char-no-cross-line)
    (define-key map (kbd "h") #'my-backward-char-no-cross-line)

    (define-key map (kbd "f") #'avy-goto-word-0)
    (define-key map (kbd "M-;") #'avy-goto-word-0)
    (define-key map (kbd "M-o") #'other-window)
    (define-key map (kbd "M-x") #'my-M-x)

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



(provide 'my-key-bindings)
