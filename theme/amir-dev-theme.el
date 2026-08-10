;;; amir-dev.el -*- lexical-binding: t; -*-

;;; Commentary:
;; Gruvbox Dark Hard inspired by IntelliJ/WebStorm theme.
;; Syntax mapping based on WebStorm "Gruvbox Dark Hard" scheme.

;;; Code:

(require 'cl-lib)

(defgroup amir-dev-theme nil
  "WebStorm Gruvbox Dark Hard inspired theme."
  :group 'faces)

;; ============================================================
;; Palette
;; ============================================================

(defconst amir-dev-colors
  '(
    (bg              . "#1d2021")
    (bg-main         . "#1d2021")
    (bg-soft         . "#282828")
    (bg-highlight    . "#3c3836")
    (bg-selection    . "#665c54")
    (bg-fold         . "#504945")
    (bg-symbol       . "#313008")
    (bg-search       . "#5a590f")

    (fg              . "#ebdbb2")
    (fg-bright       . "#fbf1c7")
    (fg-soft         . "#d5c4a1")
    (fg-muted        . "#bdae93")
    (fg-dim          . "#928374")

    (red             . "#fb4934")
    (red-dark        . "#cc241d")
    (green            . "#b8bb26")
    (green-dark       . "#98971a")
    (yellow           . "#fabd2f")
    (yellow-dark      . "#d79921")
    (blue             . "#83a598")
    (blue-dark        . "#458588")
    (purple           . "#d3869b")
    (purple-dark      . "#b16286")
    (aqua             . "#8ec07c")
    (aqua-dark        . "#689d6a")
    (orange           . "#fe8019")
    (orange-dark      . "#d65d0e")

    ;; WebStorm semantic colors
    (identifier       . "#fbf1c7")
    (variable         . "#83a598")
    (local-variable   . "#83a598")
    (parameter        . "#83a598")
    (function         . "#b8bb26")
    (method           . "#b8bb26")
    (type             . "#fabd2f")
    (class            . "#fabd2f")
    (interface        . "#fabd2f")
    (property         . "#83a598")
    (field            . "#83a598")
    (keyword          . "#fb4934")
    (string           . "#b8bb26")
    (number           . "#d3869b")
    (constant         . "#d3869b")
    (operator         . "#ebdbb2")
    (comment          . "#928374")
    (doc-comment      . "#83786e")
    (tag              . "#83a598")
    (attribute        . "#d3869b")
    (metadata         . "#8ec07c")
    (entity           . "#d79921")
    (label            . "#d3869b")
    (bracket          . "#f8e1aa")
    (delimiter        . "#ebdbb2")
    (matched-bracket  . "#ff8647")
    (error            . "#fb4934")
    (warning          . "#fabd2f")
    (info             . "#83a598")
    (cursor           . "#fabd2f")
    (mode-line        . "#32302f")
    (border           . "#504945")
    (popup            . "#282828")
    (write-symbol     . "#2f0d0d")
    (read-symbol      . "#313008")
    (completion-bg    . "#282828")
    (completion-sel   . "#504945")
    ))

(defun amir-dev-color (name)
  "Get color NAME from amir-dev palette."
  (cdr (assq name amir-dev-colors)))

;; ============================================================
;; Theme
;; ============================================================

(deftheme amir-dev
  "WebStorm Gruvbox Dark Hard inspired theme.")

;; ============================================================
;; Core editor faces
;; ============================================================

(custom-theme-set-faces
 'amir-dev

 `(default
   ((t (:background ,(amir-dev-color 'bg) :foreground ,(amir-dev-color 'fg)))))

 `(cursor ((t (:background ,(amir-dev-color 'cursor)))))

 `(region
   ((t (:background ,(amir-dev-color 'bg-selection) :foreground ,(amir-dev-color 'fg-bright)))))

 `(hl-line ((t (:background ,(amir-dev-color 'bg-highlight)))))

 `(line-number
   ((t (:background ,(amir-dev-color 'bg) :foreground ,(amir-dev-color 'fg-dim)))))

 `(line-number-current-line
   ((t (:background ,(amir-dev-color 'bg) :foreground ,(amir-dev-color 'yellow) :weight bold))))

 `(fringe
   ((t (:background ,(amir-dev-color 'bg) :foreground ,(amir-dev-color 'fg-dim)))))

 `(vertical-border ((t (:foreground ,(amir-dev-color 'border)))))
 `(shadow ((t (:foreground ,(amir-dev-color 'fg-dim)))))

 ;; Comments
 `(font-lock-comment-face
   ((t (:foreground ,(amir-dev-color 'comment) :slant italic))))
 `(font-lock-doc-face ((t (:foreground ,(amir-dev-color 'doc-comment)))))
 `(font-lock-doc-string-face ((t (:foreground ,(amir-dev-color 'doc-comment)))))

 ;; Keywords
 `(font-lock-keyword-face ((t (:foreground ,(amir-dev-color 'keyword)))))

 ;; builtin = purple (DEFAULT_PREDEFINED_SYMBOL): Math, Array, console, ...
 `(font-lock-builtin-face ((t (:foreground ,(amir-dev-color 'constant)))))

 ;; Functions / Methods = green
 `(font-lock-function-name-face ((t (:foreground ,(amir-dev-color 'function)))))
 `(font-lock-function-call-face ((t (:foreground ,(amir-dev-color 'function)))))

 ;; Variables = blue
 `(font-lock-variable-name-face ((t (:foreground ,(amir-dev-color 'variable)))))
 `(font-lock-variable-use-face ((t (:foreground ,(amir-dev-color 'variable)))))

 ;; Types = yellow bold
 `(font-lock-type-face ((t (:foreground ,(amir-dev-color 'type) :weight bold))))
 `(font-lock-constant-face ((t (:foreground ,(amir-dev-color 'constant)))))

 ;; Strings / Numbers
 `(font-lock-string-face ((t (:foreground ,(amir-dev-color 'string)))))
 `(font-lock-number-face ((t (:foreground ,(amir-dev-color 'number)))))

 ;; Operators / punctuation
 `(font-lock-negation-char-face ((t (:foreground ,(amir-dev-color 'operator)))))
 `(font-lock-operator-face ((t (:foreground ,(amir-dev-color 'operator)))))
 `(font-lock-delimiter-face ((t (:foreground ,(amir-dev-color 'delimiter)))))
 `(font-lock-bracket-face ((t (:foreground ,(amir-dev-color 'bracket)))))

 ;; Properties / fields = blue
 `(font-lock-property-name-face ((t (:foreground ,(amir-dev-color 'field)))))
 `(font-lock-property-use-face ((t (:foreground ,(amir-dev-color 'field)))))

 ;; Bracket matching
 `(show-paren-match ((t (:foreground ,(amir-dev-color 'matched-bracket) :weight bold))))
 `(show-paren-mismatch
   ((t (:foreground ,(amir-dev-color 'error) :background "#611818" :weight bold))))

 ;; Search
 `(isearch
   ((t (:foreground ,(amir-dev-color 'fg-bright) :background ,(amir-dev-color 'bg-search) :weight bold))))
 `(isearch-fail
   ((t (:foreground ,(amir-dev-color 'fg-bright) :background "#611818" :weight bold))))
 `(lazy-highlight
   ((t (:foreground ,(amir-dev-color 'fg) :background ,(amir-dev-color 'bg-fold)))))

 ;; Minibuffer
 `(minibuffer-prompt ((t (:foreground ,(amir-dev-color 'blue) :weight bold))))

 ;; Errors / warnings
 `(error ((t (:foreground ,(amir-dev-color 'error) :weight bold))))
 `(warning ((t (:foreground ,(amir-dev-color 'warning)))))
 `(success ((t (:foreground ,(amir-dev-color 'green)))))

 ;; Flymake / Flycheck
 `(flymake-error ((t (:underline (:style wave :color ,(amir-dev-color 'error))))))
 `(flymake-warning ((t (:underline (:style wave :color ,(amir-dev-color 'warning))))))
 `(flymake-note ((t (:underline (:style wave :color ,(amir-dev-color 'info))))))
 `(flycheck-error ((t (:underline (:style wave :color ,(amir-dev-color 'error))))))
 `(flycheck-warning ((t (:underline (:style wave :color ,(amir-dev-color 'warning))))))
 `(flycheck-info ((t (:underline (:style wave :color ,(amir-dev-color 'info))))))

 ;; Links
 `(link ((t (:foreground ,(amir-dev-color 'blue) :underline t)))))

;; ============================================================
;; Mode line
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(mode-line
   ((t (:background ,(amir-dev-color 'mode-line) :foreground ,(amir-dev-color 'fg) :box nil))))
 `(mode-line-inactive
   ((t (:background ,(amir-dev-color 'bg) :foreground ,(amir-dev-color 'fg-dim) :box nil))))
 `(header-line
   ((t (:background ,(amir-dev-color 'mode-line) :foreground ,(amir-dev-color 'fg) :box nil)))))

;; ============================================================
;; Dired
;; ============================================================

(custom-theme-set-faces
 'amir-dev

 ;; Dired permissions
 `(diredfl-read-priv
   ((t (:foreground ,(amir-dev-color 'fg-dim)))))

 `(diredfl-write-priv
   ((t (:foreground ,(amir-dev-color 'yellow)))))

 `(diredfl-exec-priv
   ((t (:foreground ,(amir-dev-color 'green)))))

 `(diredfl-no-priv
   ((t (:foreground ,(amir-dev-color 'fg-dim)))))

 ;; Dired directories
 `(diredfl-dir-priv
   ((t (:foreground ,(amir-dev-color 'blue)))))

 `(diredfl-dir-name
   ((t (:foreground ,(amir-dev-color 'blue)
                    :weight bold))))

 `(diredfl-dir-heading
   ((t (:foreground ,(amir-dev-color 'yellow)
                    :weight bold))))

 ;; Dired files
 `(diredfl-file-name
   ((t (:foreground ,(amir-dev-color 'fg))))))




;; ============================================================
;; Diff
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(diff-added ((t (:foreground ,(amir-dev-color 'green)))))
 `(diff-removed ((t (:foreground ,(amir-dev-color 'red)))))
 `(diff-changed ((t (:foreground ,(amir-dev-color 'blue))))))


;; ============================================================
;; Diff-hl
;; ============================================================
(custom-theme-set-faces
 'amir-dev

 `(diff-hl-insert
   ((t (:foreground ,(amir-dev-color 'green)
                    :background ,(amir-dev-color 'green)))))

 `(diff-hl-delete
   ((t (:foreground ,(amir-dev-color 'red)
                    :background ,(amir-dev-color 'red)))))

 `(diff-hl-change
   ((t (:foreground ,(amir-dev-color 'blue)
                    :background ,(amir-dev-color 'blue)))))

 `(diff-hl-unknown
   ((t (:foreground ,(amir-dev-color 'yellow)
                    :background ,(amir-dev-color 'yellow)))))

 `(diff-hl-reverted
   ((t (:foreground ,(amir-dev-color 'fg-dim)
                    :background ,(amir-dev-color 'fg-dim))))))
;; ============================================================
;; Compilation
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(compilation-error ((t (:foreground ,(amir-dev-color 'error) :weight bold))))
 `(compilation-warning ((t (:foreground ,(amir-dev-color 'warning)))))
 `(compilation-info ((t (:foreground ,(amir-dev-color 'green))))))


;; ============================================================
;; LSP Semantic Token Modifier Faces
;; Modifiers intentionally preserve the token's semantic color.
;; ============================================================

(defface amir-dev-semantic-declaration
  '((t (:weight bold)))
  "Semantic declaration modifier."
  :group 'amir-dev-theme)

(defface amir-dev-semantic-definition
  '((t (:weight bold)))
  "Semantic definition modifier."
  :group 'amir-dev-theme)

(defface amir-dev-semantic-readonly
  '((t (:slant italic)))
  "Semantic readonly modifier."
  :group 'amir-dev-theme)

(defface amir-dev-semantic-static
  '((t (:weight bold)))
  "Semantic static modifier."
  :group 'amir-dev-theme)

(defface amir-dev-semantic-deprecated
  '((t (:strike-through t)))
  "Semantic deprecated modifier."
  :group 'amir-dev-theme)

(defface amir-dev-semantic-abstract
  '((t (:slant italic)))
  "Semantic abstract modifier."
  :group 'amir-dev-theme)

(defface amir-dev-semantic-async
  '((t (:slant italic)))
  "Semantic async modifier."
  :group 'amir-dev-theme)

(defface amir-dev-semantic-modification
  '((t (:weight bold)))
  "Semantic modification modifier."
  :group 'amir-dev-theme)

(defface amir-dev-semantic-documentation
  '((t (:slant italic)))
  "Semantic documentation modifier."
  :group 'amir-dev-theme)

(defface amir-dev-semantic-default-library
  '((t (:weight bold)))
  "Semantic default library modifier."
  :group 'amir-dev-theme)



;; ============================================================
;; Tree-sitter base faces
;; (used when LSP semantic tokens are OFF, e.g. before LSP connects)
;; ============================================================

(custom-theme-set-faces
 'amir-dev

 `(tree-sitter-hl-face:function ((t (:foreground ,(amir-dev-color 'function)))))
 `(tree-sitter-hl-face:function.call ((t (:foreground ,(amir-dev-color 'function)))))
 `(tree-sitter-hl-face:function.builtin ((t (:foreground ,(amir-dev-color 'constant)))))
 `(tree-sitter-hl-face:method ((t (:foreground ,(amir-dev-color 'method)))))
 `(tree-sitter-hl-face:method.call ((t (:foreground ,(amir-dev-color 'method)))))
 `(tree-sitter-hl-face:constructor ((t (:foreground ,(amir-dev-color 'function)))))
 `(tree-sitter-hl-face:variable ((t (:foreground ,(amir-dev-color 'variable)))))
 `(tree-sitter-hl-face:variable.builtin ((t (:foreground ,(amir-dev-color 'keyword)))))
 `(tree-sitter-hl-face:variable.member ((t (:foreground ,(amir-dev-color 'field))))))

(custom-theme-set-faces
 'amir-dev

 `(tree-sitter-hl-face:variable.parameter ((t (:foreground ,(amir-dev-color 'parameter)))))
 `(tree-sitter-hl-face:property ((t (:foreground ,(amir-dev-color 'field)))))
 `(tree-sitter-hl-face:field ((t (:foreground ,(amir-dev-color 'field)))))
 `(tree-sitter-hl-face:type ((t (:foreground ,(amir-dev-color 'type) :weight bold))))
 `(tree-sitter-hl-face:type.builtin ((t (:foreground ,(amir-dev-color 'type) :weight bold))))
 `(tree-sitter-hl-face:type.definition ((t (:foreground ,(amir-dev-color 'type) :weight bold))))
 `(tree-sitter-hl-face:keyword ((t (:foreground ,(amir-dev-color 'keyword)))))
 `(tree-sitter-hl-face:keyword.function ((t (:foreground ,(amir-dev-color 'keyword)))))
 `(tree-sitter-hl-face:keyword.return ((t (:foreground ,(amir-dev-color 'keyword)))))
 `(tree-sitter-hl-face:keyword.import ((t (:foreground ,(amir-dev-color 'keyword)))))
 `(tree-sitter-hl-face:string ((t (:foreground ,(amir-dev-color 'string)))))
 `(tree-sitter-hl-face:string.special ((t (:foreground ,(amir-dev-color 'yellow-dark)))))
 `(tree-sitter-hl-face:number ((t (:foreground ,(amir-dev-color 'number)))))
 `(tree-sitter-hl-face:constant ((t (:foreground ,(amir-dev-color 'constant)))))
 `(tree-sitter-hl-face:operator ((t (:foreground ,(amir-dev-color 'operator)))))
 `(tree-sitter-hl-face:comment ((t (:foreground ,(amir-dev-color 'comment) :slant italic))))
 `(tree-sitter-hl-face:doc ((t (:foreground ,(amir-dev-color 'doc-comment)))))
 `(tree-sitter-hl-face:tag ((t (:foreground ,(amir-dev-color 'tag)))))
 `(tree-sitter-hl-face:attribute ((t (:foreground ,(amir-dev-color 'attribute)))))
 `(tree-sitter-hl-face:embedded ((t (:foreground ,(amir-dev-color 'fg)))))
 `(tree-sitter-hl-face:punctuation.bracket ((t (:foreground ,(amir-dev-color 'bracket)))))
 `(tree-sitter-hl-face:punctuation.delimiter ((t (:foreground ,(amir-dev-color 'delimiter))))))

;; ============================================================
;; LSP highlight (symbol read/write on cursor, NOT semantic tokens)
;; ============================================================

;; (custom-theme-set-faces
;;  'amir-dev
;;  `(lsp-face-highlight-textual
;;    ((t (:background ,(amir-dev-color 'read-symbol) :foreground ,(amir-dev-color 'fg-bright)))))
;;  `(lsp-face-highlight-read
;;    ((t (:background ,(amir-dev-color 'read-symbol) :foreground ,(amir-dev-color 'fg-bright)))))
;;  `(lsp-face-highlight-write
;;    ((t (:background ,(amir-dev-color 'write-symbol) :foreground ,(amir-dev-color 'fg-bright)))))
;;  `(lsp-headerline-breadcrumb-path-face ((t (:foreground ,(amir-dev-color 'fg-dim)))))
;;  `(lsp-headerline-breadcrumb-path-error-face ((t (:foreground ,(amir-dev-color 'red)))))
;;  `(lsp-headerline-breadcrumb-path-info-face ((t (:foreground ,(amir-dev-color 'blue)))))
;;  `(lsp-headerline-breadcrumb-symbols-face ((t (:foreground ,(amir-dev-color 'fg))))))

;; ;; ============================================================
;; Header line + LSP breadcrumb
;; ============================================================

(custom-theme-set-faces
 'amir-dev

 ;; Top header line background
 `(header-line
   ((t
     (:background "#32302f"
                  :foreground "#ebdbb2"
                  :box nil
                  :inherit unspecified))))

 `(header-line-highlight
   ((t
     (:background "#504945"
                  :foreground "#fbf1c7"
                  :inherit unspecified))))

 ;; If you use the standalone `breadcrumb` package
 `(breadcrumb-face
   ((t
     (:background "#32302f"
                  :foreground "#ebdbb2"))))

 ;; LSP breadcrumb faces
 `(lsp-headerline-breadcrumb-path-face
   ((t
     (:background "#32302f"
                  :foreground "#d5c4a1"))))

 `(lsp-headerline-breadcrumb-path-error-face
   ((t
     (:background "#32302f"
                  :foreground "#fb4934"
                  :weight bold))))

 `(lsp-headerline-breadcrumb-path-info-face
   ((t
     (:background "#32302f"
                  :foreground "#83a598"))))

 `(lsp-headerline-breadcrumb-symbols-face
   ((t
     (:background "#32302f"
                  :foreground "#ebdbb2"))))

 `(lsp-headerline-breadcrumb-project-prefix-face
   ((t
     (:background "#32302f"
                  :foreground "#fabd2f"))))

 `(lsp-headerline-breadcrumb-separator-face
   ((t
     (:background "#32302f"
                  :foreground "#928374"))))

 `(lsp-headerline-breadcrumb-unknown-file-name-face
   ((t
     (:background "#32302f"
                  :foreground "#d5c4a1")))))



;; NOTE: We intentionally do NOT define lsp-face-semhl-* faces here.
;; lsp-mode already defines them to :inherit the matching font-lock-*
;; faces above (e.g. lsp-face-semhl-method inherits font-lock-function-name-face,
;; lsp-face-semhl-default-library inherits font-lock-builtin-face).
;; Defining them again here would only risk breaking that correct default.

;; ============================================================
;; LSP semhl 
;; ============================================================
(custom-theme-set-faces
 'amir-dev

 `(lsp-face-semhl-variable
   ((t (:foreground ,(amir-dev-color 'variable)))))

 `(lsp-face-semhl-parameter
   ((t (:foreground ,(amir-dev-color 'parameter)))))

 `(lsp-face-semhl-property
   ((t (:foreground ,(amir-dev-color 'property)))))

 `(lsp-face-semhl-function
   ((t (:foreground ,(amir-dev-color 'function)))))

 `(lsp-face-semhl-method
   ((t (:foreground ,(amir-dev-color 'method)))))

 `(lsp-face-semhl-type
   ((t (:foreground ,(amir-dev-color 'type) :weight bold))))

 `(lsp-face-semhl-class
   ((t (:foreground ,(amir-dev-color 'class) :weight bold))))

 `(lsp-face-semhl-interface
   ((t (:foreground ,(amir-dev-color 'interface) :weight bold))))

 `(lsp-face-semhl-enum
   ((t (:foreground ,(amir-dev-color 'type) :weight bold))))

 `(lsp-face-semhl-constant
   ((t (:foreground ,(amir-dev-color 'constant)))))

 `(lsp-face-semhl-enum-member
   ((t (:foreground ,(amir-dev-color 'constant)))))

 `(lsp-face-semhl-keyword
   ((t (:foreground ,(amir-dev-color 'keyword)))))

 `(lsp-face-semhl-string
   ((t (:foreground ,(amir-dev-color 'string)))))

 `(lsp-face-semhl-number
   ((t (:foreground ,(amir-dev-color 'number)))))

 `(lsp-face-semhl-operator
   ((t (:foreground ,(amir-dev-color 'operator)))))

 `(lsp-face-semhl-comment
   ((t (:foreground ,(amir-dev-color 'comment) :slant italic))))

 `(lsp-face-semhl-default-library
   ((t (:foreground ,(amir-dev-color 'type)))))
 )

;; ============================================================
;; Company / Corfu
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(company-tooltip
   ((t (:background ,(amir-dev-color 'completion-bg) :foreground ,(amir-dev-color 'fg)))))
 `(company-tooltip-selection
   ((t (:background ,(amir-dev-color 'completion-sel) :foreground ,(amir-dev-color 'fg-bright)))))
 `(company-tooltip-common ((t (:foreground ,(amir-dev-color 'yellow) :weight bold))))
 `(company-tooltip-annotation ((t (:foreground ,(amir-dev-color 'fg-dim)))))
 `(company-scrollbar-bg ((t (:background ,(amir-dev-color 'bg-soft)))))
 `(company-scrollbar-fg ((t (:background ,(amir-dev-color 'bg-highlight)))))
 `(corfu-default
   ((t (:background ,(amir-dev-color 'completion-bg) :foreground ,(amir-dev-color 'fg)))))
 `(corfu-current
   ((t (:background ,(amir-dev-color 'completion-sel) :foreground ,(amir-dev-color 'fg-bright)))))
 `(corfu-border ((t (:background ,(amir-dev-color 'border))))))

;; ============================================================
;; Vertico / Consult
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(vertico-current
   ((t (:background ,(amir-dev-color 'bg-highlight) :foreground ,(amir-dev-color 'fg-bright)))))
 `(consult-preview-line ((t (:background ,(amir-dev-color 'bg-soft))))))

;; ============================================================
;; Orderless matching
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(orderless-match-face-0 ((t (:foreground ,(amir-dev-color 'yellow) :weight bold))))
 `(orderless-match-face-1 ((t (:foreground ,(amir-dev-color 'green) :weight bold))))
 `(orderless-match-face-2 ((t (:foreground ,(amir-dev-color 'blue) :weight bold))))
 `(orderless-match-face-3 ((t (:foreground ,(amir-dev-color 'purple) :weight bold)))))

;; ============================================================
;; Evil
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(evil-ex-lazy-highlight
   ((t (:background ,(amir-dev-color 'bg-search) :foreground ,(amir-dev-color 'yellow)))))
 `(evil-search-highlight-persist-highlight-face
   ((t (:background ,(amir-dev-color 'bg-search) :foreground ,(amir-dev-color 'fg-bright)))))
 `(evil-goggles-default-face ((t (:background ,(amir-dev-color 'bg-highlight))))))

;; ============================================================
;; Magit
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(magit-section-heading ((t (:foreground ,(amir-dev-color 'yellow) :weight bold))))
 `(magit-branch-local ((t (:foreground ,(amir-dev-color 'blue)))))
 `(magit-branch-remote ((t (:foreground ,(amir-dev-color 'green)))))
 `(magit-hash ((t (:foreground ,(amir-dev-color 'fg-dim)))))
 `(magit-diff-added ((t (:foreground ,(amir-dev-color 'green)))))
 `(magit-diff-removed ((t (:foreground ,(amir-dev-color 'red)))))
 `(magit-diff-added-highlight
   ((t (:background "#323b25" :foreground ,(amir-dev-color 'green)))))
 `(magit-diff-removed-highlight
   ((t (:background "#3b2525" :foreground ,(amir-dev-color 'red))))))

;; ============================================================
;; Org mode
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(org-level-1 ((t (:foreground ,(amir-dev-color 'yellow) :weight bold))))
 `(org-level-2 ((t (:foreground ,(amir-dev-color 'blue) :weight bold))))
 `(org-level-3 ((t (:foreground ,(amir-dev-color 'green) :weight bold))))
 `(org-level-4 ((t (:foreground ,(amir-dev-color 'purple) :weight bold))))
 `(org-code ((t (:foreground ,(amir-dev-color 'green)))))
 `(org-verbatim ((t (:foreground ,(amir-dev-color 'orange)))))
 `(org-block ((t (:background ,(amir-dev-color 'bg-soft)))))
 `(org-block-begin-line
   ((t (:foreground ,(amir-dev-color 'fg-dim) :background ,(amir-dev-color 'bg-soft)))))
 `(org-block-end-line
   ((t (:foreground ,(amir-dev-color 'fg-dim) :background ,(amir-dev-color 'bg-soft))))))

;; ============================================================
;; Markdown
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(markdown-header-face-1 ((t (:foreground ,(amir-dev-color 'yellow) :weight bold))))
 `(markdown-header-face-2 ((t (:foreground ,(amir-dev-color 'blue) :weight bold))))
 `(markdown-header-face-3 ((t (:foreground ,(amir-dev-color 'green) :weight bold))))
 `(markdown-code-face ((t (:foreground ,(amir-dev-color 'green)))))
 `(markdown-pre-face
   ((t (:background ,(amir-dev-color 'bg-soft) :foreground ,(amir-dev-color 'fg))))))

;; ============================================================
;; Rainbow delimiters
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(rainbow-delimiters-depth-1-face ((t (:foreground "#928374"))))
 `(rainbow-delimiters-depth-2-face ((t (:foreground "#cc241d"))))
 `(rainbow-delimiters-depth-3-face ((t (:foreground "#d65d0e"))))
 `(rainbow-delimiters-depth-4-face ((t (:foreground "#98971a"))))
 `(rainbow-delimiters-depth-5-face ((t (:foreground "#b16286"))))
 `(rainbow-delimiters-depth-6-face ((t (:foreground "#458588"))))
 `(rainbow-delimiters-depth-7-face ((t (:foreground "#689d6a"))))
 `(rainbow-delimiters-depth-8-face ((t (:foreground "#d79921"))))
 `(rainbow-delimiters-depth-9-face ((t (:foreground "#f9f5d7")))))

;; ============================================================
;; Which-key
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(which-key-key-face ((t (:foreground ,(amir-dev-color 'yellow) :weight bold))))
 `(which-key-command-description-face ((t (:foreground ,(amir-dev-color 'fg)))))
 `(which-key-group-description-face ((t (:foreground ,(amir-dev-color 'green))))))

;; ============================================================
;; Treemacs
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(treemacs-root-face ((t (:foreground ,(amir-dev-color 'yellow) :weight bold))))
 `(treemacs-directory-face ((t (:foreground ,(amir-dev-color 'blue)))))
 `(treemacs-file-face ((t (:foreground ,(amir-dev-color 'fg)))))
 `(treemacs-git-modified-face ((t (:foreground ,(amir-dev-color 'yellow)))))
 `(treemacs-git-added-face ((t (:foreground ,(amir-dev-color 'green)))))
 `(treemacs-git-conflict-face ((t (:foreground ,(amir-dev-color 'red))))))

;; ============================================================
;; Terminal colors
;; ============================================================

(custom-theme-set-faces
 'amir-dev
 `(term-color-black ((t (:foreground "#1d2021" :background "#1d2021"))))
 `(term-color-red ((t (:foreground "#fb4934" :background "#fb4934"))))
 `(term-color-green ((t (:foreground "#b8bb26" :background "#b8bb26"))))
 `(term-color-yellow ((t (:foreground "#fabd2f" :background "#fabd2f"))))
 `(term-color-blue ((t (:foreground "#83a598" :background "#83a598"))))
 `(term-color-magenta ((t (:foreground "#d3869b" :background "#d3869b"))))
 `(term-color-cyan ((t (:foreground "#8ec07c" :background "#8ec07c"))))
 `(term-color-white ((t (:foreground "#ebdbb2" :background "#ebdbb2")))))
;; ============================================================
;; lsp-ui-doc / documentation popup
;; ============================================================

(custom-theme-set-faces
 'amir-dev

 `(lsp-ui-doc-background
   ((t
     (:background ,(amir-dev-color 'bg-soft)
                  :foreground ,(amir-dev-color 'fg)))))

 `(lsp-ui-doc-header
   ((t
     (:background ,(amir-dev-color 'bg-highlight)
                  :foreground ,(amir-dev-color 'fg-soft)
                  :weight bold))))

 `(lsp-ui-doc-highlight-hover
   ((t
     (:background ,(amir-dev-color 'bg-current-line)
                  :foreground ,(amir-dev-color 'fg-bright)))))

 `(lsp-ui-doc-url
   ((t
     (:foreground ,(amir-dev-color 'blue)
                  :underline t))))

 `(lsp-ui-doc-symbol
   ((t
     (:foreground ,(amir-dev-color 'yellow)
                  :weight bold))))

 `(lsp-ui-doc-border
   ((t
     (:background ,(amir-dev-color 'border))))))

;; ============================================================
;; Finalize
;; ============================================================

(setq lsp-semantic-tokens-enable t)
(setq lsp-semantic-tokens-honor-refresh-requests t)
(setq lsp-semantic-tokens-apply-modifiers t)
(setq lsp-semantic-tokens-warn-on-missing-face nil)

;; (setq lsp-semantic-token-faces
;;       '(("namespace"     . font-lock-type-face)
;;         ("type"          . font-lock-type-face)
;;         ("class"         . font-lock-type-face)
;;         ("enum"          . font-lock-type-face)
;;         ("interface"     . font-lock-type-face)
;;         ("struct"        . font-lock-type-face)
;;         ("typeParameter" . font-lock-type-face)
;;         ("parameter"     . font-lock-variable-name-face)
;;         ("variable"      . font-lock-variable-name-face)
;;         ("property"      . font-lock-property-name-face)
;;         ("enumMember"    . font-lock-constant-face)
;;         ("event"         . font-lock-variable-name-face)
;;         ("function"      . font-lock-function-name-face)
;;         ("method"        . font-lock-function-name-face)
;;         ("macro"         . font-lock-keyword-face)
;;         ("label"         . font-lock-constant-face)
;;         ("comment"       . font-lock-comment-face)
;;         ("string"        . font-lock-string-face)
;;         ("keyword"       . font-lock-keyword-face)
;;         ("number"        . font-lock-number-face)
;;         ("regexp"        . font-lock-string-face)
;;         ("operator"      . font-lock-operator-face)
;;         ("decorator"     . font-lock-type-face)))



;; (setq lsp-semantic-token-modifier-faces
;;       '(("declaration"    . nil)
;;         ("definition"     . nil)
;;         ("readonly"       . nil)
;;         ("static"         . nil)
;;         ("deprecated"     . nil)
;;         ("abstract"       . nil)
;;         ("async"          . nil)
;;         ("modification"   . nil)
;;         ("documentation"  . nil)

;;         ;; ("defaultLibrary" . font-lock-type-face)
;; 	))

(setq lsp-semantic-token-modifier-faces
      '(("declaration"    . amir-dev-semantic-declaration)
        ("definition"     . amir-dev-semantic-definition)
        ("readonly"       . amir-dev-semantic-readonly)
        ("static"         . amir-dev-semantic-static)
        ("deprecated"     . amir-dev-semantic-deprecated)
        ("abstract"       . amir-dev-semantic-abstract)
        ("async"          . amir-dev-semantic-async)
        ("modification"   . amir-dev-semantic-modification)
        ("documentation"  . amir-dev-semantic-documentation)
        ("defaultLibrary" . amir-dev-semantic-default-library)))



(provide-theme 'amir-dev)

;;; amir-dev.el ends here
