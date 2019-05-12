;;;; init.el
;;; Basic initialization code for the AEON literate emacs config
;;; Tangles the aeon.org file in the emacs directory and loads it

;; Enable the debugger to allow debugging the config
(setq debug-on-error t)
(setq debug-on-quit t)

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install and initialize org-mode
(straight-use-package 'org)
(straight-use-package 'org-plus-contrib)
(require 'org)
(setq org-confirm-babel-evaluate nil
      org-src-fontify-natively t
      org-src-tab-acts-natively t)

;; Check if the literate config has been tangled recently
(let ((aeon-config (expand-file-name "aeon.org" user-emacs-directory))
      (aeon-source (expand-file-name "aeon.el" user-emacs-directory)))
  (when (or
	 (and (file-exists-p aeon-config)
	      (file-exists-p aeon-source)
	      (file-newer-than-file-p
	       aeon-config
	       aeon-source))
	 (not (file-exists-p aeon-source)))
    (org-babel-tangle-file aeon-config)))

;; Check if the config has been compiled recently
(let ((aeon-source (expand-file-name "aeon.el" user-emacs-directory))
      (aeon-compiled (expand-file-name "aeon.elc" user-emacs-directory)))
  (when (or
	 (and (file-exists-p aeon-source)
	      (file-exists-p aeon-compiled)
	      (file-newer-than-file-p
	       aeon-source
	       aeon-compiled))
	 (not (file-exists-p aeon-compiled)))
    (byte-compile-file aeon-source)))

;; Load the config
(load-file (expand-file-name "aeon.elc" user-emacs-directory))

;; Disable the debugger now that the config has loaded
(setq debug-on-error nil)
(setq debug-on-quit nil)
