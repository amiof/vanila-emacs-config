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

(provide 'utils-config)
