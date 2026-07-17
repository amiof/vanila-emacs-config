;;; go-lang.el --- Go support -*- lexical-binding: t; -*-
;;
;; LSP binary: gopls
;;   go install golang.org/x/tools/gopls@latest
;;
;; Tree-sitter: go + gomod grammars via treesit-auto.

; (setq treesit-language-source-alist
;       '((go "https://github.com/tree-sitter/tree-sitter-go")
;         (gomod "https://github.com/camdencheek/tree-sitter-go-mod")))
;
;; این تابع به صورت خودکار در صورت نبودن گرامر، آن را نصب می‌کند
; (dolist (lang '(go gomod))
;   (unless (treesit-language-available-p lang)
;     (treesit-install-language-grammar lang)))



(use-package go-ts-mode
  :ensure nil
  :mode (("\\.go\\'"     . go-ts-mode)
         ("go\\.mod\\'"  . go-mod-ts-mode))
  :hook
  (go-ts-mode . lsp-deferred) 
  (go-ts-mode . subword-mode)
  :custom
  (go-ts-mode-indent-offset 4))

(provide 'go-lang)
;;; go-lang.el ends here
