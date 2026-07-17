;;; ui.el

; (set-face-attribute 'default nil
;                     :font "JetBrains Mono"
;                     :height 120)
;; Main monospace font (used for all fixed‑width text)
(set-face-attribute 'default nil
                    :family "JetBrains Mono"
                    :height 110          ; 15 pt × 10 = 150
                    :weight 'semilight)  ; semi‑light → semilight

;; Variable‑pitch font (used by mixed‑pitch modes, Org, etc.)
(set-face-attribute 'variable-pitch nil
                    :family "JetBrains Mono"
                    :height 110)         ; 14 pt

(setq inhibit-startup-screen t)


(use-package timu-rouge-theme)
(use-package kanagawa-themes)

;; theme
(use-package doom-themes
  :config
  (load-theme 'doom-gruvbox t))


;; line number
(global-display-line-numbers-mode 1)

(add-to-list 'default-frame-alist '(width . 130))
(add-to-list 'default-frame-alist '(height . 40))

;; for punch-line dependency
; (use-package nerd-icons
;   :ensure t)
;
;; ۲. نصب یکپارچه punch-line و وابستگی‌های داخل آن
; (use-package punch-line
;   :ensure (:host github :repo "konrad1977/punch-line")
;   :after nerd-icons
;   :init
;   ;; فعال‌سازی مودلاین پس از اتمام لود شدن الپاکا
;   (add-hook 'elpaca-after-init-hook #'punch-line-mode)
;   :config
;   ;; چون همه فایل‌ها در یک ریپازیتوری هستند، اینجا آن‌ها را به ترتیب لود می‌کنیم
;   (require 'mode-line-hud)
;   (require 'punch-line)
;   ; (require 'punch-line-battery)
;   ; (require 'punch-line-colors)
;   ; (require 'punch-line-macro)
;   ; (require 'punch-line-misc)
;   ; (require 'punch-line-modal)
;   ; (require 'punch-line-music)
;   ; (require 'punch-line-package)
;   ; (require 'punch-line-spinner)
;   ; (require 'punch-line-systemmonitor)
;   ; (require 'punch-line-term)
;   ; (require 'punch-line-vc)
;   ; (require 'punch-line-weather)
;   ; (require 'punch-line-what-am-i-doing)
;
;   ;; اجرای توابع کمکی
;   (add-hook 'elpaca-after-init-hook #'punch-load-tasks)
;   (add-hook 'elpaca-after-init-hook #'punch-weather-update)
;
;   ;; تنظیمات شخصی شما
;   (setq
;    punch-line-left-separator "  "
;    punch-line-right-separator "  "
;    punch-line-music-info '(:service apple)
;    punch-line-music-max-length 40))
;
; ;; Mode line size
; (setq punch-line-modal-size 'medium)  ; Options: 'small, 'medium, 'large
;
; ;; Divider style
; (setq punch-line-modal-divider-style 'flame)  ; Options: 'arrow, 'flame, 'ice, 'circle, 'block
; (setq punch-line-modal-use-padding "")  ; Options: 'arrow, 'flame, 'ice, 'circle, 'block
; (setq punch-line-left-separator "  ")
; (setq punch-line-right-separator "  ")
; ; Manual colors for specific sections
; ;
; (setq punch-line-section-backgrounds
;       '(
;         ; (filename . "#201010")
;         ; (battery . "#000000")
;         (git . "nill")
;         ; (major-mode . "#16213e")
;         ))

;; Automatic tinting - each section gets progressively lighter
; (setq punch-line-section-backgrounds 'auto)
; (setq punch-line-section-background-tint-step 5)  ; 5% lighter each section

;; Automatic with darker progression
; (setq punch-line-section-backgrounds 'auto)
; (setq punch-line-section-background-tint-step -5)  ; 5% darker each section

(setq-default truncate-lines t)



(custom-set-faces
 '(vertico-current ((t (:background "#282c34" :foreground "#51afef" :weight bold)))))

(use-package solaire-mode
             :ensure t
             )
(with-eval-after-load 'solaire-mode
(require 'solaire-mode)
(solaire-global-mode +1))



(use-package golden-ratio
  :ensure t
 )

(with-eval-after-load 'golden-ratio
(require 'golden-ratio)
(golden-ratio-mode 1))

(use-package centaur-tabs
  :ensure t 
  :demand t
  :config
  (centaur-tabs-mode t)
  
  (setq centaur-tabs-style "bar"                
        centaur-tabs-height 32                  
        centaur-tabs-set-bar 'left              
        centaur-tabs-set-close-button t         
        centaur-tabs-set-modified-marker t      
        centaur-tabs-modified-marker "●")  

  (setq centaur-tabs-set-icons t
        centaur-tabs-icon-type 'nerd-icons)

  (centaur-tabs-headline-match))


(with-eval-after-load 'centaur-tabs
  ;; 1. Safely define our buffer exclusion rules
  (defun my-centaur-tabs-hide-filter (buffer)
    "Cleanly hide tabs in side windows, child frames, popups, and logs."
    (let ((name (buffer-name buffer)))
      (or
       ;; Hide in dedicated side-windows/popups
       (window-dedicated-p (selected-window))
       
       ;; Absolutely hide tabs if we are inside a child-frame (like lsp-ui-doc)
       (and (fboundp 'frame-parent) (frame-parent (selected-frame)))
       
       ;; Hide inside lsp-ui-doc or lsp-ui-imenu buffers
       (string-prefix-p " *lsp-ui" name)
       
       ;; Hide common terminals and popups
       (derived-mode-p 'vterm-mode)
       (derived-mode-p 'eshell-mode)
       (derived-mode-p 'shell-mode)
       
       ;; Hide log and process buffers
       (string-prefix-p "*Messages*" name)
       (string-prefix-p "*lsp-log" name)
       (string-suffix-p "::stderr*" name))))

  ;; 2. Apply the filter function to centaur-tabs
  (setq centaur-tabs-hide-tab-function #'my-centaur-tabs-hide-filter)
  
  ;; 3. Tell centaur-tabs to actively check if it's running inside a popup 
  ;; and skip rendering if true
  (setq centaur-tabs-show-navigation-buttons nil)
  
  ;; Force an update
  (centaur-tabs-display-update))

;; pair
(electric-pair-mode 1)
;; smooth scrolling
(pixel-scroll-precision-mode 1)
(provide 'ui-config)
