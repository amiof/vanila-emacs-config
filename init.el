;;; init.el --- Personal Emacs Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; This is my personal Emacs configuration file.


;; Use expand-file-name to guarantee Emacs resolves the '~' properly
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lang" user-emacs-directory))


(require 'bootstrap-config)
(require 'ui-config)
(require 'evil-config)
(require 'completion-config)
(require 'keybindings-config)
(require 'tools-config)
(require 'lsp-config)
(require 'core-config)
(create-or-load-custom-file)
(require 'snippet-config)
(require 'modeline-config)
(require 'neoscroll)


(add-hook 'emacs-startup-hook
          (lambda ()
            (neoscroll-mode 1)))

