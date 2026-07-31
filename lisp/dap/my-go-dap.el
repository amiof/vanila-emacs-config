;;; my-go-dap.el --- Go DAP configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'dap-mode
  (require 'dap-go)

  (unless (executable-find "dlv")
    (warn "Go debugger 'dlv' not found in PATH. Install delve."))

  (dap-register-debug-template
   "Go :: Debug (auto)"
   (list :type "go"
         :request "launch"
         :name "Go Debug"
         :mode "auto"
         :program "${workspaceFolder}"
         :cwd "${workspaceFolder}")))

(defun my-go-debug ()
  "Debug current Go project using dap-go."
  (interactive)
  (require 'dap-go)

  (let* ((root
          (or (and (fboundp 'lsp-workspace-root)
                   (lsp-workspace-root default-directory))
              (locate-dominating-file default-directory "go.mod")
              default-directory)))

    (unless (executable-find "dlv")
      (user-error "Go debugger 'dlv' not found. Install: go install github.com/go-delve/delve/cmd/dlv@latest"))

    (dap-debug
     (list :type "go"
           :request "launch"
           :name "Go Debug"
           :mode "auto"
           :program root
           :cwd root))))

(provide 'my-go-dap)
;;; my-go-dap.el ends here
