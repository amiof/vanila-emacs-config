;;; rust-lang.el
;;;

(use-package rust-mode
  :ensure t
  :defer t
  :init
  (setq rust-mode-treesitter-derive t))

(use-package rustic
  :ensure t
  :after rust-mode
  :mode ("\\.rs\\'" . rustic-mode)
  :custom
  (rustic-cargo-use-last-stored-arguments t)
  :config
  ;; Disable rustic's default save formatting if you prefer LSP/apheleia to do it
  (setq rustic-format-on-save nil)
  
  ;; Tell rustic to use lsp-mode instead of eglot
  (setq rustic-lsp-client 'lsp-mode)

  ;; Ensure Flycheck is used instead of Flymake (since you use Flycheck globally)
  (add-hook 'rustic-mode-hook
            (lambda ()
              (flymake-mode -1)
              (flycheck-mode 1))))

(add-hook 'rust-ts-mode-hook #'lsp-deferred)

(provide 'rust-lang)
;;; rust-lang.el ends here
