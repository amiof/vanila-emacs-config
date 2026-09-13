<p align="center">
  <img src="assets/logo.png" width="180" alt="Chadmacs logo">
</p>

# emacs Config

**A fast, modular, batteries-included vanilla Emacs configuration — Elpaca + Evil + LSP + Tree-sitter.**

my emacs config turns a vanilla Emacs into a modern, IDE-like editing environment. It is organized as
small single-concern modules (completion, LSP, UI, git, per-language files) that you enable or
disable with one line — and your personal settings live in a separate `custom.el`, so pulling
new versions never causes merge conflicts.

---

## ✨ Highlights

- **Asynchronous package management** with [Elpaca](https://github.com/progfolio/elpaca) + `use-package` — packages install and build without blocking startup
- **Vim editing** with Evil, a `SPC` leader keymap (via `general`), `which-key` discovery, and `jk` escape
- **Full LSP support** — `lsp-mode` for the core languages, built-in **Eglot** in the optional language modules, plus `lsp-ui` docs/sideline, `flycheck` diagnostics, inlay hints, and `consult-lsp`
- **Tree-sitter everywhere** — font-lock level 4, pinned grammar sources, prebuilt grammar modules bundled in `tree-sitter/`
- **Modern completion stack** — `vertico` + `orderless` + `marginalia` + `consult` in the minibuffer, `corfu` + `cape` in-buffer (popup after 1 char)
- **Project management** with `projectile` + `treemacs` + `consult-projectile`
- **Git** — `magit`, live fringe diffs with `diff-hl`, ediff helpers
- **Opinionated UI** — `doom-gruvbox` theme, nano-style header line, Moody modeline with Evil-state indicator, dashboard with custom logo, `popper` popup buffers, ligatures, indent bars, smooth scrolling
- **Smart formatting** — [Apheleia](https://github.com/radian-software/apheleia) with project-local **Biome** for JS/TS (auto-detected via `biome.json`), `ktlint`, `rustfmt`, `goimports`
- **Terminals** — `vterm` and `ghostel` (native terminal package that downloads its module on first run), both Evil-integrated
- **Tuned for speed** — GC disabled at startup + `gcmh` at runtime, 4 MB process output, deferred package loading

---

## 📁 Structure

```
.
├── early-init.el        # Pre-init tuning: GC off, no UI chrome before startup
├── init.el              # Entry point — module load order lives here
├── custom.el            # Personal overrides (gitignored by design; template auto-generated)
├── lisp/                # Core modules
│   ├── bootstrap-config.el   # Elpaca bootstrap
│   ├── core-config.el        # custom-file handling + template seeding
│   ├── lsp-config.el         # LSP, flycheck, tree-sitter
│   ├── completion-config.el  # vertico / corfu / consult / orderless / cape
│   ├── evil-config.el        # Evil + evil-collection
│   ├── keybindings-config.el # SPC leader map + custom bindings
│   ├── ui-config.el          # fonts, themes, modeline extras, ligatures
│   ├── modeline-config.el    # Moody-based modeline with nerd icons
│   ├── header.el             # nano-style header line
│   ├── tools-config.el       # magit, vterm, ghostel, treemacs, popper, ...
│   ├── formatter-config.el   # apheleia (Biome / ktlint / rustfmt / goimports)
│   └── ...
├── lang/                # One module per language (25 files)
├── theme/               # Custom gruvbox-hard-inspired theme
├── tree-sitter/         # Prebuilt tree-sitter grammar modules
└── assets/              # Dashboard logo
```

### Language modules (`lang/`)

| Category | Modules |
|---|---|
| Web | `typescript` (TS/TSX/JS/JSX), `web` (HTML/CSS/SCSS/Vue/Svelte/Emmet), `json`, `yaml` |
| Backend / scripting | `python`, `go`, `ruby`, `elixir`, `lua` |
| Systems | `rust`, `c-cpp`, `csharp`, `zig`, `swift` |
| JVM | `scala`, `kotlin` |
| Functional | `haskell`, `ocaml`, `clojure` |
| Scientific | `julia` |
| DevOps | `docker`, `terraform`, `nix` |
| Docs | `markdown` |
| Niche | `gerbil` (Scheme) |

Each module wires up the major modes, tree-sitter grammars, LSP hooks, and formatting for that
language. The header comment of every module lists the exact **LSP binary** you need to install
on your system.

---

## 🚀 Installation

### Requirements

- **Emacs 29+** (tree-sitter support; 30+ recommended)
- `git`
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) (project search)
- A **Nerd Font** — [JetBrains Mono](https://www.jetbrains.com/lp/mono/) is used by default
- `cmake` + `libtool` (to build `vterm`)
- Per-language LSP servers for the language modules you enable

### Setup

```bash
git clone https://github.com/amiof/vanila-emacs-config.git ~/.emacs.d
emacs
```

On first launch Chadmacs bootstraps itself:

1. Elpaca clones and builds itself, then installs all packages **asynchronously** — the first
   startup takes a while. Watch `*elpaca*` until the queue is done.
2. A fresh `custom.el` is generated with the language-module template.
3. Restart Emacs. Done.

> **Note:** the prebuilt tree-sitter grammars in `tree-sitter/` are Linux `.so` modules. On other
> platforms, compile what you need with `M-x treesit-install-language-grammar` — all grammar
> sources are pinned in `lisp/lsp-config.el`.

---

## 🛠 Customizing

Everything personal lives in **`custom.el`**, kept out of the core modules — upstream changes
never touch it. It ships with a commented template:

```elisp
;; Enable languages by uncommenting:
(require 'typescript-lang)   ;; TS / TSX / JS / JSX
(require 'go-lang)           ;; Go
(require 'rust-lang)         ;; Rust + rustic + cargo

;; Your font (height is 1/10 pt: 140 = 14pt):
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 140)

;; A different doom theme:
(add-hook 'elpaca-after-init-hook
          (lambda ()
            (mapc #'disable-theme custom-enabled-themes)
            (load-theme 'doom-one t)))
```

To regenerate the template from scratch, delete `custom.el` and restart Emacs.

> The `custom.el` in this repository is my personal setup (Go, Rust, Kotlin, Lua, TypeScript
> enabled). Delete or edit it freely — it will be recreated with the blank template if missing.

The default theme is `doom-gruvbox`, loaded in `lisp/ui-config.el`; the custom
`amir-dev` theme (Gruvbox Dark Hard, WebStorm-inspired) lives in `theme/`.

---

## ⌨️ Keybindings

Vim-style with `SPC` as leader (`C-SPC` works in insert state). `which-key` shows everything —
press `SPC` and wait. Highlights:

| Keys | Action |
|---|---|
| `SPC SPC` / `SPC f f` | Switch buffer / find file |
| `SPC f g` / `SPC s s` | Ripgrep project search |
| `SPC p p` / `SPC p f` | Switch project / find file in project |
| `SPC g g` / `SPC g s` | Magit status / show hunk |
| `SPC c a` / `SPC c r` / `SPC c f` | Code action / references / format |
| `SPC r n` / `SPC r f` | Rename symbol / format buffer |
| `SPC o p` / `SPC o t` | Treemacs / theme picker |
| `SPC t t` / `SPC o g` | vterm / Ghostel terminal |
| `SPC k t` / `SPC k c` | Toggle / cycle popup buffers |
| `SPC w h/j/k/l` / `SPC w u` | Window nav / undo window layout |
| `K` / `g D` | LSP doc at point / find references |
| `f` / `t` | Avy jump to char / line |
| `m` / `M` | Next / previous *real* buffer |
| `M-j` / `M-k` | Move line/selection down / up |
| `C-=` / `C-;` | Expand region / iedit multi-cursor |
| `jk` | Escape to normal mode |
| `C-c k` | Smart close (window → popup → buffer) |

---

## 🧠 Performance notes

- `early-init.el` disables package.el, cranks GC off during startup, and strips the old UI
- `gcmh` handles garbage collection at runtime (128 MB high threshold, 5 s idle delay)
- `read-process-output-max` is raised to 4 MB for snappy LSP responses
- File watchers ignore `node_modules`, `target`, `dist`, `.next`, and friends
- Projects are indexed with projectile's hybrid/alien method and cached

---

## License

Personal configuration — fork it, gut it, make it yours. If you reuse a chunk publicly, a
star is always appreciated. ⭐
