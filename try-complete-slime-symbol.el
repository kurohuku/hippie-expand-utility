
(require 'cl)

(defun try-complete-slime-symbol (old)
  (unless old
    (he-init-string (he-lisp-symbol-beg) (point))
    (unless (he-string-member he-search-string he-tried-table)
      (setq he-tried-table (cons he-search-string he-tried-table)))
    (setq he-expand-list
	  (and (not (equal he-search-string ""))
	       (sort
		(case slime-complete-symbol-function
		  ((slime-simple-complete-symbol)
		   (get-completions/slime-simple-complete he-search-string))
		  ((slime-fuzzy-completions)
		   (get-completions/slime-fuzzy-complete-symbol he-search-string))
		  ((slime-complete-symbol*)
		   (get-completions/slime-complete-symbol*))
		  (t (error "unexpected slime-complete-symbol-function")))
		'string-lessp))))
  (while (and he-expand-list
	      (he-string-member (car he-expand-list) he-tried-table))
    (setq he-expand-list (cdr he-expand-list)))
  (if (null he-expand-list)
      (progn
	(when old (he-reset-string))
	nil)
      (progn
	(he-substitute-string (car he-expand-list))
	(setq he-expand-list (cdr he-expand-list))
	t)))

(defun get-completions/slime-simple-complete-symbol (prefix)
  (car (slime-simple-completions prefix)))

(defun get-completions/slime-fuzzy-complete-symbol (prefix)
  (car (slime-fuzzy-completions prefix)))

(defun get-completions/slime-complete-symbol* ()
  " -> slime-maybe-complete-as-filename , slime-expand-abbreviations-and-complete"
  (let ((end (move-marker (make-marker) (slime-symbol-end-pos)))
	(beg (move-marker (make-marker) (slime-symbol-start-pos))))
    (let ((completions (slime-contextual-completions beg end)))
      (car completions))))

(provide 'try-complete-slime-symbol)
