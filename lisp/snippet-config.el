(use-package snippy
  ;; Fetch directly from the GitHub repository (equivalent to your package! recipe)
  :vc (:url "https://github.com/MiniApollo/snippy.git"
       :branch "main"
       :rev :newest)
  :init
  ;; Enable globally (equivalent to your Doom global-snippy-minor-mode configuration)
  (global-snippy-minor-mode +1)
  :config
  ;; Custom settings
  (setq snippy-global-languages '("global"))
  
  ;; Update/install your snippets automatically
  (snippy-install-or-update-snippets)

  ;; Hook snippy into the Emacs Completion-At-Point functions (CAPF)
  (add-hook 'completion-at-point-functions #'snippy-capf)

  ;; Configure Emacs major modes to map to VSCode/LSP language identifiers
  (with-eval-after-load 'snippy
    (add-to-list 'snippy-emacs-to-vscode-lang-alist '(rustic-mode "rust" "rustdoc"))))



(provide 'snippet-config)
