;;; Commentary: This is super lite version of Hung's usual Emacs
;;; configuration. I try to provide the file with some comments so
;;; that you or anyone can use it.
(require 'package)
;;; Code:

;; Configure straight: A package for managing package installation.
(setq straight-check-for-modifications '(check-on-save find-when-checking))
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage));; And then use-package to install, manage configurations and manage

;; key bindings for different packages.
(straight-use-package 'use-package)
(eval-when-compile
  (require 'use-package))
(straight-use-package 'diminish)

;; Some basic theming
(setq inhibit-splash-screen t)		; no splash screen, thanks
(tool-bar-mode -1)			; no tool bar with icons
(scroll-bar-mode -1)			; no scroll bars
(menu-bar-mode -1)
(fringe-mode '(4 . 0))                  ; left fringe only, and a very small one
(load-theme 'wombat)

;;; Configuration variable
(setq user-use-company nil)              ; Use company for completion
(setq user-use-corfu t)		         ; Use corfu for completion

;; Auto-complete
(use-package company
  :straight t
  :if user-use-company
  :demand
  :commands global-company-mode
  :config
  (add-hook 'after-init-hook 'global-company-mode)

  ;; Set the desired backend
  (add-hook 'python-mode-hook
	    (lambda ()
	      (setq-local company-backends
			  '(company-dabbrev-code company-files company-capf))))

  (setq-default
   company-idle-delay 0.05
   company-minimum-prefix-length 3
   
   ;; get only preview
   ;; company-frontends '(company-preview-frontend)
   ;; also get a drop down
   ;; company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
   )

  (setq company-dabbrev-other-buffers t)
  (setq company-dabbrev-time-limit 0.05))

(use-package corfu
  :straight t
  :if user-use-corfu
  :demand
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-auto-delay 0)
  (corfu-auto-prefix 1)
  (corfu-separator ?\s)             ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin
  :init
  (global-corfu-mode))

;; Yas-snippet
(use-package yasnippet
  :straight t
  :demand
  ;; Load the snippet after general
  :after general
  :config
  (yas-global-mode 1)
  (general-define-key
   :states '(normal visual insert)
   "C-e" 'yas-expand
   )
  )


;; Move auto-save files
(use-package no-littering
  :demand t
  :straight t
  :config
  (setq auto-save-file-name-transforms
	`((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (message "Setting autosave dir to %s" (no-littering-expand-var-file-name "auto-save/")))

;; A git client
(use-package magit
  :straight t
  :ensure
  :after general
  :config
  (general-define-key
   :states '(normal visual insert)
   "C-x C-z" 'magit-status
   "C-c g" 'magit-file-dispatch
   "C-c M-g" 'magit-dispatch
   )
  
  ;; Global key map for non-evil modes
  (general-define-key
   "C-x C-z" 'magit-status))


;; For managing keys and stuffs
(use-package general
  :ensure t
  :straight t)

;;; Improve the menus with Ivy
(use-package ivy
  :diminish t
  :straight t
  :demand
  :general
  ("C-x C-c" 'ivy-switch-buffer)
  ("C-c C-r" 'ivy-resume)
  :config
  (ivy-mode 1)
  (setq ivy-count-format "(%d/%d) ")
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
	;; allow input not in order
	'((t   . ivy--regex-fuzzy))))

;;; Improve the menus with Ivy
(use-package smex
  :straight t)

;; Nice switching windows
(use-package counsel
  :straight t
  :demand
  :after smex ivy
  :general
  ("C-s" 'swiper-isearch)
  ;; ("M-x" 'counsel-M-x)
  ("C-x C-f"  'counsel-find-file)
  ("C-c k" 'counsel-ag))

(use-package prescient
  :straight t)

(use-package ivy-prescient
  :straight t
  :config
  (ivy-prescient-mode t))

;;; Searching with ripgrep
(use-package rg
  :straight t
  :demand
  :custom
  (rg-custom-type-aliases
   '(
     ("py" . "*.py *.pyx *.ui *.pxd, *.pxi, *.pyx")
     ("groovy" . "*.gradle, *.groovy *Jenkinsfile*")
     )
   )
  (rg-executable "/usr/bin/rg")
  :config
  (rg-enable-default-bindings))


;; Vim key binding
(use-package evil
  :straight t
  :demand
  :after general
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode t)

  ;; Define additional scrolling functionality for evil-mode
  (defun scroll-down-half-page ()
    "Scroll down half page."
    (interactive)
    (evil-scroll-down 0))

  (defun scroll-up-half-page ()
    "Scroll down half page."
    (interactive)
    (evil-scroll-up 0))

  ;; key binding in evil and global-map
  (global-unset-key (kbd "C-j"))
  (global-unset-key (kbd "C-i"))
  (global-unset-key (kbd "C-k"))

  (general-define-key
   :states '(normal visual motion)
   "C-i" 'scroll-up-half-page
   "C-d" 'scroll-down-half-page
   "C-j H" 'evil-window-vsplit
   "C-j V" 'evil-window-split
   "C-j K" 'evil-window-delete
   "C-j f" 'evil-avy-goto-char-timer

   "C-j j" 'evil-window-down
   "C-j k" 'evil-window-up
   "C-j h" 'evil-window-left
   "C-j l" 'evil-window-right
   "C-j o" 'other-window
   )
  
  (evil-add-hjkl-bindings occur-mode-map 'emacs
    (kbd "/")       'evil-search-forward
    (kbd "n")       'evil-search-next
    (kbd "N")       'evil-search-previous
    (kbd "C-d")     'evil-scroll-down
    (kbd "C-i")     'evil-scroll-up)
  
  ;; key for editing
  (general-define-key
   :states 'insert
   "C-n" 'next-line
   "C-p" 'previous-line
   "C-e" 'end-of-line
   "C-a" 'beginning-of-line
   ;; In insert mode, C-i or TAB is used for copilot completion
   "C-i" 'copilot-complete
   "C-d" nil
   )
  )


(use-package evil-collection
  :after evil
  :straight t
  :config
  (evil-collection-init 'magit)
  (evil-collection-init 'magit-section)
  (evil-collection-init 'dired)
  (evil-collection-init 'wgrep)
  (evil-collection-init 'rg)
  (evil-collection-init 'occur))

(use-package evil-nerd-commenter
  :after evil
  :straight t
  :config
  (general-define-key
   :states '(normal visual)
   ",ci" 'evilnc-comment-or-uncomment-lines
   ",cl" 'evilnc-comment-or-uncomment-to-the-line
   ",cc" 'evilnc-copy-and-comment-lines
   ",cp" 'evilnc-comment-or-uncomment-paragraphs))

(use-package evil-surround
  :straight t
  :after evil
  :config
  (global-evil-surround-mode 1)
  ;; To surround a code segment with $, hightlight it then press `csm`.
  (add-hook 'org-mode-hook
	    (lambda () (push '(?m . ("$" . "$")) evil-surround-pairs-alist))))


;; Co-pilot for code completion
(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :ensure t
  :hook (prog-mode . copilot-mode)
  :config 

  ;; This configuration allows using company-mode for completion with copilot.
  (with-eval-after-load 'company
    ;; disable inline previews
    (delq 'company-preview-if-just-one-frontend company-frontends))

  ;; Define key bindings for copilot
  ;; Tab to accept completion
  ;; C-w to accept completion by word
  (general-define-key
   :keymaps 'copilot-completion-map
   "<tab>" 'copilot-accept-completion
   "TAB" 'copilot-accept-completion
   "C-l" 'copilot-accept-completion
   "C-w" 'copilot-accept-completion-by-word
   ))

(use-package jenkinsfile-mode
  :straight t
  :mode (("Jenkinsfile" . jenkinsfile-mode)
	 ("\\.jenkinsfile\\'" . jenkinsfile-mode))
  :config
  (setq jenkinsfile-mode-indent-offset 2)

  ;; add a hook to set indent-tab-mode to nil
  (add-hook 'jenkinsfile-mode-hook
	    (lambda () (setq indent-tabs-mode nil)))
  )

(use-package markdown-mode
  :straight t)

(use-package dockerfile-mode
  :straight t)

(use-package cmake-mode
  :straight t)

(use-package google-c-style
  :straight t
  :config
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-make-newline-indent))

(defun python-occur-definitions ()
  "Display an occur buffer of all definitions in the current buffer.

  Also, switch to that buffer."
  (interactive)
  (let ((list-matching-lines-face nil))
    (occur "^ *\\(async def\\|def\\|class\\|cdef\\|cpdef\\) \\|# #\\|TODO\\|FIXME"))
  ;; (occur-mode-clean-buffer)
  (let ((window (get-buffer-window "*Occur*")))
    (if window
	(select-window window)
      (switch-to-buffer "*Occur*"))))

(general-define-key
 :keymaps 'python-mode-map
 :state '(motion visual normal insert)
 "C-c C-o" 'python-occur-definitions
 )

(general-define-key
 "C-c f f" 'eglot
 "C-c q" 'save-buffers-kill-terminal
 )

;; Experimental part
(use-package go-translate
  :straight t
  :after posframe
  :config
  (setq gts-translate-list '(("zh" "en")))
  (setq gts-default-translator
	(gts-translator
	 :picker (gts-prompt-picker)
	 :engines (list (gts-google-engine))
	 :render (gts-buffer-render)
	 )))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e8567ee21a39c68dbf20e40d29a0f6c1c05681935a41e206f142ab83126153ca" "06ed754b259cb54c30c658502f843937ff19f8b53597ac28577ec33bb084fa52" "d516f1e3e5504c26b1123caa311476dc66d26d379539d12f9f4ed51f10629df3" "c95813797eb70f520f9245b349ff087600e2bd211a681c7a5602d039c91a6428" "74e2ed63173b47d6dc9a82a9a8a6a9048d89760df18bc7033c5f91ff4d083e37" "55c81b8ddb2b6c3fa502b1ff79fa8fed6affe362447d5e72388c7d160a2879d0" "8721f7ee8cd0c2e56d23f757b44c39c249a58c60d33194fe546659dabc69eebd" default))
 '(safe-local-variable-values
   '((ggtags-process-environment "GTAGSLIBPATH=/usr/include:/opt/ros/noetic/include"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
