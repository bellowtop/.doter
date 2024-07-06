

(defun my-recenter-scroll-to-top ()
  (interactive)
  (recenter-top-bottom 1)
  (setq recenter-last-op nil))


;; quit xref buffer after enter
(with-eval-after-load 'xref
  (define-key xref--xref-buffer-mode-map (kbd "o") #'(lambda ()
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
  (let (orig-point orig-buffer new-point new-buffer)
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


(provide 'init-xref)
