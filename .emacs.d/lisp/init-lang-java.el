;; init-lang-java.el --- Java Configurations	-*- lexical-binding: t -*-

;; Author: Zsxh Chen <bnbvbchen@gmail.com>
;; URL: https://github.com/zsxh/emacs.d

;;; Commentary:
;;
;;  Java Configurations
;;

;;; Code:

;; NOTE: https://github.com/calve/flycheck-infer Flycheck for java using Infer
;; NOTE: https://fbinfer.com/ Infer
;; NOTE: https://github.com/pmd/pmd-emacs PMD Emacs
;; NOTE: https://pmd.github.io/latest/index.html PMD



;; Java development environment paths
(defvar java-local-dir (expand-file-name "~/.emacs.d/.local"))
(defvar java-dev-dir (file-name-concat java-local-dir "java"))
(defvar java-lombok-dir (file-name-concat java-dev-dir "lombok"))
(defvar java-test-runner-dir (file-name-concat java-dev-dir "test-runner"))
(defvar java-debug-dir (file-name-concat java-dev-dir "debug"))
(defvar java-bundles-dir (file-name-concat java-dev-dir "bundles"))

;; JDT Language Server paths
(defvar jdt-language-server-dir (file-name-concat java-local-dir "jdt-language-server-latest"))
(defvar jdt-language-server-workspaces (file-name-concat java-local-dir "jdt-language-server-workspaces"))
(defvar jdt-language-server-config-dir (file-name-concat jdt-language-server-dir "config_mac_arm"))

;; Java development JAR files
(defvar java-lombok-jar (file-name-concat java-lombok-dir "lombok.jar"))
(defvar java-junit-platform-console-standalone-jar (file-name-concat java-test-runner-dir "junit-platform-console-standalone.jar"))

;; Java formatter configuration
(defvar java-google-style-formatter (file-name-concat java-local-dir "eclipse-java-google-style.xml"))

;; Java runtime configuration
(defvar java-runtime-path "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home")

;; Helper function for jdtls contact
(defun eglot-jdtls-contact (interactive)
  `(,(file-name-concat jdt-language-server-dir "bin" "jdtls")
    ;; 指定 Java 运行时路径
    "--java-executable" ,(file-name-concat java-runtime-path "bin" "java")
    ;; Use macOS ARM config for M1 Mac
    "-configuration" ,jdt-language-server-config-dir
    "-data" ,(file-name-concat
              jdt-language-server-workspaces
              (file-name-base (directory-file-name (project-root (eglot--current-project)))))
    ;; Lombok support for Java annotations (optional)
    ;; Uncomment to use Maven repository lombok: ,(concat "--jvm-arg=-javaagent:" (expand-file-name "~/.m2/repository/org/projectlombok/lombok/1.18.20/lombok-1.18.20.jar"))
    ,(concat "--jvm-arg=-javaagent:" java-lombok-jar)
    ;; JVM memory and GC settings
    "--jvm-arg=-Xmx2G"
    "--jvm-arg=-XX:+UseG1GC"
    "--jvm-arg=-XX:+UseStringDeduplication"))

;; Configure java-ts-mode (Tree-sitter Java mode)
(use-package java-ts-mode
  :when (and (treesit-available-p) (treesit-language-available-p 'java))
  :mode "\\.java\\'"
  :config
  ;; Ensure .java files use java-ts-mode instead of java-mode
  (add-to-list 'major-mode-remap-alist '(java-mode . java-ts-mode))

  ;; Configure eglot to use jdtls for java-ts-mode
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '(java-ts-mode . eglot-jdtls-contact)))

  ;; Set up keybindings for java-ts-mode
  (+funcs/major-mode-leader-keys
   java-ts-mode-map
   "r" '(nil :which-key "run")
   "rt" '(eglot-java-run-test :which-key "run-test-at-point")
   "rm" '(eglot-java-run-main :which-key "run-main"))

  :hook (java-ts-mode . eglot-ensure))

;; Helper function for Java LSP initialization options
(defun java-eglot-initialization-options ()
  "JDT LS initialization options for java-ts-mode."
  `(:settings
    (:java
     (:configuration
      ;; Update Java runtime paths for macOS with Homebrew OpenJDK
      (:runtime [(:name "JavaSE-21" :path ,java-runtime-path :default t)])
      :format (:settings (:url ,java-google-style-formatter
                               :profile "GoogleStyle"))
      ;; NOTE: https://github.com/redhat-developer/vscode-java/issues/406#issuecomment-356303715
      ;; > We enabled it by default so that workspace-wide errors can be reported (eg. removing a public method in one class would cause compilation errors in other files consuming that method).
      ;; for large workspaces, it may make sense to be able to disable autobuild if it negatively impacts performance.
      :autobuild (:enabled t)
      ;; https://github.com/dgileadi/vscode-java-decompiler
      :contentProvider (:preferred "fernflower"))
     :completion
     (:guessMethodArguments t
      :overwrite t
      :enabled t
      :favoriteStaticMembers ["org.junit.Assert.*"
                              "org.junit.Assume.*"
                              "org.junit.jupiter.api.Assertions.*"
                              "org.junit.jupiter.api.Assumptions.*"
                              "org.junit.jupiter.api.DynamicContainer.*"
                              "org.junit.jupiter.api.DynamicTest.*"
                              "org.mockito.Mockito.*"
                              "org.mockito.ArgumentMatchers.*"
                              "org.mockito.Answers.*"]))
    ;; support non standard LSP `java/classFileContents', `Location' items that have a `jdt://...' uri
    ;; https://github.com/eclipse/eclipse.jdt.ls/issues/1384
    :extendedClientCapabilities (:classFileContentsSupport t)
    ;; bundles: decompilers, etc.
    ;; https://github.com/dgileadi/dg.jdt.ls.decompiler

    ;; Additional JDT LS bundles (extensions, decompilers, etc.)
    :bundles ,(let ((bundles-dir java-bundles-dir)
                    ;; Alternative: use JDT LS plugins directory
                    ;; (bundles-dir (expand-file-name "plugins" jdt-language-server-dir))
                    jdtls-bundles)
                (->> (when (file-directory-p bundles-dir)
                       (directory-files bundles-dir t "\\.jar$"))
                     (append jdtls-bundles)
                     (apply #'vector)))))

;; 确保 Eglot 已经加载
(with-eval-after-load 'eglot
  ;; 方法特化 - 确保 Eglot 已经加载
  (cl-defmethod eglot-initialization-options
    ((server eglot-lsp-server)          ; 参数类型约束：server 必须是 eglot-lsp-server 类型
     &context                           ; 开始上下文约束
     (major-mode java-ts-mode))         ; 上下文约束：当前 major-mode 必须是 java-ts-mode
    (java-eglot-initialization-options)))


;; https://github.com/yveszoundi/eglot-java/blob/main/eglot-java.el
(defun eglot-java--class-fqcn (&optional main-p)
  "Return the fully qualified name of a given class."
  (let* ((document-symbols (eglot-java--document-symbols))
         (package-name (eglot-java--symbol-value document-symbols "Package"))
         (class-name (eglot-java--symbol-value document-symbols "Class"))
         (method-name (unless main-p (eglot-java--method-name document-symbols class-name)))
         (package-suffix (if (string= "" package-name)
                             package-name
                           "."))
         (cls (format "%s%s%s" package-name package-suffix class-name)))

    (if method-name
        (format "%s#%s" cls method-name)
      cls)))

(defun eglot-java--symbol-value (symbols symbol-type)
  "Extract the symbol value for a given SYMBOL-TYPE from a symbol table SYMBOLS."
  (let ((symbol-details (cl-find-if
                         (lambda (elem)
                           (let* ((elem-kind (plist-get elem :kind))
                                  (elem-type (cdr (assoc elem-kind eglot--symbol-kind-names))))
                             (string= elem-type symbol-type)))
                         symbols)))
    (if symbol-details
        (plist-get symbol-details :name)
      "")))

(defun eglot-java--method-name (symbols class-name)
  (let* ((class-symbol (cl-find-if
                        (lambda (elem)
                          (string= (plist-get elem :name) class-name))
                        symbols))
         (method-symbol (cl-find-if
                         (lambda (elem)
                           (if-let* ((elem-kind (plist-get elem :kind))
                                     (elem-type (cdr (assoc elem-kind eglot--symbol-kind-names)))
                                     (method? (string= elem-type "Method"))
                                     (range (plist-get elem :range))
                                     (start (plist-get range :start))
                                     (end (plist-get range :end))
                                     (start-pos (+funcs/pos-at-line-col (plist-get start :line) (plist-get start :character)))
                                     (end-pos (+funcs/pos-at-line-col (plist-get end :line) (plist-get end :character))))
                               (<= start-pos (point) end-pos)))
                         (plist-get class-symbol :children))))
    (when method-symbol
        (let* ((range (plist-get method-symbol :selectionRange))
               (start (plist-get range :start))
               (end (plist-get range :end))
               (start-pos (+funcs/pos-at-line-col (plist-get start :line) (plist-get start :character)))
               (end-pos (+funcs/pos-at-line-col (plist-get end :line) (plist-get end :character))))
          (buffer-substring-no-properties start-pos end-pos)))))

(defun eglot-java--document-symbols ()
  "Fetch the document symbols/tokens."
  (jsonrpc-request
   (eglot--current-server-or-lose)
   :textDocument/documentSymbol
   (list :textDocument (list :uri (eglot--path-to-uri (buffer-file-name))))))


(defun eglot-java--project-classpath (filename scope)
  "Return the classpath for a given FILENAME and SCOPE."
  (plist-get (eglot-execute-command (eglot--current-server-or-lose)
                                    "java.project.getClasspaths"
                                    (vector (eglot--path-to-uri filename)
                                            (json-encode `(( "scope" . ,scope)))))
             :classpaths))

(defun eglot-java--file--test-p (file-path)
  "Tell if a file locate at FILE-PATH is a test class."
  (eglot-execute-command
   (eglot--current-server-or-lose)
   "java.project.isTestFile"
   (vector (eglot--path-to-uri file-path ))))

(defun eglot-java-run-test ()
  "Run a test class."
  (interactive)
  (let* ((fqcn                 (eglot-java--class-fqcn))
         (cp                   (eglot-java--project-classpath (buffer-file-name) "test"))
         (current-file-is-test (not (equal ':json-false (eglot-java--file--test-p (buffer-file-name))))))

    (unless (file-exists-p java-junit-platform-console-standalone-jar)
      (user-error "%s doest not exit" java-junit-platform-console-standalone-jar))

    (if current-file-is-test
        (compile
         (concat "java -jar "
                 java-junit-platform-console-standalone-jar
                 (if (string-match-p "#" fqcn) " -m " " -c ")
                 fqcn
                 " -class-path "
                 (mapconcat #'identity cp path-separator)
                 " ")
         t)
      (user-error "No test found in current file! Is the file saved?" ))))

(defun eglot-java-run-main ()
  "Run a main class."
  (interactive)
  (let* ((fqcn (eglot-java--class-fqcn t))
         (cp   (eglot-java--project-classpath (buffer-file-name) "runtime")))
    (if fqcn
        (compile
         (concat "java -cp "
                 (mapconcat #'identity cp path-separator)
                 " "
                 fqcn)
         t)
      (user-error "No main method found in this file! Is the file saved?!"))))




;; http://www.tianxiangxiong.com/2017/02/12/decompiling-java-classfiles-in-emacs.html
;; https://github.com/xiongtx/jdecomp
;; https://github.com/JetBrains/intellij-community/tree/master/plugins/java-decompiler/engine
;; Example: java -cp /path/to/JetBrains/Toolbox/apps/IDEA-C/ch-0/xxx/plugins/java-decompiler/lib/java-decompiler.jar org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler [-<option>=<value>]* [<source>]+ <destination>
;; TODO: `jdecomp--fernflower-decompile-file' should extract all A.class and A${anonymous}.class

(use-package jdecomp
  :commands (jdecomp-mode)
  :init
  ;; 预配置反编译器设置（在包加载前）
  (setq jdecomp-decompiler-type 'fernflower
        ;; 使用简化的反编译器路径选择
        jdecomp-decompiler-paths
        (let ((cfr-decompiler (file-name-concat java-dev-dir "cfr/cfr.jar"))
              (intellij-decompiler "/Applications/IntelliJ IDEA CE.app/Contents/plugins/java-decompiler/lib/java-decompiler.jar"))
          `((fernflower . ,(cond
                            ;; 1. 优先使用 CFR 反编译器（推荐，兼容性好）
                            ((file-exists-p cfr-decompiler) cfr-decompiler)
                            ;; 2. 备选：IntelliJ IDEA 反编译器
                            ((file-exists-p intellij-decompiler) intellij-decompiler)
                            ;; 3. 默认：CFR 路径（稍后下载）
                            (t cfr-decompiler)))))
        jdecomp-decompiler-options '((fernflower "-hes=0" "-hdc=0" "-fdi=0"))
        ;; 设置临时目录，避免 nil 路径问题
        jdecomp-temp-dir (file-name-concat temporary-file-directory "jdecomp")
        ;; 确保输出目录存在
        jdecomp-output-directory (file-name-concat temporary-file-directory "jdecomp-output"))

  :config
  ;; 确保临时目录存在
  (unless (file-directory-p jdecomp-temp-dir)
    (make-directory jdecomp-temp-dir t))

  ;; 确保输出目录存在
  (when (boundp 'jdecomp-output-directory)
    (unless (file-directory-p jdecomp-output-directory)
      (make-directory jdecomp-output-directory t)))

  ;; 调试信息：显示反编译器配置
  (message "JDecomp: Using decompiler at %s"
           (cdr (assq jdecomp-decompiler-type jdecomp-decompiler-paths)))
  (message "JDecomp: Temp directory: %s" jdecomp-temp-dir)
  (when (boundp 'jdecomp-output-directory)
    (message "JDecomp: Output directory: %s" jdecomp-output-directory))

  ;; 为 .class 文件自动启用 jdecomp-mode
  (add-to-list 'auto-mode-alist '("\\.class\\'" . jdecomp-mode))

  ;; 增强错误处理和调试
  (defun jdecomp-safe-mode ()
    "Safely enable jdecomp with error handling."
    (condition-case err
        (progn
          (message "JDecomp: Attempting to decompile %s" (buffer-name))
          ;; 确保必要的变量已设置
          (unless jdecomp-temp-dir
            (setq jdecomp-temp-dir (file-name-concat temporary-file-directory "jdecomp")))
          (unless (file-directory-p jdecomp-temp-dir)
            (make-directory jdecomp-temp-dir t))

          ;; 确保输出目录设置
          (unless (boundp 'jdecomp-output-directory)
            (setq jdecomp-output-directory (file-name-concat temporary-file-directory "jdecomp-output")))
          (unless (file-directory-p jdecomp-output-directory)
            (make-directory jdecomp-output-directory t))

          ;; 验证反编译器路径
          (let ((decompiler-path (cdr (assq jdecomp-decompiler-type jdecomp-decompiler-paths))))
            (unless (and decompiler-path (file-exists-p decompiler-path))
              (error "Decompiler not found at: %s" decompiler-path)))

          ;; 确保反编译器类型和选项设置
          (unless jdecomp-decompiler-type
            (setq jdecomp-decompiler-type 'fernflower))
          (unless jdecomp-decompiler-options
            (setq jdecomp-decompiler-options '((fernflower "-hes=0" "-hdc=0" "-fdi=0"))))

          (jdecomp-mode 1)
          (message "JDecomp: Successfully enabled for %s" (buffer-name)))
      (error
       (message "JDecomp error in %s: %s" (buffer-name) err)
       (fundamental-mode))))

  ;; 自动刷新空白的反编译 buffer
  (defun jdecomp-auto-refresh ()
    "Auto refresh if buffer appears empty."
    (when (and (eq major-mode 'jdecomp-mode)
               (= (buffer-size) 0))
      (message "JDecomp: Buffer empty, attempting refresh...")
      (jdecomp-mode -1)
      (jdecomp-mode 1)))

  ;; 添加 hook 进行自动检查
  (add-hook 'jdecomp-mode-hook #'jdecomp-auto-refresh)

  ;; 为 Java 相关的归档文件也启用反编译
  (add-to-list 'auto-mode-alist '("\\.jar\\'" . archive-mode))

  ;; 增强 Java 调试信息
  (advice-add 'jdecomp-mode :before
              (lambda (&rest _)
                "Show debug info when enabling jdecomp-mode."
                (when (called-interactively-p 'any)
                  (message "JDecomp: Manual activation in buffer: %s" (buffer-name)))))

  ;; 添加修复命令
  (defun jdecomp-fix-setup ()
    "Fix jdecomp configuration issues."
    (interactive)
    (message "JDecomp: Fixing configuration...")

    ;; 重新设置临时目录
    (setq jdecomp-temp-dir (file-name-concat temporary-file-directory "jdecomp"))
    (unless (file-directory-p jdecomp-temp-dir)
      (make-directory jdecomp-temp-dir t))

    ;; 设置输出目录
    (setq jdecomp-output-directory (file-name-concat temporary-file-directory "jdecomp-output"))
    (unless (file-directory-p jdecomp-output-directory)
      (make-directory jdecomp-output-directory t))

    ;; 确保反编译器类型设置
    (unless jdecomp-decompiler-type
      (setq jdecomp-decompiler-type 'fernflower))

    ;; 确保反编译器路径设置
    (unless jdecomp-decompiler-paths
      (let ((cfr-decompiler (file-name-concat java-dev-dir "cfr/cfr.jar"))
            (intellij-decompiler "/Applications/IntelliJ IDEA CE.app/Contents/plugins/java-decompiler/lib/java-decompiler.jar"))
        (setq jdecomp-decompiler-paths
              `((fernflower . ,(cond
                                ;; 1. 优先使用 CFR 反编译器
                                ((file-exists-p cfr-decompiler) cfr-decompiler)
                                ;; 2. 备选：IntelliJ IDEA 反编译器
                                ((file-exists-p intellij-decompiler) intellij-decompiler)
                                ;; 3. 默认：CFR 路径
                                (t cfr-decompiler)))))))

    ;; 确保反编译器选项设置
    (unless jdecomp-decompiler-options
      (setq jdecomp-decompiler-options '((fernflower "-hes=0" "-hdc=0" "-fdi=0"))))

    ;; 验证反编译器
    (let ((decompiler-path (cdr (assq jdecomp-decompiler-type jdecomp-decompiler-paths))))
      (if (and decompiler-path (file-exists-p decompiler-path))
          (message "JDecomp: ✅ Configuration fixed successfully!")
        (message "JDecomp: ⚠️ Decompiler not found at: %s" decompiler-path)))

    ;; 显示当前配置
    (message "JDecomp: Current settings:")
    (message "  - Type: %s" jdecomp-decompiler-type)
    (message "  - Temp dir: %s" jdecomp-temp-dir)
    (message "  - Output dir: %s" jdecomp-output-directory)
    (message "  - Decompiler: %s" (cdr (assq jdecomp-decompiler-type jdecomp-decompiler-paths))))

  ;; 处理 JDT Language Server 的特殊 URI
  (defun jdecomp-handle-jdt-uri ()
    "Handle JDT Language Server URI for decompilation."
    (interactive)
    (when (string-match "jdt:/contents/" (or (buffer-file-name) ""))
      (message "JDecomp: Detected JDT URI: %s" (buffer-name))
      ;; 禁用自动保存和备份，避免文件名过长问题
      (setq-local auto-save-default nil)
      (setq-local make-backup-files nil)
      (setq-local create-lockfiles nil)
      (setq-local auto-save-mode nil)
      ;; 设置 buffer 为只读，因为这是虚拟内容
      (setq-local buffer-read-only t)
      (let ((content (buffer-string)))
        (if (string-empty-p content)
            (progn
              (message "JDecomp: Buffer is empty, this is expected for JDT URIs")
              (message "JDecomp: Use 'Go to Definition' (M-.) or 'Find References' instead")
              (message "JDecomp: JDT LS handles decompilation automatically"))
          (message "JDecomp: JDT URI content loaded successfully")))))

  ;; 为 JDT URI 添加特殊处理
  (add-hook 'find-file-hook #'jdecomp-handle-jdt-uri)

  ;; 添加长文件名保护函数
  (defun jdecomp-protect-long-filenames ()
    "Protect against long filename issues in auto-save."
    (when (and (buffer-file-name)
               (> (length (buffer-file-name)) 200))  ; 文件名超过 200 字符
      (message "JDecomp: Long filename detected, disabling auto-save features")
      (setq-local auto-save-default nil)
      (setq-local make-backup-files nil)
      (setq-local create-lockfiles nil)
      (setq-local auto-save-mode nil)))

  ;; 为所有文件添加长文件名保护
  (add-hook 'find-file-hook #'jdecomp-protect-long-filenames)

  ;; 增强的 buffer 检查
  (defun jdecomp-check-buffer-status ()
    "Check and report buffer status for debugging."
    (interactive)
    (let ((file-name (buffer-file-name))
          (buffer-size (buffer-size))
          (major-mode-name (symbol-name major-mode)))
      (message "=== JDecomp Buffer Status ===")
      (message "Buffer name: %s" (buffer-name))
      (message "File name: %s" (or file-name "No file"))
      (message "Buffer size: %d bytes" buffer-size)
      (message "Major mode: %s" major-mode-name)
      (message "Read-only: %s" (if buffer-read-only "Yes" "No"))
      (message "Auto-save: %s" (if auto-save-mode "Enabled" "Disabled"))
      (message "Backup files: %s" (if make-backup-files "Enabled" "Disabled"))

      (when file-name
        (message "File name length: %d characters" (length file-name))
        (when (> (length file-name) 200)
          (message "⚠️  WARNING: File name is very long (>200 chars)"))
        (cond
         ((string-match "jdt:/contents/" file-name)
          (message "Type: JDT Language Server URI")
          (message "Note: JDT URIs are handled by LSP, not jdecomp")
          (message "Auto-save disabled: %s" (if auto-save-mode "No" "Yes")))
         ((string-match "\\.class\\'" file-name)
          (message "Type: Local .class file")
          (message "Should use: jdecomp-mode"))
         ((string-match "\\.jar\\'" file-name)
          (message "Type: JAR archive")
          (message "Should use: archive-mode"))
         (t
          (message "Type: Other file"))))
      (message "=========================")))

  ;; 快速修复长文件名问题
  (defun jdecomp-fix-long-filename ()
    "Fix current buffer's long filename issues."
    (interactive)
    (when (buffer-file-name)
      (let ((filename-length (length (buffer-file-name))))
        (message "JDecomp: Current filename length: %d" filename-length)
        (when (> filename-length 200)
          (message "JDecomp: Fixing long filename issues...")
          (setq-local auto-save-default nil)
          (setq-local make-backup-files nil)
          (setq-local create-lockfiles nil)
          (setq-local auto-save-mode nil)
          (when (string-match "jdt:/contents/" (buffer-file-name))
            (setq-local buffer-read-only t)
            (message "JDecomp: Set JDT URI buffer as read-only"))
          (message "JDecomp: ✅ Long filename protections applied")))))

  ;; 详细的调试函数
  (defun jdecomp-debug-decompile ()
    "Detailed debugging for decompilation issues."
    (interactive)
    (let ((file-name (buffer-file-name))
          (buffer-content (buffer-string))
          (buffer-size (buffer-size)))

      (message "=== JDecomp Debug Analysis ===")
      (message "Buffer: %s" (buffer-name))
      (message "File: %s" (or file-name "No file"))
      (message "Size: %d bytes" buffer-size)
      (message "Major mode: %s" major-mode)
      (message "Read-only: %s" buffer-read-only)

      (when file-name
        (cond
         ;; JDT URI 分析
         ((string-match "jdt:/contents/" file-name)
          (message "Type: JDT Language Server URI")
          (message "Content empty: %s" (if (string-empty-p buffer-content) "YES" "NO"))
          (when (string-empty-p buffer-content)
            (message "🔍 JDT URI is empty - this is normal")
            (message "💡 Solutions:")
            (message "   1. Wait for JDT LS to load content")
            (message "   2. Try M-x revert-buffer")
            (message "   3. Use LSP navigation: M-. (go to definition)")
            (message "   4. Check if JDT LS is running")
            (message "   5. Try closing and reopening the file"))
          (unless (string-empty-p buffer-content)
            (message "✅ JDT URI has content (%d chars)" (length buffer-content))))

         ;; .class 文件分析
         ((string-match "\\.class\\'" file-name)
          (message "Type: Local .class file")
          (message "Should use jdecomp-mode")
          (message "Current jdecomp config:")
          (message "  - Type: %s" (if (boundp 'jdecomp-decompiler-type) jdecomp-decompiler-type "NOT SET"))
          (message "  - Paths: %s" (if (boundp 'jdecomp-decompiler-paths)
                                       (cdr (assq jdecomp-decompiler-type jdecomp-decompiler-paths))
                                     "NOT SET"))
          (when (boundp 'jdecomp-decompiler-paths)
            (let ((decompiler-path (cdr (assq jdecomp-decompiler-type jdecomp-decompiler-paths))))
              (message "  - Decompiler exists: %s" (if (file-exists-p decompiler-path) "YES" "NO"))
              (unless (file-exists-p decompiler-path)
                (message "❌ Decompiler not found at: %s" decompiler-path)
                (message "💡 Run: M-x jdecomp-fix-setup"))))

          (when (string-empty-p buffer-content)
            (message "❌ .class file content is empty")
            (message "💡 Try:")
            (message "   1. M-x jdecomp-mode")
            (message "   2. M-x jdecomp-safe-mode")
            (message "   3. Check file permissions")
            (message "   4. Verify decompiler installation")))

         (t
          (message "Type: Other file type")))

        ;; 通用检查
        (message "File exists: %s" (if (file-exists-p file-name) "YES" "NO"))
        (message "File readable: %s" (if (file-readable-p file-name) "YES" "NO"))
        (when (file-exists-p file-name)
          (message "File size on disk: %d bytes" (nth 7 (file-attributes file-name)))))

      (message "=========================")))

  ;; 手动测试反编译器
  (defun jdecomp-test-decompiler ()
    "Test the decompiler manually."
    (interactive)
    (cond
     ((not (boundp 'jdecomp-decompiler-paths))
      (message "❌ jdecomp-decompiler-paths not set"))

     (t
      (let ((decompiler-path (cdr (assq jdecomp-decompiler-type jdecomp-decompiler-paths))))
        (message "Testing decompiler: %s" decompiler-path)
        (cond
         ((not (file-exists-p decompiler-path))
          (message "❌ Decompiler not found at: %s" decompiler-path))

         ((not (executable-find "java"))
          (message "❌ Java not found in PATH"))

         (t
          (message "✅ Decompiler exists")
          (message "✅ Java is available")
          (let ((test-cmd (format "java -jar '%s' --help" decompiler-path)))
            (message "Testing command: %s" test-cmd)
            (condition-case err
                (let ((output (shell-command-to-string test-cmd)))
                  (if (string-match "CFR\\|fernflower\\|help" output)
                      (message "✅ Decompiler is working")
                    (message "⚠️  Decompiler output unexpected")))
              (error (message "❌ Decompiler test failed: %s" err))))))))))

)  ;; 关闭 use-package jdecomp 块


(provide 'init-lang-java)

;;; init-lang-java.el ends here
