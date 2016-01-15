(require 'use-package)

;; Theme-config (and old theme configs)

;; required for zonokai
;; (use-package dash
;;   :ensure t
;;   )
;;(use-package zonokai-theme
;;  :ensure t
;;  )

;; (use-package abyss-theme
;;   :ensure t
;;   )

(use-package seti-theme
  :ensure t
  )

(use-package helm
  :ensure t
  :init
  (define-key global-map "\C-xb" 'helm-mini)
  :config
  (setq helm-mini-default-sources '(helm-source-buffers-list
				    helm-source-recentf
				    helm-source-bookmarks
				    helm-source-buffer-not-found))
  (helm-mode 1)
  )

;;(use-package helm-themes
;;  :ensure t
;;  :config
;;  (helm-themes--load-theme "zonokai-blue")
;;  )
;; Change the cursor after setting the theme
(setq-default cursor-type 'hbar)

;; doesn't work
;; (use-package spaceline
;;  :config
;;   (spaceline-emacs-theme)
;;   (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state))

;; Put this somewhere useful
(add-to-list 'exec-path "C:/Program Files/Git/bin")
;; The Windows User-Home needs to be in some kind of path such that magit finds the .gitconfig
(use-package magit
  :ensure t
  :init
  (define-key global-map (kbd "C-c m") 'magit-status)
  (setenv "GIT_ASKPASS" "git-gui--askpass")
  )

(use-package ace-jump-mode
  :ensure t
  :init
  (define-key global-map (kbd "C-M-q") 'ace-jump-mode)
  )

(use-package org
  :ensure t
  :init
  ;; load org-babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
	 (lisp . t)
	 (sh . t)
	 (perl . t)
	 ))
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda)
  (define-key global-map "\C-cc" 'org-capture)
  (define-key global-map "\M-n" 'org-metadown)
  (define-key global-map "\M-p" 'org-metaup)
  (define-key org-mode-map (kbd "<f5>") 'org-babel-execute-src-block)
  (global-set-key (kbd "<f9>") 'org-todo)
  ;; Load syntax-highlighting for source-blocks
  (setq org-src-fontify-natively t)
  (setq org-export-coding-system 'utf-8-unix)
  (setq org-log-done t)
  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
  (global-set-key [(control next)] 'next-buffer)
  (global-set-key [(control prior)] 'previous-buffer)
  ;; Visual modifications
  ;; Strike through DONE headlines (from sachachuas config)
  (setq org-fontify-done-headline t)
  (custom-set-faces
   ;; '(org-done ((t (:weight normal
   ;;                 :strike-through t))))
   ;; '(font-lock-comment-face ((t (:foreground "dark slate blue" :slant italic))))

   ;; Color the Org-Blocks beautifully
   ;; org-block :background messes out the outline background :(
   ;;'(org-block-background ((t (:background "dark orange"))))
   ;;'(org-block-begin-line ((t (:background "SlateBlue4"))))
   ;;'(org-block-end-line ((t (:background "SlateBlue4"))))
   '(org-block-foreground ((t (:foreground "dark orange"))))
   '(org-block-begin-line ((t (:foreground "SlateBlue4"))))
   '(org-block-end-line ((t (:foreground "SlateBlue4"))))
   ;; if the background is not set the outlines that contain an org-block will have weird background colors even when folded
   ;; nvm
   ;;'(font-lock-function-name-face ((t (:background "black"))))
   '(org-document-title ((t (:foreground "ghost white" :weight bold :height 1.44))))
   '(org-headline-done ((((class color) (min-colors 16) (background dark)) (:strike-through t))))
  )
  ;; autofill hooks for automatic indentation
  (add-hook 'change-log-mode-hook 'turn-on-auto-fill)
  (add-hook 'org-mode-hook 'turn-on-auto-fill)
  (setq auto-hscroll-mode nil)
  (setq org-tags-column -93)
  ;; change from ... to the arrow
  (setq org-ellipsis "⤵")
  ;; orgmode archive done tasks
  (defun my-org-archive-done-tasks ()
	(interactive)
	(org-map-entries 'org-archive-subtree "/DONE" 'file)
	(org-map-entries 'org-archive-subtree "/CANCELED" 'file)
	(org-map-entries 'org-archive-subtree "/DELEGATED" 'file)
  )
  ;; calfw-org doesn't exist on the emacs repositories right now
  ;; git clone https://github.com/kiwanami/emacs-calfw.git
  (require 'calfw-org)
  :config
  (setq org-export-with-sub-superscripts nil)
  ;; indicate sublevels in parts of org-agenda, for example
  (setq org-tags-match-list-sublevels 'indented)
  )

;; (use-package org-bullets
;;   :ensure t
;;   :init
;;   (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;   )

;; Inserts highlighting of Org Source-Blocks on Html-Export
(use-package htmlize
  :ensure t
  )

(use-package tramp
  :ensure t
  :init
  (setq tramp-verbose 5)
  ;; sshx is the required for cygwin
  (setq default-tramp-method "sshx")
  ;; Fix for base64 error
  ;; see footnotes here: http://www.howardism.org/Technical/Emacs/literate-devops.html
  ;; you can try this:
  ;;(setq tramp-remote-coding-commands '(b64 "base64" "base64 -d -i"))
  ;; When connecting to a remote server it usually does source the profile, but for some
  ;; reason doesn't do that for $PATH by default. You'll have to specifically tell tramp
  ;; to do that from your .emacs. with
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  :config
  (define-minor-mode sensitive-mode
	"For sensitive files like password lists.
                It disables backup creation and auto saving.

                With no argument, this command toggles the mode.
                Non-null prefix argument turns on the mode.
                Null prefix argument turns off the mode."
	;; The initial value.
	nil
	;; The indicator for the mode line.
	" Sensitive"
	;; The minor mode bindings.
	nil
	(if (symbol-value sensitive-mode)
		(progn
		  ;; disable backups
		  (set (make-local-variable 'backup-inhibited) t)
		  ;; disable auto-save
		  (if auto-save-default
			  (auto-save-mode -1)))
										;resort to default value of backup-inhibited
	  (kill-local-variable 'backup-inhibited)
										;resort to default auto save setting
	  (if auto-save-default
		  (auto-save-mode 1))))
  )

(use-package yasnippet
  :ensure t
  :init
  (define-key global-map "\C-cy" 'yas/insert-snippet)
  ;;(setq yas-snippet-dirs (append yas-snippet-dirs
  ;;"~/.emacs.d/elpa/yasnippet-20150912.1330/snippets/"))
  :config
  (yas-global-mode 1)
  )

(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
  )

(use-package vbasense
  :ensure t
  :init
  ;; Keybinding
  (setq vbasense-popup-help-key "C-:")
  (setq vbasense-jump-to-definition-key "C->")
  ;; Make config suit for you. About the config item, eval the following sexp.
  ;; (customize-group "vbasense")
  ;; Do setting a recommemded configuration
  (vbasense-config-default)
  )
