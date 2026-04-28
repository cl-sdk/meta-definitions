(in-package :cl-user)

(asdf:defsystem #:meta-definitions.derive.equality
  :license "Unlicense"
  :author "Bruno Dias"
  :serial t
  :depends-on (#:meta-definitions)
  :components ((:file "derive/equality")))
