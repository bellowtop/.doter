(unless (directory-empty-p (expand-file-name "~/.emacs.d/lisp/blink-search"))
  (setq blink-search-history-path
    (expand-file-name (concat user-emacs-directory ".local/blink-search/history.txt")))
  (setq blink-search-db-path
    (expand-file-name (concat user-emacs-directory ".local/blink-search/blink-search.db")))
  )

(require 'blink-search)

(provide 'init-blink-search)
