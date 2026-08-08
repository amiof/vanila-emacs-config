(use-package projectile
  :ensure t
  :demand t
  :init
  (projectile-mode 1)
  (setq projectile-enable-caching t
        projectile-indexing-method 'hybrid

        projectile-globally-ignored-directories
        '(".git"
          "node_modules"
          "dist"
          "build"
          "out"
          "coverage"
          ".cache"
          ".next"
          ".nuxt"
          "__pycache__"
          ".venv"
          "venv"
          "env"
          "target"
          "vendor"
          "bower_components"
          ".gradle"
          ".idea")

        projectile-globally-ignored-files
        '("*.min.js"
          "*.js.map"
          "*.map"
          "*.log"
          "*.lock"
          "*.sqlite"
          "*.db"
          "*.zip"
          "*.tar.gz"
          "*.png"
          "*.jpg"
          "*.jpeg"
          "*.gif"
          "*.webp"
          "*.pdf"))

  :custom
  (projectile-completion-system 'default)
  ;; (projectile-enable-caching t)
  (projectile-indexing-method 'alien)
  (projectile-sort-order 'recently-active)
  (projectile-project-search-path
   '("~/Projects/"
     "~/Code/"
     "~/.config/"))

  :config
  (setq projectile-switch-project-action
        #'project-find-file))


(use-package consult-projectile
  :ensure t
  :after (consult projectile))

(use-package treemacs-projectile
  :ensure t
  :after (treemacs projectile))

(provide 'projectile-config)
