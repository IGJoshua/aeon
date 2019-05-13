((org-mode . ((eval . (add-hook 'after-save-hook
                                (lambda ()
                                  (let ((tangled-files (org-babel-tangle (buffer-file-name) nil 'emacs-lisp)))
                                    (cl-loop for file in tangled-files
                                             do
                                             (byte-compile-file file t))))
                                nil
                                t)))))
