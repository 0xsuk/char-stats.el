(require 'cl-lib)

(defvar char-stats--alist '())

(defun char-stats--count-char (n &optional c)
	(if-let* ((entry (assoc c char-stats--alist))
						(count (cdr entry)))
			(setcdr entry (1+ count))
		(add-to-list 'char-stats--alist (cons c 1))
		)
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
		(cl-loop for entry in (char-stats--sort-alist) do
						 (let* ((char-code (car entry))
										(char (char-to-string char-code))
									 (count (cdr entry)))
							 (insert (format "%s(ascii:%3d):%5d\n" char char-code count))))))

(provide 'char-stats)
