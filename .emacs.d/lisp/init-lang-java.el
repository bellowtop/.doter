(defvar +java/junit-platform-console-standalone-jar
  (expand-file-name "~/.emacs.d/.local/eclipse.jdt.ls/test-runner/junit-platform-console-standalone.jar"))


(add-hook-run-once 'java-mode-hook #'+java/eglot-setup)


(defun +java/eglot-setup ()
  (unless (featurep 'eglot)
    (require 'eglot))


    (add-to-list 'eglot-server-programs
                   `(java-mode "jdtls"
                               "--jvm-arg=-XX:+UseStringDeduplication"
                               "-data" ,(expand-file-name "~/.emacs.d/.local/workspace")
                               ,(concat "--jvm-arg=-javaagent:" (expand-file-name "~/.emacs.d/.local/cache/lombok/lombok.jar")
                    )))



     (defvar eglot/initialization-options-map (make-hash-table :size 5))

    (cl-defmethod eglot-initialization-options ((server eglot-lsp-server))
      (if-let ((init-options (gethash (eglot--major-mode server) eglot/initialization-options-map)))
          init-options
        eglot--{}))

    (cl-defmethod eglot-execute-command (_server (_cmd (eql java.apply.workspaceEdit)) arguments)
      "Eclipse JDT breaks spec and replies with edits as arguments."
      (mapc #'eglot--apply-workspace-edit arguments))



    ;; See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    (puthash 'java-mode
             `(:settings
               (:java
              (:completion
               (:importOrder "java;javax;org;com;lombok")
               :configuration
               (:runtime [(:name "JavaSE-1.8" :path "/usr/lib/jvm/java-8-openjdk")
                          (:name "JavaSE-11" :path "/usr/lib/jvm/java-11-openjdk" :default t)
                          (:name "JavaSE-17" :path "/usr/lib/jvm/java-17-openjdk")])
               :format (:settings (:url ,(expand-file-name "~/.emacs.d/.local/eclipse-java-google-style.xml")
                                        :profile "GoogleStyle"))

               ;; NOTE: https://github.com/redhat-developer/vscode-java/issues/406#issuecomment-356303715
               ;; > We enabled it by default so that workspace-wide errors can
               ;; > be reported (eg. removing a public method in one class would
               ;; > cause compilation errors in other files consuming that
               ;; > method). For large workspaces, it may make sense to be able
               ;; > to disable autobuild if it negatively impacts performance.
               :autobuild (:enabled t)

               ;; https://github.com/dgileadi/vscode-java-decompiler
               ;; WIP: support non standard LSP `java/classFileContents', `Location' items that have a `jdt://...' uri
               ;; https://github.com/eclipse/eclipse.jdt.ls/issues/1384
               ;; nvim impl demo: https://github.com/mfussenegger/dotfiles/commit/3cddf73cd43120da2655e2df6d79bdfd06697f0e
               ;; lsp-java impl demo: https://github.com/emacs-lsp/lsp-java/blob/master/lsp-java.el
               :contentProvider (:preferred "fernflower")
               :saveActions (:organizeImports nil)))
             :extendedClientCapabilities (:classFileContentsSupport t)
             ;; bundles: decompilers, etc.
             ;; https://github.com/dgileadi/dg.jdt.ls.decompiler
             :bundles ,(let ((bundles-dir (expand-file-name "~/.emacs.d/.local/cache/language-server/java/bundles"))
                             jdtls-bundles)
                         (->> (when (file-directory-p bundles-dir)
                                (directory-files bundles-dir t "\\.jar$"))
                              (append jdtls-bundles)
                              (apply #'vector))))
           eglot/initialization-options-map)



  (eglot-ensure)

  (add-hook 'java-mode-hook #'eglot-ensure)

)



(use-package jdecomp
  :commands (jdecomp-mode)
  :config
  (setq jdecomp-decompiler-type 'fernflower
        jdecomp-decompiler-paths `((fernflower . ,(expand-file-name "~/.emacs.d/.local/cache/language-server/java/bundles/dg.jdt.ls.decompiler.fernflower-0.0.3.jar")))
        jdecomp-decompiler-options '((fernflower "-hes=0" "-hdc=0" "-fdi=0"))))



(provide 'init-lang-java)

