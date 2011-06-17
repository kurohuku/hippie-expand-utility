(require 'cl)

(defvar mode-specified-try-functions-table (make-hash-table))

(defun set-mode-specified-try-functions (mode functions)
  (setf (gethash mode mode-specified-try-functions-table)
	functions))
(defun set-default-try-functions (functions)
  (setf (gethash :default mode-specified-try-functions-table)
	functions))

(defun expand-try-functions-of (mode)
  (let ((result 
	 (gethash mode mode-specified-try-functions-table)))
    (if (listp result) result
      (list result))))

(defun current-hippie-expand-try-function-list ()
  (remove-duplicates 
   (remove nil
	   (append
	    (apply 
	     'append
	     (mapcar 'expand-try-functions-of minor-mode-list))
	    (or (expand-try-functions-of major-mode)
		(expand-try-functions-of :default))))
   :from-end t))

(defadvice hippie-expand (around mode-specified-hippie-expand)
  (let ((hippie-expand-try-functions-list
	 (current-hippie-expand-try-function-list)))
    ad-do-it))

(defun enable-mode-specified-hippie-expand ()
  (interactive)
  (ad-enable-advice 'hippie-expand
		    'around
		    'mode-specified-hippie-expand)
  (ad-activate 'hippie-expand))

(defun disable-mode-specified-hippie-expand ()
  (interactive)
  (ad-disable-advice 'hippie-expand
		     'around
		     'mode-specified-hippie-expand)
  (ad-deactivate 'hippie-expand))

(provide 'mode-specified-hippie-expand)

