;;; formatter-config.el -*- lexical-binding: t; -*-

;; Disable LSP automatic formatting on save.
(setq lsp-format-buffer-on-save nil)
(setq lsp-organize-imports-on-save nil)
(setq lsp-enable-on-type-formatting nil)

;; Disable ESLint auto-fix on save.
(setq lsp-eslint-auto-fix-on-save nil)

(use-package apheleia
  :init
  (setq apheleia-mode-alist
        '((rust-mode . rustfmt)
          (go-mode . goimports)

          ;; Emacs Lisp
          (emacs-lisp-mode . lisp-indent)

          ;; Tree-sitter JS/TS
          (js-ts-mode . my/biome)
          (typescript-ts-mode . my/biome)
          (tsx-ts-mode . my/biome)

          ;; Classic JS/TS
          (js-mode . my/biome)
          (typescript-mode . my/biome)))

  :config
  ;; Use project-local Biome through npx.
  (setf (alist-get 'my/biome apheleia-formatters)
        '("npx" "--no-install" "biome"
          "format"
          "--stdin-file-path"
          filepath))

  ;; Keep Apheleia enabled globally so every other language
  ;; continues to behave normally.
  (apheleia-global-mode +1)

  ;; Detect whether the current project uses Biome.
  (defun my/biome-project-p ()
    (let ((dir (or (and buffer-file-name
                        (file-name-directory buffer-file-name))
                   default-directory)))
      (or (locate-dominating-file dir "biome.json")
          (locate-dominating-file dir "biome.jsonc")
          (locate-dominating-file dir "node_modules/.bin/biome")
          (locate-dominating-file dir "node_modules/.bin/biome.cmd")
          (locate-dominating-file dir "node_modules/.bin/biome.exe"))))

  ;; For JS/TS only:
  ;; If this isn't a Biome project, disable Apheleia in this buffer.
  (defun my/maybe-disable-apheleia ()
    (unless (my/biome-project-p)
      (apheleia-mode -1)))

  (dolist (hook '(js-ts-mode-hook
                  tsx-ts-mode-hook
                  typescript-ts-mode-hook
                  js-mode-hook
                  typescript-mode-hook))
    (add-hook hook #'my/maybe-disable-apheleia)))

(provide 'formatter-config)
