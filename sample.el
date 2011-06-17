(require 'mode-specified-hippie-expand)
(require 'try-complete-slime-symbol)

;; デフォルト値の定義。
;; メジャーモードに対するtry-functions-listが存在しない場合に利用される
(set-default-try-functions
 '(try-complete-file-name-partially
  try-complete-file-name
  try-expand-all-abbrevs
  try-expand-dabbrev
  try-expand-dabbrev-all-buffers
  try-expand-dabbrev-from-kill))

;; lisp用
(dolist (mode
	  '(emacs-lisp-mode
	    lisp-mode
	    lisp-interaction-mode))
  (set-mode-specified-try-functions
   mode
   '(try-complete-lisp-symbol-partially
     try-complete-lisp-symbol)))

;; slime用
(dolist (mode '(slime-mode slime-repl-mode))
  (set-mode-specified-try-functions
   mode
   '(try-complete-slime-symbol)))

(defun hippie-expand-in-buffers ()
  (interactive)
  (flet ((current-hippie-expand-try-function-list
	  ()
	  `(try-expand-dabbrev
	    try-complete-file-name-partially
	    try-expand-line
	    try-expand-line-all-buffers)))
    (call-interactively 'hippie-expand)))

(global-set-key (kbd "C-t") 'hippie-expand-in-buffers)




	    
						  
	  
	 
						 
  