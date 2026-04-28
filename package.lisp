(defpackage #:meta-definitions
  (:use #:cl)
  (:export
   #:declarations
   #:define-class
   #:define-from
   #:define))

(in-package :meta-definitions)

(defvar declarations
  (make-hash-table :test 'equal))

(defvar default-class-slots
  '(;; value and doc
    :initarg :initform :documentation
    ;; visibility
    :writer :reader :accessor
    ;; type
    :type
    ;; allocation
    :allocation :location))

(defmacro define-class (class-name)
  (let ((spec (gethash (symbol-name class-name) declarations)))
    (labels ((make-slot (class-name slot)
	       (destructuring-bind (name &rest attrs)
		   slot
		 (let ((attributes (copy-list attrs)))
		   (when (member :required attributes)
		     (remf attributes :initform)
		     (setf attributes
			   (append attributes
				   `(:initform (error (concatenate
						       'string
						       ,(symbol-name class-name)
						       "."
						       ,(symbol-name name)
						       " must be defined"))))))
		   (loop
		     for (key value) on attributes by #'cddr
		     when (not (member key default-class-slots))
		       do (remf attributes key))
		   `(,name
		     :initarg ,(alexandria:make-keyword
				(string-upcase (symbol-name name)))
		     ,@attributes)))))
      (destructuring-bind (class-spec slot-spec)
	  spec
	(let ((slots (mapcar (lambda (slot)
			       (make-slot (car class-spec) slot))
			     (cdr slot-spec))))
	  `(progn
	     (defclass ,(caadr class-spec) ()
	       ,slots)
	     (closer-mop:ensure-finalized (find-class ',(caadr class-spec)))))))))

(defmacro define-from (class-name name selected-slots &optional extra-slots)
  (let ((spec (gethash (symbol-name class-name) declarations)))
    (destructuring-bind (class-spec slots-spec)
	spec
      (declare (ignore class-spec))
      (let ((slots (serapeum:~>
		    (cdr slots-spec)
		    (remove-if (lambda (slot)
				 (not (member (car slot) selected-slots)))
			       _))))
	`(progn
	   (define
	     (class ,(uiop:ensure-list name))
	     (slots ,@slots ,@extra-slots)))))))

(defmacro define (&body spec)
  `(progn
     (setf (gethash ,(symbol-name (caadar spec)) declarations) ',spec)
     t))
