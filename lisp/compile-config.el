;;; compile-config.el --- Smart compile interface -*- lexical-binding:t; -*-

(require 'project)
(require 'json)
(require 'subr-x)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package compile-multi
  :ensure t
  :bind
  (("C-c c" . compile-multi)
   ("C-c r" . compile-multi-rerun))
  )

(use-package consult-compile-multi
  :ensure t
  :after compile-multi
  :config
  (consult-compile-multi-mode))

 (use-package compile-multi-nerd-icons
   :ensure t
   :after (compile-multi nerd-icons-completion)
   :config
   (compile-multi-nerd-icons-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Project root
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq compile-multi-default-directory
      (lambda ()
        (when-let ((project (project-current)))
          (project-root project))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/project-root ()
  (or (when-let ((project (project-current)))
        (project-root project))
      default-directory))

(defun my/project-file (name)
  (expand-file-name name (my/project-root)))

(defun my/project-has (file)
  (file-exists-p (my/project-file file)))

(defun my/read-json-file (file)
  (when (file-exists-p file)
    (json-read-file file)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; NodeJS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/package-json-scripts ()
  "Return compile-multi tasks generated from package.json."

  (when-let* ((package (my/read-json-file
                        (my/project-file "package.json")))
              (scripts (alist-get 'scripts package)))

    (mapcar
     (lambda (script)

       (let ((name (symbol-name (car script))))

         (cons
          (format "node:%s"
                  (capitalize name))

          (format "npm run %s"
                  name))))

     scripts)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Go
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/go-tasks ()

  (when (my/project-has "go.mod")

    '(("go:Build" . "go build")
      ("go:Run" . "go run .")
      ("go:Test" . "go test ./...")
      ("go:Fmt" . "go fmt ./...")
      ("go:Vet" . "go vet ./...")
      ("go:Mod Tidy" . "go mod tidy"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Rust
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/rust-tasks ()

  (when (my/project-has "Cargo.toml")

    '(("cargo:Build" . "cargo build")
      ("cargo:Run" . "cargo run")
      ("cargo:Test" . "cargo test")
      ("cargo:Check" . "cargo check")
      ("cargo:Fmt" . "cargo fmt")
      ("cargo:Clippy" . "cargo clippy")
      ("cargo:Bench" . "cargo bench")
      ("cargo:Doc" . "cargo doc --open"))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Package Manager Detection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/node-package-manager ()

  (cond
   ((my/project-has "bun.lockb") "bun")
   ((my/project-has "bun.lock") "bun")
   ((my/project-has "pnpm-lock.yaml") "pnpm")
   ((my/project-has "yarn.lock") "yarn")
   (t "npm")))

(defun my/node-command (script)

  (pcase (my/node-package-manager)

    ("npm"
     (format "npm run %s" script))

    ("pnpm"
     (format "pnpm %s" script))

    ("yarn"
     (format "yarn %s" script))

    ("bun"
     (format "bun run %s" script))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; package.json
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/node-tasks ()

  (when-let*
      ((package
        (my/read-json-file
         (my/project-file "package.json")))

       (scripts
        (alist-get 'scripts package)))

    (mapcar
     (lambda (it)

       (let ((script (symbol-name (car it))))

         (cons
          (format "node:%s"
                  (capitalize script))

          (my/node-command script))))

     scripts)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Makefile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/makefile-tasks ()

  (when
      (or
       (my/project-has "Makefile")
       (my/project-has "makefile"))

    '(("make:Build" . "make")
      ("make:Clean" . "make clean")
      ("make:Test" . "make test")
      ("make:Install" . "make install"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Justfile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/justfile-tasks ()

  (when (my/project-has "Justfile")

    '(("just:Default" . "just"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Taskfile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/taskfile-tasks ()

  (when
      (or
       (my/project-has "Taskfile.yml")
       (my/project-has "Taskfile.yaml"))

    '(("task:Default" . "task"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Merge Tasks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/compile-all-tasks ()

  (my/unique-tasks

   (append

    (my/go-tasks)

    (my/rust-tasks)

    (my/node-tasks)

    (my/makefile-targets)

    (my/just-targets)

    (my/taskfile-tasks))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; compile-multi integration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq compile-multi-config nil)

(push
 `(t
   ,#'my/compile-all-tasks)
 compile-multi-config)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Utilities
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/read-file-string (file)

  (when (file-exists-p file)

    (with-temp-buffer

      (insert-file-contents file)

      (buffer-string))))

(defun my/string-lines (string)

  (split-string string "\n" t))

(defun my/unique-tasks (tasks)

  (cl-remove-duplicates
   tasks
   :test #'equal
   :from-end t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Makefile parser
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/makefile-targets ()

  (when-let ((text
              (or
               (my/read-file-string
                (my/project-file "Makefile"))

               (my/read-file-string
                (my/project-file "makefile")))))

    (let (targets)

      (dolist (line (my/string-lines text))

        (when
            (string-match
             "^\\([A-Za-z0-9_.-]+\\):"
             line)

          (let ((target
                 (match-string 1 line)))

            (unless
                (member
                 target
                 '(".PHONY"
                   ".DEFAULT"
                   ".SUFFIXES"
                   ".PRECIOUS"
                   ".INTERMEDIATE"))

              (push
               (cons
                (format "make:%s" target)
                (format "make %s" target))

               targets)))))

      (nreverse targets))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Justfile parser
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/just-targets ()

  (when-let
      ((text
        (my/read-file-string
         (my/project-file "Justfile"))))

    (let (targets)

      (dolist (line (my/string-lines text))

        (when
            (string-match
             "^\\([A-Za-z0-9_-]+\\):"
             line)

          (push

           (cons
            (format "just:%s"
                    (match-string 1 line))

            (format "just %s"
                    (match-string 1 line)))

           targets)))

      (nreverse targets))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Provider Framework
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar my/compile-providers nil
  "List of task providers.")

(defun my/register-provider (fn)
  "Register a compile provider."

  (add-to-list
   'my/compile-providers
   fn
   t))

(defun my/provider-tasks ()

  (let (tasks)

    (dolist (provider my/compile-providers)

      (setq tasks

            (append
             tasks

             (ignore-errors
               (funcall provider)))))

    (my/unique-tasks tasks)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Register Providers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(my/register-provider #'my/go-tasks)

(my/register-provider #'my/rust-tasks)

(my/register-provider #'my/node-tasks)

(my/register-provider #'my/makefile-targets)

(my/register-provider #'my/just-targets)

(my/register-provider #'my/taskfile-tasks)

(setq compile-multi-config nil)

(push
 `(t
   ,#'my/provider-tasks)
 compile-multi-config)

(defun my/rust-tasks ()

  (when (my/project-has "Cargo.toml")

    (let ((workspace
           (string-match-p
            "\\[workspace\\]"
            (my/read-file-string
             (my/project-file "Cargo.toml")))))

      (append

       `(("cargo:Build"
          .
          ,(if workspace
               "cargo build --workspace"
             "cargo build"))

         ("cargo:Run"
          .
          "cargo run")

         ("cargo:Check"
          .
          "cargo check")

         ("cargo:Test"
          .
          ,(if workspace
               "cargo test --workspace"
             "cargo test"))

         ("cargo:Fmt"
          .
          "cargo fmt")

         ("cargo:Clippy"
          .
          "cargo clippy")

         ("cargo:Bench"
          .
          "cargo bench")

         ("cargo:Doc"
          .
          "cargo doc --open"))

       (when
           (executable-find "cargo-watch")

         '(("cargo:Watch"
            .
            "cargo watch -x check")))))))

(defun my/go-tasks ()

  (when (my/project-has "go.mod")

    (append

     '(("go:Build"
        .
        "go build")

       ("go:Run"
        .
        "go run .")

       ("go:Test"
        .
        "go test ./...")

       ("go:Fmt"
        .
        "go fmt ./...")

       ("go:Vet"
        .
        "go vet ./...")

       ("go:Mod Tidy"
        .
        "go mod tidy"))

     (when
         (executable-find "golangci-lint")

       '(("go:Lint"
          .
          "golangci-lint run")))

     (when
         (executable-find "air")

       '(("go:Air"
          .
          "air"))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; package.json helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/package-json ()

  (my/read-json-file
   (my/project-file "package.json")))

(defun my/package-dependencies ()

  (when-let ((package (my/package-json)))

    (append

     (alist-get 'dependencies package)

     (alist-get 'devDependencies package))))

(defun my/package-has (name)

  (assoc (intern name)
         (my/package-dependencies)))


(defun my/vite-tasks ()

  (when (my/package-has "vite")

    '(("vite:Dev"
       .
       "npm run dev")

      ("vite:Build"
       .
       "npm run build")

      ("vite:Preview"
       .
       "npm run preview"))))



(defun my/next-tasks ()

  (when (my/package-has "next")

    '(("next:Dev"
       .
       "npm run dev")

      ("next:Build"
       .
       "npm run build")

      ("next:Start"
       .
       "npm run start")

      ("next:Lint"
       .
       "npm run lint"))))


(defun my/astro-tasks ()

  (when (my/package-has "astro")

    '(("astro:Dev"
       .
       "npm run dev")

      ("astro:Build"
       .
       "npm run build")

      ("astro:Preview"
       .
       "npm run preview"))))
(defun my/nuxt-tasks ()

  (when (my/package-has "nuxt")

    '(("nuxt:Dev"
       .
       "npm run dev")

      ("nuxt:Build"
       .
       "npm run build")

      ("nuxt:Generate"
       .
       "npm run generate"))))

(defun my/react-native-tasks ()

  (when (my/package-has "react-native")

    '(("react-native:Android"
       .
       "npm run android")

      ("react-native:iOS"
       .
       "npm run ios"))))


(my/register-provider #'my/vite-tasks)

(my/register-provider #'my/next-tasks)

(my/register-provider #'my/astro-tasks)

(my/register-provider #'my/nuxt-tasks)

(my/register-provider #'my/react-native-tasks)


(provide 'compile-config)
