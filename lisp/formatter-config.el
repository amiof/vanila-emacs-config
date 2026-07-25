
(setq lsp-format-buffer-on-save nil)
(use-package apheleia
  :config
  (apheleia-global-mode +1)

  ;; Rust
  (setf (alist-get 'rust-mode apheleia-mode-alist) 'rustfmt)

  ;; Go
  (setf (alist-get 'go-mode apheleia-mode-alist) 'goimports)

  ;; JS/TS
  (setf (alist-get 'typescript-ts-mode apheleia-mode-alist)
        'my/biome)
  (setf (alist-get 'tsx-ts-mode apheleia-mode-alist)
        'my/biome)
  (setf (alist-get 'js-ts-mode apheleia-mode-alist)
        'my/biome)

  (setf (alist-get 'my/biome apheleia-formatters)
        '("biome" "format" "--stdin-file-path" filepath)))

(provide 'formatter-config)
;;;
