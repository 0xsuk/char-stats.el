;;; package --- Summary

;; Author: 0xsuk
;; Version: 1.0
;; URL: https://github.com/0xsuk/char-stats.el
;; License: None

;;; Commentary:
;;; char stats

;;; Code:
(require 'cl-lib)

(defvar char-stats--alist '())

(defun char-stats--count-char (n &optional c)
	(when c
		(if-let* ((entry (assoc c char-stats--alist))
							(count (cdr entry)))
				(setcdr entry (1+ count))
			(add-to-list 'char-stats--alist (cons c 1))
			))
	)

(defun char-stats--sort-alist ()
	(sort char-stats--alist (lambda (a b) (> (cdr a) (cdr b)))))

(defun char-stats-restart ()
	"Restart char-stats."
	(interactive)
	(advice-remove 'self-insert-command #'char-stats--count-char)
	(setf char-stats--alist '())
	(advice-add 'self-insert-command :before #'char-stats--count-char)
	(message "char-stats restarted."))

(defun char-stats-print-stats ()
	"Print char-stats to buffer."
	(interactive)
	(with-current-buffer (get-buffer-create "*char-stats*")
		(erase-buffer)
		(cl-loop for entry in (char-stats--sort-alist) do
						 (let ((char (char-to-string (car entry)))
									 (count (cdr entry)))
							 (insert (format "'%s':%5d times\n" char count)))))
	(display-buffer "*char-stats*")
	)

(provide 'char-stats)
;;; char-stats.el ends here
