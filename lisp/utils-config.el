;;;
(defvar my/transparency-enabled nil)  ;; nil یعنی در شروع OFF است
(setq my/default-transparency 90)

;; در شروع Emacs شفافیت را خاموش می‌کند (کاملاً مات)
(set-frame-parameter nil 'alpha-background 100)
(add-to-list 'default-frame-alist '(alpha-background . 100))

(defun my/toggle-transparency-bg ()
  "Toggle background transparency only (text remains opaque)."
  (interactive)
  (setq my/transparency-enabled (not my/transparency-enabled))

  (let ((value (if my/transparency-enabled my/default-transparency 100)))
    (set-frame-parameter nil 'alpha-background value)
    (setq default-frame-alist (assq-delete-all 'alpha-background default-frame-alist))
    (add-to-list 'default-frame-alist `(alpha-background . ,value))
    
    (message "Background Transparency: %s"
             (if my/transparency-enabled "ON" "OFF"))))

(global-set-key (kbd "C-c b") #'my/toggle-transparency-bg)



(defun my/lsp-eslint-fix ()
  "Run ESLint Fix All."
  (interactive)
  (lsp-execute-code-action-by-kind "source.fixAll.eslint"))


(defun my/treemacs-toggle-focus ()
  "Toggle cursor focus between Treemacs and last used window."
  (interactive)
  (if (eq (treemacs-get-local-window) (selected-window))
      (select-window (get-mru-window nil nil t))
    (treemacs-select-window)))




(provide 'utils-config)
