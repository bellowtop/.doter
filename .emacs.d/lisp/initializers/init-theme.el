

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
(mapatoms
  (lambda (atom)
    (when (facep atom)
      (theme-tweaks-flatten-underline+ atom))))

;; flatten on each face definition in the future
(define-advice custom-declare-face
  (:around (fun &rest args) flatten-face)
  (let ((face (apply fun args)))
    (theme-tweaks-flatten-underline+ face)
    face))





;; (require 'autothemer)

;; (load-theme 'bogster t)
;; (load-theme 'srcery t)
(load-theme 'nimbus t)

;; ;; (load-theme 'spolsky t)
;; (if (display-graphic-p)
;;   ;; (load-theme 'afternoon t)
;;   (load-theme 'leuven-dark t)
;;   (load-theme 'bogster t))



(use-package doom-themes
  :ensure t
  :config
  ;;   (setq doom-themes-enable-bold nil    ; if nil, bold is universally disabled
  ;;         doom-themes-enable-italic nil) ; if nil, italics is universally disabled
  (doom-themes-neotree-config)
  ;; (doom-themes-treemacs-config)
  ;; (setq doom-themes-neotree-file-icons t)
  ;; (setq doom-themes-treemacs-theme "doom-colors")
  )


;; after load theme, clear the fringe color
(defun my-clear-fringe-color ()
  (set-face-attribute 'fringe nil
    :background (face-background 'default)
    :foreground (face-foreground 'default)))

(my-clear-fringe-color)




(defun my-set-bigger-spacing ()
  ;; (setq-local default-text-properties '(line-spacing 0.15 line-height 1.15))
  ;; (setq-local default-text-properties '(line-spacing 0 line-height t))
  )
(add-hook 'text-mode-hook 'my-set-bigger-spacing)
(add-hook 'prog-mode-hook 'my-set-bigger-spacing)




(set-cursor-color "red")
(setq-default cursor-type 'bar)
(setq-default cursor-in-non-selected-windows nil)

;; (set-face-attribute 'region nil :background "#666")



;; Display dividers between windows
(setq
  window-divider-default-places t
  window-divider-default-bottom-width 1
  window-divider-default-right-width 6)
(add-hook 'window-setup-hook #'window-divider-mode)

(set-face-background 'vertical-border (face-background 'default))
(set-face-foreground 'vertical-border "#00ff00")


;; fix terminal vertical-border char gap
(defun my-change-window-divider ()
  (let ((display-table (or buffer-display-table standard-display-table)))
    (set-display-table-slot display-table 5 ?│)
    (set-window-display-table (selected-window) display-table)))

(add-hook 'window-configuration-change-hook 'my-change-window-divider)



;; Set symbol for the border
(set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))




(tool-bar-mode -1)
(menu-bar-mode -1)
(smerge-mode -1)
;; (scroll-bar-mode -1)
(tab-bar-mode -1)


(setq default-frame-alist
  '(
     ;; (undecorated . t)  ;;;;会导致所有边框全部消失无法拖动调整窗口大小 需要加上后面两句
     ;; (drag-internal-border . 1)
     ;; (internal-border-width . 5)
     (vertical-scroll-bars) ;隐藏滚动条
     (left-fringe) ;显示左fringe
     (right-fringe . 0) ;关闭右fringe
     ))


(when (display-graphic-p)
  ;;; ;; awesome-tray is from emacswiki sub-directory
  ;;; (setq awesome-tray-mode-line-active-color '"#00ff00")

  ;;; (require 'awesome-tray)
  ;;; (awesome-tray-mode 1)

  (when (my-system-type-is-darwin)
    (menu-bar-mode 1))

  (scroll-bar-mode -1)
  (set-fringe-mode 0)
  ;; (tab-bar-mode -1)
  ;; (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark)) ;; dark themes use "dark"

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
  (setq frame-title-format `((buffer-file-name "%f" "%b"))))






(unless (display-graphic-p)
  ;; (setq doom-modeline-height 1)
  ;; (setq doom-modeline-icon nil)
  ;; (setq doom-modeline-bar-width -1)
  (setq doom-modeline-buffer-file-name-style 'relative-from-project)
  (require 'doom-modeline)
  (doom-modeline-mode 1))



(setq-default
  left-margin-width 0
  right-margin-width 0)


(provide 'init-theme)
