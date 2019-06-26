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

(defun aeon//load-aeon ()
  (let ((aeon-compiled (expand-file-name "aeon.elc" user-emacs-directory))
	(aeon-source (expand-file-name "aeon.el" user-emacs-directory))
	(aeon-config (expand-file-name "aeon.org" user-emacs-directory)))
    (when (or (not (file-exists-p aeon-compiled))
	      (and (file-exists-p aeon-config)
		   (file-exists-p aeon-compiled)
		   (file-newer-than-file-p
		    aeon-config
		    aeon-compiled)))
      (org-babel-tangle-file aeon-config)
      (byte-compile-file aeon-source)
      (delete-file aeon-source))
    (load-file aeon-compiled)))

(aeon//load-aeon)

;; Disable the debugger now that the config has loaded
(setq debug-on-error nil)
(setq debug-on-quit nil)
