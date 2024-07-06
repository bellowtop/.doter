
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



(provide 'my-catch-term-escape-key)
