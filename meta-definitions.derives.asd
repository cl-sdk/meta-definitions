(in-package :cl-user)

(asdf:defsystem #:meta-definitions.derives
  :license "Unlicense"
  :author "Bruno Dias"
  :depends-on (#:meta-definitions.derive.readers
               #:meta-definitions.derive.print-object
               #:meta-definitions.derive.equality))
