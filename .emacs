;; Load-Path

(require 'package)

;; Set the environment-variable SYSENV for this to "home" or "work"
(if (equal "home" (getenv "SYSENV"))
    (if (file-exists-p "~/.emacs.d/home.el") 
	(load "~/.emacs.d/home.el")))
(if (equal "work" (getenv "SYSENV"))
    (if (file-exists-p "~/.emacs.d/work.el") 
	(load "~/.emacs.d/work.el")))

(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(let ((default-directory "~/.emacs.d/elpa/"))
  (normal-top-level-add-subdirs-to-load-path))

;; Experimental exec-paths
;;(setq exec-path (append exec-path '("C:/Program Files (x86)/Git/bin")))
;;(setq load-path (append load-path '("C:/cygwin/fakecygpty")))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Load my packages
(load "~/.emacs.d/my-usepackages.el")

;; Coding System
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;; Emacs Startup changes 
(setq inhibit-default-init t)
(setq inhibit-splash-screen t)
(setq transient-mark-mode 1)

;; Line intendation
(setq-default fill-column 99)
(auto-fill-mode 1)
(define-key global-map "\C-cf" 'auto-fill-mode)
(setq tab-width 4)

;; Dired
(setq dired-listing-switches "-alh")

;; eshell
(add-hook
 'eshell-mode-hook
 (lambda ()
   (setq pcomplete-cycle-completions nil)))
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))
;; default to unified diffs
(setq diff-switches "-u")

;; transparency
(set-frame-parameter (selected-frame) 'alpha '(95 95))
(add-to-list 'default-frame-alist '(alpha 95 95))
;;(set-frame-font "Source Code Pro-16" nil t)

;; customize the interface on windows
(when window-system
  (tooltip-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode 1)
  (scroll-bar-mode -1))

;; Remove alarm (bell) on scroll
(setq ring-bell-function 'ignore)

;; Fonts
;; "Select an Emacs font from a list of known good fonts and fontsets.
(defun mouse-set-font (&rest fonts)
  ;;If `w32-use-w32-font-dialog' is non-nil (the default), use the Windows
  ;;font dialog to display the list of possible fonts.  Otherwise use a
  ;;pop-up menu (like Emacs does on other platforms) initialized with
  ;;the fonts in `w32-fixed-font-alist'.
  ;;If `w32-list-proportional-fonts' is non-nil, add proportional fonts
  ;;to the list in the font selection dialog (the fonts listed by the
  ;;pop-up menu are unaffected by `w32-list-proportional-fonts')."
  (interactive
   (if w32-use-w32-font-dialog
       (let ((chosen-font (w32-select-font (selected-frame)
					   w32-list-proportional-fonts)))
	 (and chosen-font (list chosen-font)))
     (x-popup-menu
      last-nonmenu-event
      ;; Append list of fontsets currently defined.
      ;; Conditional on new-fontset so bootstrapping works on non-GUI compiles
      (if (fboundp 'new-fontset)
      (append w32-fixed-font-alist (list (generate-fontset-menu)))))))
  (if fonts
      (let (font)
	(while fonts
	  (condition-case nil
	      (progn
                (setq font (car fonts))
		(set-default-font font)
                (setq fonts nil))
	    (error (setq fonts (cdr fonts)))))
	(if (null font)
	    (error "Font not found")))))

;; My favorite font on Windows
(if (eq system-type 'windows-nt)
    (set-default-font "-outline-Consolas-normal-normal-normal-mono-16-*-*-*-c-*-iso8859-1")
    )
