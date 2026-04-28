(defpackage #:meta-definitions.derive.readers
  (:use #:cl)
  (:import-from #:meta-definitions #:declarations)
  (:export #:derive-readers))

(in-package #:meta-definitions.derive.readers)

(defmacro derive-readers (class-name)
  (let ((spec (gethash (symbol-name class-name) declarations)))
    (destructuring-bind (class-spec slots-spec)
	spec
      (declare (ignore class-spec))
      (let ((slots (cdr slots-spec)))
	`(progn
	   ,@(mapcar (lambda (slot)
		       (destructuring-bind (slot-name &rest attrs)
			   slot
			 (declare (ignore attrs))
			 (let* ((sym-name (string-upcase
					   (concatenate
					    'string
					    (symbol-name class-name)
					    "-"
					    (symbol-name slot-name))))
				(reader-name (intern sym-name)))
			   `(progn
			      (defun ,reader-name (obj)
				(slot-value obj ',slot-name))
			      (export ',reader-name)))))
		     slots))))))
