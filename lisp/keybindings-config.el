;;; keybindings-config.el

(use-package which-key
  :config
  (which-key-mode))


(use-package general
  :demand t
  :config

  (general-create-definer my-leader-def
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")


  ;; Files
  (my-leader-def
    "f f" 'find-file
    "f r" 'consult-recent-file
    "f s" 'save-buffer)


  ;; Buffers
  (my-leader-def
    "b b" 'consult-buffer
    "b d" 'kill-current-buffer)

  (my-leader-def
    "SPC" 'consult-buffer
    )

  ;; Search
  (my-leader-def
    "s s" 'consult-ripgrep
    "s b" 'consult-line)


  ;; Git
  (my-leader-def
    "g g" 'magit-status)


  ;; LSP / Code
  (my-leader-def
    "c a" 'lsp-execute-code-action
    "c d" 'lsp-describe-thing-at-point
    "c f" 'lsp-format-buffer
    "c r" 'lsp-find-references
    "r r" 'lsp-rename
    "c y" 'flycheck-copy-errors-as-kill
    "c y" 'flycheck-copy-errors-as-kill 
    "["   'evil-jump-backward         
    "]"   'evil-jump-forward
    )

(my-leader-def
    "p t" 'popper-toggle
    "p c" 'popper-cycle
    "p k" 'popper-toggle-type)

(my-leader-def
    "o p" 'treemacs
    "o f" 'treemacs-find-file)

  ;; Help
  (my-leader-def
    ; "h f" 'describe-function
    ; "h v" 'describe-variable
    ; "h k" 'describe-key
    "h f" 'helpful-callable
    "h v" 'helpful-variable
    "h k" 'helpful-key
    "h c" 'helpful-command)

  (my-leader-def
    "w d" 'delete-window
  "w h"'evil-window-left
  "w j" 'evil-window-down
  "w k" 'evil-window-up
  "w l" 'evil-window-right
    )

  ;; Terminal
  (my-leader-def
    "t t" 'vterm))


(with-eval-after-load 'lsp-ui
  (evil-define-key 'normal lsp-ui-mode-map
    (kbd "K") #'lsp-ui-doc-show
    (kbd "F") #'lsp-ui-doc-focus-frame
    (kbd "q") #'lsp-ui-doc-hide))



(use-package evil-escape
  :ensure t
  :init
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.15) ; time window in seconds to press 'k' after 'j'
  :config
  (evil-escape-mode 1))

(with-eval-after-load 'evil
 ; (evil-set-leader 'normal (kbd "SPC"))
  (define-key evil-normal-state-map (kbd "H") #'evil-first-non-blank)
  (define-key evil-normal-state-map (kbd "L") #'evil-end-of-line)
  (define-key evil-normal-state-map (kbd "f") #'avy-goto-char)
  (define-key evil-normal-state-map (kbd "t") #'avy-goto-line)
;; 'm' goes to the next tab
  (define-key evil-normal-state-map (kbd "m") #'centaur-tabs-forward)
  ;; 'M' goes to the previous tab
  (define-key evil-normal-state-map (kbd "M") #'centaur-tabs-backward)

  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
  (define-key evil-normal-state-map (kbd "J") 'other-window)
  )


;; dont show tab start with * 
; (with-eval-after-load 'centaur-tabs
;   (defun centaur-tabs-hide-tab (buffer)
;     "Do not show internal, log, and process buffers in centaur-tabs."
;     (let ((name (buffer-name buffer)))
;       (or
;        ;; Default: Hide buffers in dedicated windows
;        (window-dedicated-p (selected-window))
;
;        ;; Hide specific unwanted buffers
;        (string-prefix-p "*Messages*" name)
;        (string-prefix-p "*lsp-log*" name)
;        (string-suffix-p "*::stderr*" name)
;        (string-prefix-p "*Help*" name)
;        (string-prefix-p "*Compile-Log*" name)
;        (string-prefix-p "*ts-ls*" name)
;        (string-prefix-p "*Buffer List*" name)
;        (string-prefix-p "*scratch*" name)
;        (string-prefix-p "*ts-ls::stderr*" name)
;
;        ;; Optional: Hide ALL star buffers (uncomment the line below if you want this)
;        ; (string-prefix-p "*" name)
;        ))))
;
;
;
;

(with-eval-after-load 'centaur-tabs
  ;; 1. Define the hiding rules
  (defun my-centaur-tabs-hide-filter (buffer)
    "Filter out unwanted log and process buffers from centaur-tabs."
    (let ((name (buffer-name buffer)))
      (or
       (string-prefix-p "*Messages*" name)
       (string-prefix-p "*lsp-log" name)
       (string-suffix-p "::stderr*" name)
       (string-prefix-p "*Help*" name)
       (string-prefix-p "*Compile-Log*" name)
       (string-prefix-p "*epc" name)
       ;; Added: Hide any other buffer starting with *, except *scratch*
       (and (string-prefix-p "*" name)
            (not (string-equal "*scratch*" name))))))

  ;; 2. Assign it to the correct centaur-tabs hook variable
  (setq centaur-tabs-hide-tab-function #'my-centaur-tabs-hide-filter)
  
  ;; 3. Force centaur-tabs to clear its cache and rebuild your tabs
  (centaur-tabs-display-update))

(provide 'keybindings-config)
;;; keybindings-config.el ends here
