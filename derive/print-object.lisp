(defpackage #:meta-definitions.derive.print-object
  (:use #:cl)
  (:import-from #:meta-definitions #:declarations)
  (:export #:derive-print-object))

(in-package #:meta-definitions.derive.print-object)

(defmacro derive-print-object (class-name)
  "Defines a print-object method for the given class."
  (let ((spec (gethash (symbol-name class-name) declarations)))
    (destructuring-bind (class-spec slots-spec)
	spec
      (let* ((slots (mapcar #'car (cdr slots-spec))))
	`(defmethod print-object ((object ,class-name) stream)
	   (format stream "#<~A~%" ',(caadr class-spec))
	   (dolist (slot ',slots)
	     (format stream "  ~A: ~A~%" slot (slot-value object slot)))
	   (format stream ">"))))))
