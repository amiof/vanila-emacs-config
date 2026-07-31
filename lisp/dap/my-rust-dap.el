;;; my-rust-dap.el --- Rust DAP configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'dap-lldb
  (let ((debugger
         (or (executable-find "codelldb")
             (executable-find "lldb-vscode")
             (executable-find "lldb-dap"))))
    (if debugger
        (setq dap-lldb-debug-program (list debugger))
      (warn "No Rust/lldb debugger found. Install codelldb or lldb-vscode.")))

  ;; این template برای زمانی است که می‌خواهی از منوی dap-debug انتخاب کنی
  ;; و قبل از اجرا برنامه را دستی ویرایش کنی.
  (dap-register-debug-template
   "Rust :: Edit Then Run"
   (list :type "lldb"
         :request "launch"
         :name "Rust Run"
         :cwd "${workspaceFolder}"
         :program "${workspaceFolder}/target/debug/CHANGE_ME")))

(defun my-rust-debug ()
  "Debug a Rust binary from target/debug with prompt."
  (interactive)
  (require 'dap-lldb)

  (let* ((root
          (or (and (fboundp 'lsp-workspace-root)
                   (lsp-workspace-root default-directory))
              (locate-dominating-file default-directory "Cargo.toml")
              default-directory))

         (default-binary
          (file-name-nondirectory
           (directory-file-name root)))

         (binary
          (read-string
           (format "Rust binary inside target/debug (default %s): "
                   default-binary)
           nil nil default-binary))

         (program
          (expand-file-name
           (concat "target/debug/" binary)
           root)))

    (unless (and (boundp 'dap-lldb-debug-program)
                 (car dap-lldb-debug-program))
      (user-error "dap-lldb-debug-program is not set. Install codelldb."))

    (unless (file-exists-p program)
      (user-error
       "Binary not found: %s. Run `cargo build` first."
       program))

    (dap-debug
     (list :type "lldb"
           :request "launch"
           :name (format "Rust Run %s" binary)
           :cwd root
           :program program))))

(provide 'my-rust-dap)
;;; my-rust-dap.el ends here
