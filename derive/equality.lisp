(defpackage #:meta-definitions.derive.equality
  (:use #:cl)
  (:import-from #:meta-definitions #:declarations)
  (:export #:derive-equality))

(in-package #:meta-definitions.derive.equality)

(defmacro derive-equality (class-name)
  (let ((spec (gethash (symbol-name class-name) declarations)))
    (destructuring-bind (class-spec slots-spec)
	spec
      (declare (ignore class-spec))
      (let* ((slots (cdr slots-spec))
	     (check-pairs (mapcar (lambda (slot)
				    (let* ((slot-name (car slot))
					   (attrs (cdr slot))
					   (slot-type (getf attrs :type))
					   (is-nullable (member 'null (uiop:ensure-list slot-type)))
					   (eq-fn (getf attrs :equality-fn))
					   (slot-eq (if eq-fn eq-fn ''equal))
					   (base `(funcall ,slot-eq
							   (slot-value a ',slot-name)
							   (slot-value b ',slot-name))))
				      (if is-nullable
					  `(if (and (not (equal (slot-value a ',slot-name) :null))
						    (not (equal (slot-value b ',slot-name) :null)))
					       ,base
					       (funcall 'equal
							(slot-value a ',slot-name)
							(slot-value b ',slot-name)))
					  base)))
				  slots))
	     (eq-name (intern (string-upcase (concatenate 'string (symbol-name class-name) "=")))))
	`(progn
	   (defun ,eq-name (a b)
	     (and ,@check-pairs))
	   (export ',eq-name))))))
