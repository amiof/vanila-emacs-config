;;; completion-config.el

;; Vertico - minibuffer completion UI
(use-package vertico
  :init
  (vertico-mode)
  :bind
  (:map vertico-map
        ("TAB" . vertico-next)
        ("<tab>" . vertico-next)
        ("S-TAB" . vertico-previous)
	("<backtab>" . vertico-previous)))


;; Better matching
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion)))))


;; Extra information in minibuffer
(use-package marginalia
  :init
  (marginalia-mode))


;; Search and navigation commands
(use-package consult
  :bind
  (:map consult-narrow-map
        ("TAB" . consult-narrow-help)))

(with-eval-after-load 'consult
  ;; Add patterns to the ignore filter
  (let ((ignored-buffers '( "^\\*Messages\\*$"
                            "^\\*lsp-log"
                            "::stderr\\*$"
                            "^\\*Help\\*$"
                            "^\\*scratch\\*$"
                            "^\\*ts-ls\\*$"
                            "^\\*Buffer List\\*$"
                            "^\\*Compile-Log\\*$")))
    (dolist (pattern ignored-buffers)
      (add-to-list 'consult-buffer-filter pattern))))

;; Completion popup (like VSCode suggestions)
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :bind
  ;; Bind C-SPC (and C-@ as a fallback) to manually force the completion popup
  (("C-SPC" . completion-at-point)
   ("C-@"   . completion-at-point)
   (:map corfu-map
         ("TAB" . corfu-next)
         ("<tab>" . corfu-next)
         ("S-TAB" . corfu-previous)
         ("<backtab>" . corfu-previous)))
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-auto-delay 0.2)
  (corfu-min-width 30)
  ;; Start auto-suggesting after typing just 1 character instead of the default 3
  (corfu-auto-prefix 1))


;; Completion extensions
(use-package cape
  :init

  ;; complete from file
  (add-to-list 'completion-at-point-functions #'cape-file)

  ;; complete from dabbrev
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))


(provide 'completion-config)
