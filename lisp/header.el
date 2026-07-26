(setq default-frame-alist
      '((height . 40) (width  . 130) (left-fringe . 0) (right-fringe . 0)
        (internal-border-width . 20) (vertical-scroll-bars . nil)
        (bottom-divider-width . 0) (right-divider-width . 0)
        (undecorated-round . t)))
(modify-frame-parameters nil default-frame-alist)


;; --- Minimal NANO (not a real) theme ----------------------------------------
(defface nano-default '((t)) "")   (defface nano-default-i '((t)) "")
(defface nano-highlight '((t)) "") (defface nano-highlight-i '((t)) "")
(defface nano-subtle '((t)) "")    (defface nano-subtle-i '((t)) "")
(defface nano-faded '((t)) "")     (defface nano-faded-i '((t)) "")
(defface nano-salient '((t)) "")   (defface nano-salient-i '((t)) "")
(defface nano-popout '((t)) "")    (defface nano-popout-i '((t)) "")
(defface nano-strong '((t)) "")    (defface nano-strong-i '((t)) "")
(defface nano-critical '((t)) "")  (defface nano-critical-i '((t)) "")


;;---------------------------------- stop load lsp breadcrumb for confilict with header
(setq-default pop-up-windows nil)
(setq lsp-headerline-breadcrumb-enable nil)

(defun my/restore-my-header-line ()
  "Disable LSP headerline breadcrumb and force my header line."
  (when (fboundp 'lsp-headerline-breadcrumb-mode)
    (lsp-headerline-breadcrumb-mode -1))

  ;; Force this buffer to use your default header-line-format
  (setq-local header-line-format (default-value 'header-line-format)))

(with-eval-after-load 'lsp-mode
  ;; Restore after LSP opens/connects/initializes
  (add-hook 'lsp-after-open-hook        #'my/restore-my-header-line t)
  (add-hook 'lsp-after-initialize-hook  #'my/restore-my-header-line t)
  (add-hook 'lsp-managed-mode-hook      #'my/restore-my-header-line t)
  (add-hook 'lsp-configure-hook         #'my/restore-my-header-line t))

(setq-default header-line-format
	      '(:eval
		(let ((prefix (cond (buffer-read-only     '("RO" . nano-default-i))
				    ((buffer-modified-p)  '("**" . nano-critical-i))
				    (t                    '("RW" . nano-faded-i))))
		      (mode (concat "(" (downcase (cond ((consp mode-name) (car mode-name))
							((stringp mode-name) mode-name)
							(t "unknow")))
				    " mode)"))
		      (coords (format-mode-line "%c:%l "))
		      (breadcrumb
		       (when (bound-and-true-p lsp-mode)
			 (lsp-headerline--build-string)))

		      )
		  (list
		   (propertize " " 'face (cdr prefix)  'display '(raise -0.25))
		   (propertize (car prefix) 'face (cdr prefix))
		   (propertize " " 'face (cdr prefix) 'display '(raise +0.25))
		   (propertize (format-mode-line " %b ") 'face 'nano-strong)
		   (propertize mode 'face 'header-line)
		   (when breadcrumb
		     (list
		      (propertize "  |  " 'face 'shadow)
		      breadcrumb))
		   ;; (propertize " " 'display `(space :align-to (- right ,(length coords))))
		   ;; (propertize coords 'face 'nano-faded)
		   ))
		))


;; ;; (defun nano-minibuffer--setup ()
;;   (set-window-margins nil 3 0)
;;   (let ((inhibit-read-only t))
;;     (add-text-properties (point-min) (+ (point-min) 1)
;; 			 `(display ((margin left-margin)
;; 				    ,(format "# %s" (substring (minibuffer-prompt) 0 1))))))
;;   (setq truncate-lines t))
;; (add-hook 'minibuffer-setup-hook #'nano-minibuffer--setup)

(provide 'header)
