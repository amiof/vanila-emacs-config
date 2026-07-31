;;; my-ts-dap.el --- Node/TypeScript DAP configuration -*- lexical-binding: t; -*-

(defcustom my-dap-node-type "node"
  "DAP type for Node.js debugging.
Usually \"node\" works with dap-node.
If you use vscode-js-debug and your dap-node supports it, set this to
\"pwa-node\" before loading this file, then restart Emacs or re-run
`my-ts-dap-register'."
  :type 'string)

(defcustom my-ts-dap-js-debug-dir "~/.local/share/vscode-js-debug"
  "Directory where vscode-js-debug is installed, if installed manually."
  :type 'string)

(defun my-ts-dap--js-debug-path ()
  "Try to find a usable js-debug adapter path."
  (let ((base (expand-file-name my-ts-dap-js-debug-dir)))
    (cond
     ((file-exists-p (expand-file-name "out/src/dap.js" base))
      (expand-file-name "out/src/dap.js" base))

     ((file-exists-p (expand-file-name "src/dap.js" base))
      (expand-file-name "src/dap.js" base))

     ((file-exists-p (expand-file-name "dist/src/dap.js" base))
      (expand-file-name "dist/src/dap.js" base))

     ((file-directory-p base)
      base)

     (t nil))))

(defun my-ts-dap-register ()
  "Register Node and TypeScript debug templates."
  (interactive)
  (require 'dap-node)

  ;; If a manual js-debug installation exists, use it.
  (when-let* ((path (my-ts-dap--js-debug-path)))
    (setq dap-node-debug-path path))

  (unless (executable-find "node")
    (warn "Node.js not found in PATH. Node/TS debugging may fail."))

  (let ((tsx (executable-find "tsx"))
        (npx (executable-find "npx")))

    ;; Plain JavaScript
    (dap-register-debug-template
     "JS :: Run Current File"
     (list :type my-dap-node-type
           :request "launch"
           :name "JS Run"
           :program "${file}"
           :cwd "${workspaceFolder}"))

    ;; TypeScript via tsx
    (dap-register-debug-template
     "TS :: Run Current File (tsx)"
     (cond
      (tsx
       (list :type my-dap-node-type
             :request "launch"
             :name "TS Run (tsx)"
             :cwd "${workspaceFolder}"
             :runtimeExecutable tsx
             :runtimeArgs '("${file}")
             :console "integratedTerminal"))

      (npx
       (list :type my-dap-node-type
             :request "launch"
             :name "TS Run (npx tsx)"
             :cwd "${workspaceFolder}"
             :runtimeExecutable npx
             :runtimeArgs '("tsx" "${file}")
             :console "integratedTerminal"))

      (t
       (list :type my-dap-node-type
             :request "launch"
             :name "TS Run (npx tsx)"
             :cwd "${workspaceFolder}"
             :runtimeExecutable "npx"
             :runtimeArgs '("tsx" "${file}")
             :console "integratedTerminal"))))))

(defun my-ts-dap-setup ()
  "Download/setup Node debug adapter using dap-node-setup."
  (interactive)
  (require 'dap-node)

  (if (fboundp 'dap-node-setup)
      (progn
        (dap-node-setup)
        (my-ts-dap-register))
    (user-error "dap-node-setup is not available in this dap-node version")))

(with-eval-after-load 'dap-node
  (my-ts-dap-register))

(provide 'my-ts-dap)
;;; my-ts-dap.el ends here
