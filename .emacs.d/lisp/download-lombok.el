(require 'f)

(defvar lsp-java-lombok--jar-path
  (if (boundp 'doom-cache-dir)
      (f-join doom-cache-dir "lombok/lombok.jar")
    (f-join user-emacs-directory ".local/cache/lombok/lombok.jar")))

(defun lsp-java-lombok-download ()
  "Download the latest lombok jar."
  (make-directory (f-dirname lsp-java-lombok--jar-path) t)
  (when (f-exists-p lsp-java-lombok--jar-path)
    (f-delete lsp-java-lombok--jar-path))
  (lsp--info "Downloading lombok...")
  (url-copy-file "https://projectlombok.org/downloads/lombok.jar" lsp-java-lombok--jar-path))

(defun lsp-java-lombok-init ()
  "Download lombok and set vmargs."
  (unless (f-exists-p lsp-java-lombok--jar-path)
    (lsp-java-lombok-download))
)


(provide 'download-lombok)
