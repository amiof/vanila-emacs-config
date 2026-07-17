;;; evil.el

(use-package evil
  :init
  (setq evil-want-C-u-scroll t
        evil-want-Y-yank-to-eol t
        evil-want-integration t
        evil-want-keybinding nil)

  :config
  (evil-mode 1))


(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


; (use-package general
;   :config
;
;   (general-create-definer my-leader-def
;     :states '(normal visual motion)
;     :keymaps 'override
;     :prefix "SPC"
;     :global-prefix "C-SPC"))

(provide 'evil-config)
