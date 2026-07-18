
;; Make the lang directory loadable (language-specific files)
; (add-to-list 'load-path (expand-file-name "lang" user-emacs-directory))
;
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(add-to-list 'load-path
             (expand-file-name "lang" user-emacs-directory))


(defconst my/custom-file-template
  ";;; custom.el --- Your Chadmacs overrides -*- no-byte-compile: t; lexical-binding: t; -*-
;;;
;;; chadmacs --- Your own config files
;;;
;;; Commentary:
;;; This file is GITIGNORED. Put your personal settings, package overrides,
;;; and the list of language modules you want here. Pulling new Chadmacs
;;; versions will never touch it -> no merge conflicts.
;;;
;;; To re-generate from scratch: delete this file and restart Emacs (or
;;; run `chadmacs doctor --reset-custom').
;;;
;;; Code:

;; ============================================================
;; Language modules
;; ============================================================
;; Each line maps to lang/<name>-lang.el. Uncomment to enable
;; the language. Each module's header comment lists the LSP binary you
;; need to install on your system for completion / errors / rename to work.

;; --- Web stack ---
;; (require 'typescript-lang)     ;; TS / TSX / JS / JSX
;; (require 'web-lang)            ;; HTML / CSS / SCSS / Vue / Svelte / Emmet
;; (require 'json-lang)           ;; JSON / JSONC
;; (require 'yaml-lang)           ;; YAML

;; --- Backend / scripting ---
;; (require 'python-lang)         ;; Python (+ optional pyvenv)
;; (require 'go-lang)             ;; Go (+ go.mod)
;; (require 'ruby-lang)           ;; Ruby / Rails / Gemfile / Rakefile
;; (require 'elixir-lang)         ;; Elixir + HEEx (Phoenix templates)
;; (require 'lua-lang)            ;; Lua

;; --- Systems / native ---
;; (require 'rust-lang)           ;; Rust + rustic + cargo
;; (require 'c-cpp-lang)          ;; C / C++ + meson + cmake
;; (require 'csharp-lang)         ;; C# / .NET
;; (require 'zig-lang)            ;; Zig
;; (require 'swift-lang)          ;; Swift

;; --- JVM ---
;; (require 'scala-lang)          ;; Scala / sbt
;; (require 'kotlin-lang)         ;; Kotlin

;; --- Functional ---
;; (require 'haskell-lang)        ;; Haskell + Cabal
;; (require 'ocaml-lang)          ;; OCaml + Dune
;; (require 'clojure-lang)        ;; Clojure + CIDER + clj-refactor

;; --- Scientific ---
;; (require 'julia-lang)          ;; Julia + LanguageServer.jl

;; --- DevOps / infra ---
;; (require 'docker-lang)         ;; Dockerfile (compose via yaml)
;; (require 'terraform-lang)      ;; Terraform / HCL
;; (require 'nix-lang)            ;; Nix

;; --- Docs / writing ---
;; (require 'markdown-lang)       ;; Markdown / GFM (+ marksman)

;; --- Niche ---
;; (require 'gerbil-lang)         ;; Gerbil Scheme

;; ============================================================
;; Optional feature toggles
;; ============================================================

;; Ghostel-IME: only needed if you use an Emacs Lisp input method
;; (Korean Hangul via `M-x set-input-method', etc). OS-level IMEs
;; (fcitx / ibus / macOS / Windows) work in Ghostel without this.
;; (setq my/enable-ghostel-ime t)

;; ============================================================
;; Your personal overrides go below
;; ============================================================
;; e.g. (setq user-full-name \"Jane Doe\")

;; --- Font ---
;; set-face-attribute's 2nd arg is the FRAME (nil = all frames); the font
;; itself goes through :font, and :height is 1/10 pt (140 = 14pt). Point it
;; at a font installed on your system, then uncomment:
;; (set-face-attribute 'default nil :font \"JetBrainsMono Nerd Font\" :height 140)

;; --- Theme ---
;; Chadmacs enables doom-monokai-pro. To use a different theme, load it AFTER
;; Elpaca finishes init - otherwise the default loads afterwards (Elpaca is
;; asynchronous) and overwrites yours. Disable any enabled theme first for a
;; clean swap. Every doom-theme ships with Chadmacs (e.g. doom-one):
;; (add-hook 'elpaca-after-init-hook
;;           (lambda ()
;;             (mapc #'disable-theme custom-enabled-themes)
;;             (load-theme 'doom-one t)))

"
  "Bootstrap content for custom.el on first launch.")

(defun create-or-load-custom-file ()
  "Load the custom.el file (gitignored) if it exists or create if it doesn't.
Custom.el is seeded with the language-module activation template so users
can enable per-language support without touching upstream files."
  (unless (file-exists-p custom-file)
    (with-temp-file custom-file
      (insert my/custom-file-template)))
  (load custom-file t t))



(provide 'core-config)
