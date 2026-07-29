;;; compiles.el 

(use-package compile-multi
  :ensure t
  :bind
  (("C-c c" . compile-multi)
   ("C-c r" . compile-multi-rerun)))


(use-package consult-compile-multi
  :ensure t
  :after compile-multi
  :demand t
  :config (consult-compile-multi-mode))


(with-eval-after-load 'compile-multi
(setq compile-multi-default-directory
      (lambda ()
        (when-let ((project (project-current)))
          (project-root project))))
(push
 '(
   (file-exists-p "Cargo.toml")
   ("cargo:Build" . "cargo build")
   ("cargo:Run" . "cargo run")
   ("cargo:Test" . "cargo test"))
 compile-multi-config)

(push
 '(
   (file-exists-p "go.mod")
   ("go:Build" . "go build")
   ("go:Run" . "go run .")
   ("go:Test" . "go test ./..."))
 compile-multi-config)

(push
 '(
   (file-exists-p "package.json")
   ("node:Dev" . "pnpm dev")
   ("node:Build" . "pnpm build")
   ("node:Test" . "pnpm test"))
 compile-multi-config)
)
(use-package compile-multi-nerd-icons
  :after (compile-multi nerd-icons-completion)
  :config
  (compile-multi-nerd-icons-mode))


(provide 'compiles)
;;;
