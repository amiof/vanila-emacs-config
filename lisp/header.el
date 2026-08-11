;;;header.el --- NANO Header Line ONLY  -*- lexical-binding: t -*-

;; --- Frame layout -----------------------------------------------------------
(setq default-frame-alist
      '((height . 40) (width  . 160) (left-fringe . 8) (right-fringe . 8)
        (internal-border-width . 20) (vertical-scroll-bars . nil)
        (bottom-divider-width . 0) (right-divider-width . 0)
        (undecorated-round . t)))

(modify-frame-parameters nil default-frame-alist)
(setq-default pop-up-windows nil)

;; --- select theme : 'light, 'dark, or 'gruvbox -----------------------------
(setq nano-header-theme 'gruvbox)

;; --- modes where header should not show ------------------------------------
(setq nano-header-excluded-modes
      '(dashboard-mode
        dired-mode
        ghostel-mode ; if you mean GPTel, use: gptel-mode
        magit-status-mode
        magit-log-mode
        ;; help-mode
        helpful-mode
        ;; Info-mode
        ;; compilation-mode
        ;; eshell-mode
        ;; term-mode
        vterm-mode
        ;; package-menu-mode
        ;; custom-mode
        ;; org-agenda-mode
        ;; special-mode
        ;; fundamental-mode
        ))

;; --- NANO faces (used exclusively by header) --------------------------------
(defface nano-default '((t)) "")   (defface nano-default-i '((t)) "")
(defface nano-highlight '((t)) "") (defface nano-highlight-i '((t)) "")
(defface nano-subtle '((t)) "")    (defface nano-subtle-i '((t)) "")
(defface nano-faded '((t)) "")     (defface nano-faded-i '((t)) "")
(defface nano-salient '((t)) "")   (defface nano-salient-i '((t)) "")
(defface nano-popout '((t)) "")    (defface nano-popout-i '((t)) "")
(defface nano-strong '((t)) "")    (defface nano-strong-i '((t)) "")
(defface nano-critical '((t)) "")  (defface nano-critical-i '((t)) "")

;; --- Set colors on nano faces ONLY ------------------------------------------
(defun nano-header-set-faces (fg bg strong subtle faded critical)
  "Set nano faces used by header. Does NOT touch default/mode-line/anything else."
  (set-face-attribute 'nano-default nil :foreground fg :background bg)
  (set-face-attribute 'nano-default-i nil :foreground bg :background fg)
  (set-face-attribute 'nano-strong nil :foreground strong :weight 'regular)
  (set-face-attribute 'nano-subtle nil :background subtle)
  (set-face-attribute 'nano-faded nil :foreground faded)
  (set-face-attribute 'nano-faded-i nil :foreground bg :background faded)
  (set-face-attribute 'nano-critical nil :foreground critical)
  (set-face-attribute 'nano-critical-i nil :foreground bg :background critical))

;; --- Header-line face -------------------------------------------------------
(defun nano-header-install ()
  "Style the header-line face. Nothing else is modified."
  (let ((box-color (or (face-background 'nano-default)
                       (face-background 'default))))
    (set-face-attribute 'header-line nil
                        :background 'unspecified
                        :underline nil
                        :box (when box-color
                               `(:line-width 1 :color ,box-color))
                        :inherit 'nano-subtle)))

;; --- Light / Dark / Gruvbox -------------------------------------------------
(defun nano-header-light ()
  "Apply light colors to header faces only."
  (interactive)
  (nano-header-set-faces "#37474F" "#FFFFFF" "#000000" "#ECEFF1" "#90A4AE" "#EBCB8B")
  (nano-header-install))

(defun nano-header-dark ()
  "Apply dark colors to header faces only."
  (interactive)
  (nano-header-set-faces "#ECEFF4" "#2E3440" "#ECEFF4" "#434C5E" "#677691" "#FF6F00")
  (nano-header-install))

(defun nano-header-gruvbox ()
  "Apply gruvbox colors to header faces only."
  (interactive)
  (nano-header-set-faces "#EBDBB2" "#282828" "#FBF1C7" "#504945" "#928374" "#FB4934")
  (nano-header-install))

;; --- Apply theme based on `nano-header-theme` -------------------------------
(pcase nano-header-theme
  ('dark  (nano-header-dark))
  ('light (nano-header-light))
  ('gruvbox (nano-header-gruvbox))
  (_      (nano-header-light)))

;; --- Header visibi
;;lity/content ----------------------------------------------
;; IMPORTANT:
;; Global default is nil. We enable the header buffer-locally only when needed.
(setq-default header-line-format nil)

(defun nano-header--excluded-p ()
  "Return non-nil if the Nano header should be hidden in this buffer."
  (or (minibufferp)
      (and (bound-and-true-p nano-header-excluded-modes)
           (apply #'derived-mode-p nano-header-excluded-modes))))

(defun nano-header--content ()
  "Return the header-line content for the current buffer."
  (let* ((prefix
          (cond (buffer-read-only     '("RO" . nano-default-i))
                ((buffer-modified-p)  '("**" . nano-critical-i))
                (t                    '("RW" . nano-faded-i))))

         (mode
          (concat "("
                  (downcase
                   (cond ((consp mode-name) (car mode-name))
                         ((stringp mode-name) mode-name)
                         (t "unknown")))
                  " mode)"))

         (coords
          (format-mode-line "%c:%l "))

         (breadcrumb
          (when (and (bound-and-true-p lsp-mode)
                     (fboundp 'lsp-headerline--build-string))
            (lsp-headerline--build-string))))

    (append
     (list
      (propertize " " 'face (cdr prefix) 'display '(raise -0.25))
      (propertize (car prefix) 'face (cdr prefix))
      (propertize " " 'face (cdr prefix) 'display '(raise +0.25))
      (propertize (format-mode-line " %b ") 'face 'nano-strong)
      (propertize mode 'face 'header-line))

     (when breadcrumb
       (list
        (propertize "  |  " 'face 'nano-faded)
        (propertize breadcrumb 'face 'nano-faded)))

     (list
      (propertize " " 'display `(space :align-to (- right ,(length coords))))

      ;; If you want line/column coordinates to actually appear,
      ;; uncomment the next line:
      ;; (propertize coords 'face 'nano-faded)
      ))))

(defun nano-header--apply ()
  "Enable or disable the Nano header in the current buffer."
  (unless (minibufferp)
    (setq-local header-line-format
                (if (nano-header--excluded-p)
                    nil
                  '(:eval (nano-header--content))))))

(defun nano-header-refresh-all ()
  "Re-apply Nano header visibility to all existing buffers."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (nano-header--apply))))

;; --- LSP breadcrumb: prevent override --------------------------------------
(setq lsp-headerline-breadcrumb-enable nil)

(defun my/restore-my-header-line ()
  "Disable LSP headerline breadcrumb and restore my Nano header."
  (when (fboundp 'lsp-headerline-breadcrumb-mode)
    (lsp-headerline-breadcrumb-mode -1))
  (nano-header--apply))

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-configure-hook #'my/restore-my-header-line t))

;; --- Apply automatically -----------------------------------------------------
(add-hook 'after-change-major-mode-hook #'nano-header--apply)

;; Apply to buffers that already exist.
(nano-header-refresh-all)

;; (provide 'nano-header)
(provide 'header)
;;; nano-header.el ends here
