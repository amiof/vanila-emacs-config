;;; dap-config
;;; dap-config.el --- Main DAP configuration -*- lexical-binding: t; -*-

;; اگر خواستی از package.el نصب خودکار داشته باشی، این خط را باز کن:
(add-to-list 'load-path (expand-file-name "lisp/dap" user-emacs-directory))

(use-package dap-mode
  ;; اگر dap-mode را با package.el نصب می‌کنی، این را باز کن:
  :ensure t

  :commands
  (dap-debug
   dap-debug-edit-template)

  :hook
  ((lsp-mode . dap-mode)
   (dap-mode . dap-ui-mode))

  :config
  ;; Debug adapter modules
  (require 'dap-go)
  (require 'dap-lldb)
  (require 'dap-node)

  ;; Personal language templates/commands
  (require 'my-go-dap)
  (require 'my-rust-dap)
  (require 'my-ts-dap))

(provide 'dap-config)
;;; dap-config.el ends here
