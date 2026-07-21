;;; lsp-config.el
;;;

;; ==========================================
;; 1. TREE-SITTER SETUP
;; ==========================================
(setq treesit-extra-load-path (list (expand-file-name "tree-sitter" user-emacs-directory)))

(setq treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        
        ;; Web & Config Languages
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        
        ;; Backend & Scripting Languages
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (java "https://github.com/tree-sitter/tree-sitter-java")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
        (ruby "https://github.com/tree-sitter/tree-sitter-ruby")
        
        ;; Devops / Ops
        (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
        (cmake "https://github.com/uyha/tree-sitter-cmake")
        (markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split" "tree-sitter-markdown/src")
        (markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split" "tree-sitter-markdown-inline/src")))


(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install nil)
  :config
  (treesit-auto-add-to-auto-mode-alist)
  (global-treesit-auto-mode))

 (setq treesit-font-lock-level 4)
;; ==========================================
;; 2. FLYCHECK SETUP
;; ==========================================
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode)
  :config
  ;; Completely disable the buggy built-in cargo and rust checkers
  (setq flycheck-indication-mode 'right-margin)
  (setq-default flycheck-disabled-checkers '(rust-cargo rust)))

;; If you want flycheck-rust integration, install it properly:
(use-package flycheck-rust
  :ensure t
  :after (flycheck rust-mode)
  :hook (flycheck-mode . flycheck-rust-setup))


;; ==========================================
;; 3. LSP MODE & UI
;; ==========================================
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq
   lsp-auto-guess-root t

   ;; hints
   lsp-inlay-hint-enable t

   ;; diagnostics
   lsp-diagnostics-provider :flycheck

   ;; UI
   lsp-headerline-breadcrumb-enable t

   ;; performance
   lsp-idle-delay 0.3
   lsp-log-io nil
   lsp-enable-file-watchers nil

   ;; features
   lsp-enable-symbol-highlighting t
   lsp-enable-snippet t
   lsp-enable-on-type-formatting t)
  (lsp-enable-which-key-integration))

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  (setq
   lsp-ui-doc-enable t
   lsp-ui-doc-show-with-cursor nil
   lsp-ui-doc-show-with-mouse t
   lsp-ui-doc-position 'at-point
   lsp-ui-doc-use-childframe t
   lsp-ui-doc-max-width 150
   lsp-ui-doc-max-height 40
   lsp-ui-doc-delay 0.2

   lsp-ui-sideline-enable t
   lsp-ui-sideline-show-hover t  
   lsp-ui-sideline-show-diagnostics t
   lsp-ui-sideline-show-code-actions t

   lsp-ui-peek-enable t
   lsp-ui-imenu-enable t)

  ;; کلیدهای داکیومنت
  (evil-define-key 'normal lsp-ui-mode-map
    (kbd "F") #'lsp-ui-doc-focus-frame
    (kbd "q") #'lsp-ui-doc-hide))

;; کلید K در مپ اصلی LSP
(with-eval-after-load 'lsp-mode
  (evil-define-key 'normal lsp-mode-map
    (kbd "K") #'lsp-ui-doc-show))

;; هوک طلایی: بیدار کردن lsp-ui-doc با تعویض مود خودکار
(add-hook 'lsp-ui-mode-hook
          (lambda ()
            (run-with-idle-timer 0.3 nil
                                 (lambda ()
                                   (when (and (bound-and-true-p evil-mode)
                                              (eq evil-state 'normal)
                                              (not (minibufferp)))
                                     (evil-insert-state)
                                     (evil-normal-state)
                                     (redisplay t))))))


;; ==========================================
;; 4. LANGUAGE MODES
;; ==========================================

;; TypeScript & TSX
; (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
; (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))

;; Go
; (use-package go-mode
;   :ensure t
;   :mode "\\.go\\'")

;; Rust
; (use-package rust-mode
;   :ensure t
;   :mode "\\.rs\\'")


;; ==========================================
;; 5. DEBUGGER
;; ==========================================
(use-package dape
  :ensure t
  :commands dape
  :config
  (setq dape-buffer-window-arrangement 'right))

(provide 'lsp-config)
;;; lsp-config.el ends here
