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

(use-package popper
  :ensure t
  ;; `M-`' is already bound to `other-frame' in chadmacs-core, so popper-cycle
  ;; gets `C-M-<` instead of the upstream default.
  :bind (("C-`"   . popper-toggle)
         ("C-M-<" . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          "\\*compilation\\*"
          "\\*Warnings\\*"
          "\\*Backtrace\\*"
          "\\*eldoc\\*"
          "\\*ghostel"          ; matches *ghostel*, *ghostel-compile*, *ghostel: DIR*
          "\\*ts-ls\\*"
          "\\*lsp-log\\*"
          help-mode
          helpful-mode
          compilation-mode
          eshell-mode
          shell-mode
          ghostel-mode))
  (popper-mode 1)
  (popper-echo-mode 1))




(use-package diff-hl
  :ensure t
  :config
  ;; Show changes on the left side
  (setq diff-hl-side 'left)

  ;; ---------------------------------------------------------------------------
  ;; Fringe width = 8
  ;; ---------------------------------------------------------------------------
  (setq-default left-fringe-width 8
                right-fringe-width 8)

  (when (display-graphic-p)
    (modify-frame-parameters nil '((left-fringe . 8)
                                   (right-fringe . 8))))

  (setq default-frame-alist
        (append '((left-fringe . 8)
                  (right-fringe . 8))
                (assq-delete-all 'left-fringe
                                 (assq-delete-all 'right-fringe
                                                  default-frame-alist))))

  ;; ---------------------------------------------------------------------------
  ;; Custom diff-hl bitmap
  ;; ---------------------------------------------------------------------------
  (defun my-diff-hl-define-bitmap (&optional frame)
    (when (display-graphic-p frame)
      (let* ((height (max 1 (frame-char-height frame)))
             (width 4) 
             (bits (make-vector height (1- (expt 2 width)))))
        (define-fringe-bitmap 'my-diff-hl-bitmap
          bits
          height
          width
          'center))))

  (my-diff-hl-define-bitmap)
  (add-hook 'after-make-frame-functions #'my-diff-hl-define-bitmap)

  (setq diff-hl-fringe-bmp-function
        (lambda (&rest _args) 'my-diff-hl-bitmap))

  ;; ---------------------------------------------------------------------------
  ;; Sync diff-hl face backgrounds with active theme
  ;; ---------------------------------------------------------------------------
  (defun my-diff-hl-sync-face-backgrounds ()
    "Set diff-hl face backgrounds to match the current fringe/default background."
    (when (facep 'diff-hl-insert)
      (let ((bg (or (face-background 'fringe nil 'default)
                    (face-background 'default nil 'default)
                    (frame-parameter nil 'background-color))))
        (when (stringp bg)
          (set-face-background 'diff-hl-insert bg)
          (set-face-background 'diff-hl-delete bg)
          (set-face-background 'diff-hl-change bg)))))

  (defun my-diff-hl-after-theme-advice (&rest _args)
    "Reapply diff-hl face backgrounds after theme changes."
    (my-diff-hl-sync-face-backgrounds))

  (my-diff-hl-sync-face-backgrounds)
  (add-hook 'after-load-theme-hook #'my-diff-hl-sync-face-backgrounds)
  (advice-add 'load-theme :after #'my-diff-hl-after-theme-advice)
  (advice-add 'enable-theme :after #'my-diff-hl-after-theme-advice)

  ;; ---------------------------------------------------------------------------
  ;; Magit integration
  ;; ---------------------------------------------------------------------------
  (add-hook 'magit-pre-refresh-hook #'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)

  ;; ---------------------------------------------------------------------------
  ;; Evil keybindings
  ;; ---------------------------------------------------------------------------
  (with-eval-after-load 'evil
    (evil-define-key 'normal 'global (kbd "]c") #'diff-hl-next-hunk)
    (evil-define-key 'normal 'global (kbd "[c") #'diff-hl-previous-hunk))

  ;; ---------------------------------------------------------------------------
  ;; Enable diff-hl
  ;; ---------------------------------------------------------------------------
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1))


(use-package dashboard
  :ensure t
  :config
  ;; لوگو (فعلاً لوگوی پیش‌فرض Emacs - بعداً عوضش کن)
  ;; (setq dashboard-banner-logo-title "Welcom")
  ;; (setq dashboard-startup-banner 'official)  ;; لوگوی رسمی Emacs
  ;; (setq dashboard-startup-banner "/home/amir/.config/emacs/rz3.png")
  (setq dashboard-startup-banner (expand-file-name "assets/logo.png" user-emacs-directory))

  ;; آیتم‌های صفحه شروع
  (setq dashboard-items
        '((recents   . 10)    ;; ۱۰ فایل اخیر
          (projects   . 5)    ;; ۵ پروژه اخیر
          (bookmarks  . 5)))  ;; ۵ بوکمارک

  ;; آیکون‌ها
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)

  ;; فوتر
  (setq dashboard-footer-messages '("Emacs is ready."))

  ;; مرکز‌چین کردن
  (setq dashboard-center-content t)

  ;; فعال‌سازی
  (dashboard-setup-startup-hook))



;; lsp-tailwindcss that is in local lsp-mode

(with-eval-after-load 'lsp-mode
  (require 'lsp-tailwindcss nil t)

  ;; اگر تابع setup یا enable خاصی داشت
  (when (fboundp #'lsp-tailwindcss-setup)
    (lsp-tailwindcss-setup)))


;; for use consult for gD in go to refreance
(use-package xref
  :custom
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref))


;;; Ghostel
(use-package ghostel
  :commands (ghostel ghostel-project)
  :init
  ;; Ghostel automatically downloads its native module on first run.
  )

(use-package evil-ghostel
  :after (ghostel evil)
  :hook (ghostel-mode . evil-ghostel-mode))

(add-to-list
 'display-buffer-alist
 '("^\\*ghostel.*\\*?$"
   (display-buffer-in-side-window)
   (side . bottom)
   (window-height . 0.35)
   (slot . 0)))

(defun my/ghostel-full-window ()
  "Open Ghostel in the current window."
  (interactive)
  (let ((display-buffer-alist nil))
    (ghostel)))

;; hightlight todo 
(use-package hl-todo
  :ensure t
  :custom
  (hl-todo-highlight-punctuation ":")
  (hl-todo-keyword-faces
   '(("TODO"  . warning)
     ("FIXME" . error)
     ("NOTE"  . success)
     ("HACK"  . font-lock-warning-face)
     ("BUG"   . error)
     ("XXX"   . font-lock-warning-face)))
  :config
  (global-hl-todo-mode 1))

;; for edit a name mutli select
(use-package iedit
  :ensure t
  :bind (("C-;" . iedit-mode)
         ("C-c ;" . iedit-mode)))

(use-package expand-region
  :ensure t
  :bind
  (("C-=" . er/expand-region)
   ("C--" . er/contract-region)))


;; for undo and redo windows
(use-package winner
  :ensure nil
  :config
  (winner-mode 1)
  (setq winner-ring-size 100)
  (setq winner-boring-buffers
        '("*Completions*"
          "*Help*"
          "*Messages*"
          "*which-key*"
          "*Compile-Log*"
          "*lsp-log*"
          "*Backtrace*")))


;; for change auto cloes tag name when change first tag name
(use-package auto-rename-tag
  :ensure t
  :hook (prog-mode . auto-rename-tag-mode))

;; for move text with M-j and M-K
(use-package move-text
  :ensure t )


(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  ;; نمایش بهتر راهنمای کلیدها
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; مخفی کردن mode-line در پنجره‌های Embark Collect
  (add-to-list
   'display-buffer-alist
   '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
     nil
     (window-parameters (mode-line-format . none)))))


(use-package embark-consult
  :after (embark consult)
  :config
  (add-hook 'embark-collect-mode-hook
            #'consult--default-completion-list-preview-setup))




(use-package crux
  :bind
  (;; file
   ("C-a"     . crux-move-beginning-of-line)
   ("C-k"     . crux-smart-kill-line)
   ("C-c D"   . crux-delete-file-and-buffer)
   ("C-c R"   . crux-rename-file-and-buffer)
   ("C-c C-k" . crux-kill-other-buffers)

   ;; edit
   ("C-c d"   . crux-duplicate-current-line-or-region)
   ("C-c M-d" . crux-duplicate-and-comment-current-line-or-region)
   ("C-c o"   . crux-open-with)

   ;;buffer
   ("C-x 4 t" . crux-transpose-windows)
   ("C-c s"   . crux-swap-windows)

   ;; command
   ("C-c u"   . crux-view-url)
   ("C-c e"   . crux-eval-and-replace)))

(use-package wgrep
  :defer t
  :config
  (setq wgrep-auto-save-buffer t))

;; colorize dired 
(use-package diredfl
  :ensure t
  :config
  (diredfl-global-mode 1))

(use-package imenu-list
  :bind
  ("C-c s" . imenu-list-smart-toggle))

;;added for kotlin maybe dont need 
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "JAVA_HOME"))

(provide 'tools-config)
