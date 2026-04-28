(in-package :cl-user)

(asdf:defsystem #:meta-definitions.derive.print-object
  :license "Unlicense"
  :author "Bruno Dias"
  :serial t
  :depends-on (#:meta-definitions)
  :components ((:file "derive/print-object")))
