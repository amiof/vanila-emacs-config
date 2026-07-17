;; جلوگیری از لود شدن package قبل از Elpaca
(setq package-enable-at-startup nil)

;; کاهش garbage collection در startup
(setq gc-cons-threshold most-positive-fixnum)

;; حذف UI قدیمی قبل از بالا آمدن
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
