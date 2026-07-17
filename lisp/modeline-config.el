;;; ========================================
;;; Mode-line Customization (Moody)
;;; ========================================

(use-package moody
  :config
  (setopt x-underline-at-descent-line t)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)
  (moody-replace-eldoc-minibuffer-message-function)

  (custom-set-faces
   '(mode-line ((t (:weight bold))))
   '(mode-line-inactive ((t (:weight normal :foreground unspecified :inherit shadow)))))

  (defun my/moody-evil-state-indicator ()
    "Display a colored circle indicating the current Evil state."
    (when (bound-and-true-p evil-mode)
      (let ((indicator (pcase evil-state
                         ('normal (propertize "⬤" 'face '(:foreground "#50fa7b")))
                         ('insert (propertize "⬤" 'face '(:foreground "#ff5555")))
                         ('visual (propertize "⬤" 'face '(:foreground "#8be9fd")))
                         ('emacs (propertize "⬤" 'face '(:foreground "#bd93f9")))
                         (_ (propertize "⬤" 'face '(:foreground "#6272a4"))))))
        (concat indicator " "))))

  (defun my/moody-project-name ()
    "Display project name in a ribbon."
    (when-let ((project (project-current)))
      (let ((name (file-name-nondirectory
                   (directory-file-name (project-root project)))))
        (format " %s " name))))

  (defun my/moody-buffer-icon-for-path (file-path)
    "Return custom icon for specific file paths, otherwise nil."
    (when file-path
      (cond
       ((string-match "\\.tsx?\\'" file-path)
        (cond
         ((string-match-p "yoda" file-path)
          (nerd-icons-icon-for-extension "vue" "nf-dev-vuejs")))))))

  (defun my/moody-buffer-icon ()
    "Display buffer state or file icon before filename.
Shows read-only or modified icons, otherwise shows file type icon."
    (let ((icon (cond
                 (buffer-read-only (nerd-icons-faicon "nf-fa-lock"))
                 ((buffer-modified-p) (nerd-icons-faicon "nf-fa-pencil"))
                 (t (if (and (display-graphic-p) buffer-file-name)
                        (or (my/moody-buffer-icon-for-path buffer-file-name)
                            (nerd-icons-icon-for-file (file-name-nondirectory buffer-file-name)))
                      (nerd-icons-icon-for-mode major-mode))))))
      (concat icon " ")))

  (defun my/moody-modes ()
    "Display major mode with icon in a ribbon."
    (let ((icon (when (display-graphic-p)
                  (nerd-icons-icon-for-mode major-mode))))
      (format " %s %s " (or icon "") (format-mode-line mode-name))))

  (defun my/moody-vc-branch ()
    "Display VC branch name with icon in a ribbon."
    (if (and vc-mode (buffer-file-name))
        (let* ((backend (vc-backend (buffer-file-name)))
               (branch (when backend
                        (substring-no-properties vc-mode
                                                (+ (if (eq backend 'Hg) 2 3) 2))))
               (icon (when (display-graphic-p)
                       (nerd-icons-devicon "nf-dev-git_branch" :face 'nerd-icons-purple))))
          (if branch
              (concat " " icon " " branch " ")
            ""))
      ""))

  (setq-default mode-line-format
                '("%e"
                  mode-line-front-space
                  (:eval (my/moody-evil-state-indicator))
                  (:eval (my/moody-project-name))
                  " "
                  (:eval (moody-tab (my/moody-vc-branch)))
                  " "
                  (:eval (concat (my/moody-buffer-icon) (format-mode-line mode-line-buffer-identification)))
                  "  "
                  (:eval (moody-tab (my/moody-modes)))
                  " "
                  mode-line-misc-info
                  mode-line-format-right-align
                  (:eval (moody-tab "%P %l:%c" nil 'up))
                  mode-line-end-spaces)))


(use-package minions
  :config
  (minions-mode 1))

(provide 'modeline-config)
