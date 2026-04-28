(in-package :cl-user)

(asdf:defsystem #:meta-definitions.derives
  :license "Unlicense"
  :author "Bruno Dias"
  :serial t
  :depends-on (#:meta-definitions #:uiop)
  :components ((:file "derive/readers")
               (:file "derive/print-object")
               (:file "derive/equality")))
