;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "impatient-mode" "20260426.1323"
  "Serve buffers live over HTTP."
  '((emacs        "27.1")
    (simple-httpd "1.5.0")
    (htmlize      "1.40"))
  :url "https://github.com/skeeto/impatient-mode"
  :commit "4bb8009c6c6a6339a8fd7b4dea4a165af3721812"
  :revdesc "4bb8009c6c6a"
  :authors '(("Brian Taylor" . "el.wubo@gmail.com")
             ("Christopher Wellons" . "wellons@nullprogram.com"))
  :maintainers '(("Jen-Chieh Shen" . "jcs090218@gmail.com")))
