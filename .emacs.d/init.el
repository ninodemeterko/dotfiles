;; Personal config ================================================================================

;; Disable "bloat" to make emacs look more minimal
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Change font
(set-face-attribute 'default nil :font "NotoMono Nerd font" :height 110)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Add line numbers
(add-hook 'prog-mode-hook 'menu-bar--display-line-numbers-mode-relative)

;; Kill buffers witout prompt
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

;; Packages  ======================================================================================

;; Set up package.el to work with MELPA
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Download and install use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)


;; Define keymaps  ================================================================================

(use-package general
  :config (general-evil-setup t)
  (general-create-definer leader-key
    :keymaps '(normal visual emacs insert)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (leader-key
    "e" 'dired
    "RET" 'term
    "g" 'magit-status))

;; Install and configure packages ===============================================================

(use-package undo-fu) ;; better redo functionality for evil mode
;; Vim mode
(use-package evil
  :init (setq evil-undo-system 'undo-fu)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :bind (:map evil-insert-state-map ;; Alt + Movement keys to exit insert mode
		("M-h" . 'evil-normal-state)
	      ("M-j" . (lambda () (interactive) (evil-normal-state) (evil-next-line)))
	      ("M-k" . (lambda () (interactive) (evil-normal-state) (evil-previous-line)))
	      ("M-l" . (lambda () (interactive) (evil-normal-state) (evil-forward-char 2)))
	      ("C-h" . 'evil-delete-backward-char-and-join)
	      ("TAB" . 'tab-to-tab-stop))
  :config (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-commentary ;; Evil comment support
  :config (evil-commentary-mode))

(use-package evil-surround ;; Evil surround (ys* to add surrounding cs<old><new> change surrounding)
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package hydra) ;; create temporary keymaps

(use-package magit)

;; ivy stuff 
(use-package swiper)
(use-package counsel
  :config (counsel-mode 1)
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^
(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode 1))
(use-package ivy 
  :diminish
  :bind (:map ivy-minibuffer-map
	      ("C-l" . ivy-alt-done)
	      ("C-j" . ivy-next-line)
	      ("<tab>" . ivy-next-line)
	      ("<up>" . ivy-previous-history-element)
	      ("<down>" . ivy-next-history-element)
	      ("C-k" . ivy-previous-line)
	      :map ivy-switch-buffer-map
	      ("C-k" . ivy-previous-line)
	      ("C-l" . ivy-done)
	      ("C-d" . ivy-switch-buffer-kill)
	      :map ivy-reverse-i-search-map
	      ("C-k" . ivy-previous-line)
	      ("C-d" . ivy-reverse-i-search-kill))
  :config
  (leader-key
    "s" 'swiper
    "C-s" 'swiper
    "b" 'counsel-switch-buffer
    "C-b" 'counsel-switch-buffer)
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package ivy-rich
  :config (ivy-rich-mode 1))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package all-the-icons   ;; icon font
  :if (display-graphic-p))

;; Doom mode-line
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 30))
  :config (setq doom-modeline-indent-info t))

;; Themes
(use-package doom-themes
  :config 
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-tomorrow-night t)
  (doom-themes-org-config))

(use-package projectile ; Project manager
  :diminish projectile-mode
  :config 
  (leader-key
    "p" 'projectile-command-map)) ; Leader (SPC) + p to open projectile map

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Org mode
(use-package org)

;; Better help
(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Automaticaly created stuff {{{
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "0d01e1e300fcafa34ba35d5cf0a21b3b23bc4053d388e352ae6a901994597ab1" "3319c893ff355a88b86ef630a74fad7f1211f006d54ce451aab91d35d018158f" default))
 '(package-selected-packages
   '(evil-magit magit evil-surround counsel-projectile counsel-projecttile projectile hydra evil-collection general doom-themes all-the-icons ivy-rich counsel doom-modeline evil-commentary swiper ivy use-package evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; }}}
