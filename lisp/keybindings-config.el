;;; keybindings-config.el

(use-package which-key
  :config
  (which-key-mode))


;; close all buffer and window auto
(defun my/smart-close (&optional force)
  "Smart close: ignores minibuffer and side windows (treemacs, etc.)."
  (interactive "P")
  (cond
   ;; Minibuffer is active → just abort it
   ((minibufferp)
    (abort-recursive-edit))

   (t
    (let* (;; Get all windows EXCEPT minibuffer and side windows (treemacs, etc.)
           (real-wins (cl-remove-if
                       (lambda (w)
                         (or (window-parameter w 'window-side)    ;; treemacs, etc.
                             (window-parameter w 'no-delete-other-windows)))
                       (window-list)))
           (count (length real-wins)))
      (cond
       ;; Multiple real windows → close this one
       ((> count 1)
        (delete-window))

       ;; Single window, popup/special buffer → bury it
       ((and (not (buffer-file-name))
             (not (eq major-mode 'dired-mode)))
        (quit-window t))

       ;; Single window, real file → kill buffer
       (t
        (when (and (buffer-modified-p) (not force))
          (save-buffer))
        (kill-current-buffer)))))))

(global-set-key (kbd "C-c k") #'my/smart-close)


(require 'cl-lib) ; needed for cl-remove-if-not

(defun my/real-buffer-p (buffer)
  "Return non-nil if BUFFER is a 'real' user buffer."
  (let ((name (buffer-name buffer)))
    (and (not (string-prefix-p " " name))      ; hidden buffers start with space
         (not (string-prefix-p "*" name))      ; exclude *scratch*, *Messages*, etc.
         (not (minibufferp buffer)))))

(with-eval-after-load 'consult
  (defvar my/consult--source-real-buffer
    `(:name "Real Buffers"
	    :narrow ?b
	    :category buffer
	    :state ,#'consult--buffer-state
	    :items
	    ,(lambda ()
               (mapcar #'buffer-name
                       (cl-remove-if-not #'my/real-buffer-p (buffer-list)))))))

(defun my/switch-to-real-buffer ()
  "Consult buffer switcher limited to `my/real-buffer-p` buffers."
  (interactive)
  (require 'consult)
  (let ((consult-buffer-sources (list my/consult--source-real-buffer)))
    (consult-buffer)))


;; for switch between buffer with M and m
(defun my/real-buffer-list ()
  "Get sorted list of real buffers."
  (sort (cl-remove-if-not #'my/real-buffer-p (buffer-list))
        (lambda (a b) (string< (buffer-name a) (buffer-name b)))))

(defun my/next-real-buffer ()
  "Switch to next real buffer."
  (interactive)
  (let* ((buffers (my/real-buffer-list))
         (current (current-buffer))
         (pos (cl-position current buffers)))
    (if (and pos buffers)
        (switch-to-buffer
         (nth (mod (1+ pos) (length buffers)) buffers))
      (when buffers (switch-to-buffer (car buffers))))))

(defun my/previous-real-buffer ()
  "Switch to previous real buffer."
  (interactive)
  (let* ((buffers (my/real-buffer-list))
         (current (current-buffer))
         (pos (cl-position current buffers)))
    (if (and pos buffers)
        (switch-to-buffer
         (nth (mod (1- pos) (length buffers)) buffers))
      (when buffers (switch-to-buffer (car buffers))))))


;; (global-set-key (kbd "C-x b") #'my/switch-to-real-buffer)


(use-package general
  :demand t
  :config

  (which-key-add-key-based-replacements
    "SPC f" "files"
    "SPC b" "buffer"
    "SPC s" "search"
    "SPC k" "popper"
    "SPC g" "git"
    "SPC m" "bookmarks"
    "SPC c" "code"
    "SPC p" "popper/project"
    "SPC o" "open"
    "SPC r" "refactor"
    "SPC h" "help"
    "SPC w" "window"
    "SPC q" "quit"
    "SPC x" "crux"
    "SPC t" "terminal")

  (general-create-definer my-leader-def
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  (my-leader-def
    "SPC" 'consult-buffer
    )

  ;; Files
  (my-leader-def
    "f f" 'find-file
    "f n"  'project-find-file
    "f g " 'consult-ripgrep
    "f r" 'consult-recent-file
    "f s" 'save-buffer)


  ;; Buffers
  (my-leader-def
    "b b" #'my/switch-to-real-buffer
    "b d" #'my/smart-close)


  ;; Search
  (my-leader-def
    "s s" 'consult-ripgrep
    "s b" 'consult-line)


  ;; Git
  (my-leader-def
    "g g" 'magit-status
    "g s" 'diff-hl-show-hunk
    "g h" 'diff-hl-revert-hunk
    "g r" 'vc-revert
    "g f" 'my/ediff-changed-files
    "g e" 'my/ediff-with-git-rev
    ) 
  ;;popper

  (my-leader-def
    "k t" 'popper-toggle
    "k c" 'popper-cycle
    "k k" 'popper-toggle-type
    ;; "p p" 'project-switch-project
    )

  (my-leader-def
    "p p" #'my/projectile-switch-project-and-treemacs
    "p f" #'projectile-find-file
    "p d" #'projectile-find-dir
    "p r" #'projectile-recentf
    "p s" #'projectile-ripgrep
    "p k" #'projectile-kill-buffers
    "p c" #'projectile-compile-project
    "p t" #'projectile-test-project
    "p R" #'projectile-replace
    "p i" #'projectile-invalidate-cache
    "p a" #'projectile-add-known-project
    "p x" #'projectile-remove-known-project)

  ;;bookmarks
  (my-leader-def
    "m s" 'bookmark-set
    "m d" 'bookmark-delete
    "m l" 'bookmark-bmenu-list
    "m j" 'bookmark-jump
    )

  ;; LSP / Code
  (my-leader-def
    "c a" 'lsp-execute-code-action
    "c d" 'lsp-describe-thing-at-point
    "c f" 'lsp-format-buffer
    "c r" 'lsp-find-references
    "c y" 'flycheck-copy-errors-as-kill
    "["   'evil-jump-backward         
    "]"   'evil-jump-forward
    )

  (my-leader-def
    "r n" 'lsp-rename
    "r l"  #'my/lsp-eslint-fix
    "r b" 'lsp-biome-fix-all
    "r f" 'apheleia-format-buffer
    "r d" 'consult-lsp-diagnostics
    "r e" 'flycheck-list-errors
    )

  ;; (my-leader-def
  ;;     "p t" 'popper-toggle
  ;;     "p c" 'popper-cycle
  ;;     "p k" 'popper-toggle-type)

  (my-leader-def
    "o p" 'treemacs
    "o f" 'treemacs-find-file
    "o t" 'consult-theme
    "o g" #'ghostel
    "o G" #'my/ghostel-full-window)

  ;; Help
  (my-leader-def
    ;; "h f" 'describe-function
    ;;"h v" 'describe-variable
    ;;"h k" 'describe-key
    "h f" 'helpful-callable
    "h v" 'helpful-variable
    "h k" 'helpful-key
    "h c" 'helpful-command)


  (my-leader-def
    "w d" 'delete-window
    "w h"'evil-window-left
    "w j" 'evil-window-down
    "w k" 'evil-window-up
    "w u" 'winner-undo 
    "w r" 'winner-redo
    "w l" 'evil-window-right
    "w w"  (lambda () (interactive) (save-some-buffers t))
    "w c" 'save-buffer
    "w q" (lambda () (interactive) (save-buffers-kill-terminal t))
    )

  (my-leader-def
    "j" #'my/treemacs-toggle-focus
    )
  
  (my-leader-def
    "q q" 'kill-emacs
    )

  (my-leader-def
    "x x" 'crux-transpose-windows
    "x w" 'crux-swap-windows 
    "x r" 'crux-rename-file-and-buffer 
    "x d" 'crux-delete-file-and-buffer
    "x b" 'crux-kill-other-buffers
    "x o" 'crux-open-with
    "x s" 'crux-sudo-edit
    "x c" 'crux-duplicate-and-comment-current-line-or-region
    )


  ;; Terminal 
  (my-leader-def
    "t t" 'vterm
    "t d"  'hl-todo-occur
    )
  )


;; (with-eval-after-load 'lsp-ui
;;   (evil-define-key 'normal lsp-ui-mode-map
;;     (kbd "K") #'lsp-ui-doc-show
;;     (kbd "F") #'lsp-ui-doc-focus-frame
;;     (kbd "q") #'lsp-ui-doc-hide))



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
  (define-key evil-normal-state-map (kbd "g D") #'lsp-find-references)
  (define-key evil-normal-state-map (kbd "g c c") #'comment-line)

  ;; (define-key evil-normal-state-map (kbd "m") #'next-buffer)
  ;; (define-key evil-normal-state-map (kbd "M") #'previous-buffer)
  (define-key evil-normal-state-map (kbd "m") #'my/next-real-buffer)
  (define-key evil-normal-state-map (kbd "M") #'my/previous-real-buffer)
  (define-key evil-normal-state-map (kbd "|") #'split-window-right)
  (define-key evil-normal-state-map (kbd "]t") #'hl-todo-next)
  (define-key evil-normal-state-map (kbd "[t") #'hl-todo-previous)
  (define-key evil-normal-state-map (kbd "M-j") #'move-text-down)
  (define-key evil-normal-state-map (kbd "M-k") #'move-text-up)

  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
  (define-key evil-normal-state-map (kbd "J") 'other-window)
  )


;; dont show tab start with * 
;; (with-eval-after-load 'centaur-tabs
;;   (defun centaur-tabs-hide-tab (buffer)
;;     "Do not show internal, log, and process buffers in centaur-tabs."
;;     (let ((name (buffer-name buffer)))
;;       (or
;;        ;; Default: Hide buffers in dedicated windows
;;        (window-dedicated-p (selected-window))
;;
;;        ;; Hide specific unwanted buffers
;;        (string-prefix-p "*Messages*" name)
;;        (string-prefix-p "*lsp-log*" name)
;;        (string-suffix-p "*::stderr*" name)
;;        (string-prefix-p "*Help*" name)
;;        (string-prefix-p "*Compile-Log*" name)
;;        (string-prefix-p "*ts-ls*" name)
;;        (string-prefix-p "*Buffer List*" name)
;;        (string-prefix-p "*scratch*" name)
;;        (string-prefix-p "*ts-ls::stderr*" name)
;;
;;        ;; Optional: Hide ALL star buffers (uncomment the line below if you want this)
;;        ; (string-prefix-p "*" name)
;;        ))))
;;
;;
;;
;;

;; (with-eval-after-load 'centaur-tabs
;;   ;; 1. Define the hiding rules
;;   (defun my-centaur-tabs-hide-filter (buffer)
;;     "Filter out unwanted log and process buffers from centaur-tabs."
;;     (let ((name (buffer-name buffer)))
;;       (or
;;        (string-prefix-p "*Messages*" name)
;;        (string-prefix-p "*lsp-log" name)
;;        (string-suffix-p "::stderr*" name)
;;        (string-prefix-p "*Help*" name)
;;        (string-prefix-p "*Compile-Log*" name)
;;        (string-prefix-p "*epc" name)
;;        ;; Added: Hide any other buffer starting with *, except *scratch*
;;        (and (string-prefix-p "*" name)
;;             (not (string-equal "*scratch*" name))))))

;;   ;; 2. Assign it to the correct centaur-tabs hook variable
;;   (setq centaur-tabs-hide-tab-function #'my-centaur-tabs-hide-filter)

;;   ;; 3. Force centaur-tabs to clear its cache and rebuild your tabs
;;   (centaur-tabs-display-update))

(provide 'keybindings-config)
;;; keybindings-config.el ends here
