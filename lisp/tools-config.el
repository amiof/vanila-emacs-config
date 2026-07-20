;;; tools-config.el

(use-package transient)
;; Git
(use-package magit
  :after transient
  :commands
  (magit-status
   magit-log))


;; Terminal
(use-package vterm
  :commands vterm)


;; Ripgrep integration
(use-package rg
  :after transient
  :commands rg)


;; Better help
(use-package helpful
  :commands
  (helpful-callable
   helpful-variable
   helpful-command
   helpful-key))


;;; for dont create lock file auto save file and backup file in emacs that create strang file in project
;; 1. Disable lockfiles completely (prevents .#filename files)
(setq create-lockfiles nil)

;; 2. Set up Doom-style paths in your vanilla config
(let ((cache-dir (concat user-emacs-directory ".local/cache/")))
  (setq backup-directory-alist `(("." . ,(concat cache-dir "backup/")))
        auto-save-file-name-transforms `((".*" ,(concat cache-dir "autosave/") t)))
  
  ;; Make sure the directories actually exist
  (make-directory (concat cache-dir "backup/") t)
  (make-directory (concat cache-dir "autosave/") t))
;;; end config 
;;;
;;;
;;;
(use-package avy
  :ensure t
  :config
  (setq avy-all-windows t))



;; 1. Install and configure core Treemacs
(use-package treemacs
  :ensure t
  :defer t
  :config
  (setq treemacs-no-png-images t
        treemacs-width 35
        treemacs-position 'left
        treemacs-is-never-other-window t)
  (treemacs-follow-mode 1)  
  (treemacs-project-follow-mode 1)
  (treemacs-resize-icons 22)
  (treemacs-filewatch-mode t))

;; 2. Evil mode integration
(use-package treemacs-evil
  :ensure t
  :after (treemacs evil))

;; 3. Use nerd-icons for directories and files
(use-package treemacs-nerd-icons
  :ensure t
  :after (treemacs nerd-icons)
  :config
  (treemacs-load-theme "nerd-icons"))



;; Enable relative line numbers globally
(use-package display-line-numbers
  :ensure nil ; Built-in package
  :init
  (setq display-line-numbers-type 'relative)
  :config
  (global-display-line-numbers-mode t))

;; (use-package popper
;;   :ensure t
;;   ;; `M-`' is already bound to `other-frame' in chadmacs-core, so popper-cycle
;;   ;; gets `C-M-<` instead of the upstream default.
;;   :bind (("C-`"   . popper-toggle)
;;          ("C-M-<" . popper-cycle)
;;          ("C-M-`" . popper-toggle-type))
;;   :init
;;   (setq popper-reference-buffers
;;         '("\\*Messages\\*"
;;           "Output\\*$"
;;           "\\*Async Shell Command\\*"
;;           "\\*compilation\\*"
;;           "\\*Warnings\\*"
;;           "\\*Backtrace\\*"
;;           "\\*eldoc\\*"
;;           "\\*ghostel"          ; matches *ghostel*, *ghostel-compile*, *ghostel: DIR*
;;           "\\*ts-ls\\*"
;;           "\\*lsp-log\\*"
;;           help-mode
;;           helpful-mode
;;           compilation-mode
;;           eshell-mode
;;           shell-mode
;;           ghostel-mode))
;;   (popper-mode 1)
;;   (popper-echo-mode 1))




(use-package diff-hl
  :ensure t
  :init
  (global-diff-hl-mode)
  :config
  ;; Enable on-the-fly updates as you type
  (diff-hl-flydiff-mode 1)
  (setq diff-hl-side 'left)
  (setq-default left-fringe-width 3)
  (setq-default right-fringe-width 8)
  ;; Integration with Magit (reloads gutter when you commit/stage in Magit)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

  ;; Example Keybindings for your configuration:
  (with-eval-after-load 'evil
    ;; Jump between git changes using [c and ]c in normal mode
    (evil-define-key 'normal 'global (kbd "]c") 'diff-hl-next-hunk)
    (evil-define-key 'normal 'global (kbd "[c") 'diff-hl-previous-hunk)
    
    ;; Leader bindings to show/revert changes (e.g., Space g r to revert)
    ;; Replace 'general' or 'evil-leader' syntax below with whatever you use:
     (evil-define-key 'normal 'global (kbd "SPC g s") 'diff-hl-show-hunk)
     (evil-define-key 'normal 'global (kbd "SPC g r") 'diff-hl-revert-hunk)
    ))

(provide 'tools-config)
