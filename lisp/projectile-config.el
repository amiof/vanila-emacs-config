(use-package projectile
  :ensure t
  :demand t
  :init
  (projectile-mode 1)

  :custom
  (projectile-completion-system 'default)
  (projectile-enable-caching t)
  (projectile-indexing-method 'alien)
  (projectile-sort-order 'recently-active)
  (projectile-project-search-path
   '("~/Projects/"
     "~/Code/"
     "~/.config/"))

  :config
  (setq projectile-globally-ignored-directories
        '(".git"
          "node_modules"
          ".next"
          "dist"
          "build"
          "target"))

  (setq projectile-switch-project-action
        #'projectile-dired))


(use-package consult-projectile
  :ensure t
  :after (consult projectile))

(use-package treemacs-projectile
  :ensure t
  :after (treemacs projectile))

(provide 'projectile-config)
