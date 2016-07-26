(require 'package)

;; Create the elpa directory if it doesnt exist since emacs will otherwise complain while loading the packages
(unless (file-exists-p "~/.emacs.d/elpa")
  (make-directory "~/.emacs.d/elpa"))

;; Set the environment-variable "SYSENV" for this to (home/work/laptop/linux-vm)
(setq sysenvconf-path "~/.emacs.d/environment-specific/")
(cond ((equal "work" (getenv "SYSENV"))
       (if (file-exists-p (concat sysenvconf-path "work.el")) (load (concat sysenvconf-path "work.el"))))
      ((equal "home" (getenv "SYSENV"))
       (if (file-exists-p (concat sysenvconf-path "home.el")) (load (concat sysenvconf-path "home.el"))))
      ((equal "laptop" (getenv "SYSENV"))
       (if (file-exists-p (concat sysenvconf-path "laptop.el")) (load (concat sysenvconf-path "laptop.el"))))
      ((equal "linux-vm" (getenv "SYSENV"))
       (if (file-exists-p (concat sysenvconf-path "linux-vm.el")) (load (concat sysenvconf-path "linux-vm.el"))))
      ;; The default t, meaning the condition is always true
      ;; In that case I'm  loading my university-settings
      ;; The reason being that I can't set environment variables on university-PCs
      (t
       (if (file-exists-p (concat sysenvconf-path "university.el")) (load (concat sysenvconf-path "university.el"))))
      )

(setq package-enable-at-startup nil)
(setq package-archives nil)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; Disable the updating of the package-list on startup to increase startup time
;;(package-refresh-contents)
;; Problems:
;; yasnippet doesnt unpack from melpa
;; usepackage is only available on melpa
;; smartparens crashes when not installed from melpa

(package-initialize)

(let ((default-directory "~/.emacs.d/elpa/"))
  (normal-top-level-add-subdirs-to-load-path))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Load my use-package definitions
(load "~/.emacs.d/my-usepackages.el")

;; Load my elisp-goodise
(load "~/.emacs.d/elisp-goodies.el")

;; Remove ^M Errors in Babel
(add-to-list 'process-coding-system-alist
      '("bash" . (undecided-unix)))
(add-hook 'comint-output-filter-functions
          'comint-strip-ctrl-m)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq show-trailing-whitespace t)

;; Disable tabs
(setq-default indent-tabs-mode nil)

;; Show matching parenthesis without delay
(setq show-paren-delay 0)
(show-paren-mode t)

;; Save minibuffer history
(savehist-mode 1)
;; Delete duplicates in minibuffer history
(setq history-delete-duplicates t)
(setq history-length 1000)

;; Take the short answer, y/n is yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Overwrite selected text
(delete-selection-mode t)

;; Highlight current line (slows down C-n and C-p immensly)
;; (global-hl-line-mode 1)
;; (set-face-background 'hl-line "#cc0033") ;; crimson

;; Eshell
(add-hook 'eshell-mode-hook '(lambda ()
			       ;; Make the eshell behave like a normal shell
                               (local-set-key (kbd "C-p") 'eshell-previous-input)
                               (local-set-key (kbd "M-p") 'previous-line)
			       (local-set-key (kbd "C-n") 'eshell-next-input)
                               (local-set-key (kbd "M-n") 'next-line)
			       (setq pcomplete-cycle-completions nil)
			       ))
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
(custom-set-faces
 '(eshell-ls-archive ((t (:foreground "gold1" :weight bold))))
 '(eshell-ls-backup ((t (:foreground "LemonChiffon1"))))
 '(eshell-ls-directory ((t (:foreground "brown1" :weight bold))))
 '(eshell-prompt ((t (:foreground "firebrick" :weight bold))))
 )

;; Emacs Startup changes
(setq inhibit-default-init t)
(setq inhibit-splash-screen t)
(setq transient-mark-mode 1)

;; Line intendation
(setq-default fill-column 98)
(setq auto-hscroll-mode t)
(setq hscroll-step 1)
(auto-fill-mode 1)
(define-key global-map "\C-cf" 'auto-fill-mode)
(setq tab-width 4)

;; Dired
(setq dired-listing-switches "-alh")

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))
;; Default to unified diffs
(setq diff-switches "-u")

;; Transparency
(set-frame-parameter (selected-frame) 'alpha '(100 100))
(add-to-list 'default-frame-alist '(alpha 100 100))

;; customize the interface on windows
(when window-system
  (tooltip-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  )

;; Remove alarm (bell) on scroll
(setq ring-bell-function 'ignore)

;; Intuitive Buffer-changing
(global-set-key [(control next)] 'next-buffer)
(global-set-key [(control prior)] 'previous-buffer)

;; Fonts
;; (set-frame-font "Source Code Pro-11" nil t)
;; How to install on ubuntu:
;; #!/bin/bash
;; mkdir /tmp/adodefont
;; cd /tmp/adodefont
;; wget https://github.com/adobe-fonts/source-code-pro/archive/2.010R-ro/1.030R-it.zip
;; unzip 1.030R-it.zip
;; mkdir -p ~/.fonts
;; cp source-code-pro-2.010R-ro-1.030R-it/OTF/*.otf ~/.fonts/
;; fc-cache -f -v

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

;; Windows-specific settings
(if (eq system-type 'windows-nt)
    ;; Set the font
    (set-default-font "-outline-Consolas-normal-normal-normal-mono-16-*-*-*-c-*-iso8859-1")
    )

;; stop cursor from blinking
(blink-cursor-mode 0)
(if (fboundp 'blink-cursor-mode)
    (blink-cursor-mode 0))
