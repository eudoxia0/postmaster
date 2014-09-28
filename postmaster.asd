(in-package :cl-user)
(defpackage postmaster-asd
  (:use :cl :asdf))
(in-package :postmaster-asd)

(defsystem postmaster
  :version "0.1"
  :author "Fernando Borretti"
  :license "MIT"
  :depends-on (:mel-base
               :cl-smtp
               :trivial-types
               :trivial-mimes)
  :components ((:module "src"
                :serial t
                :components
                ((:file "email")
                 (:file "servers")
                 (:file "services")
                 (:file "smtp")
                 (:file "imap"))))
  :description "Email for humans."
  :long-description
  #.(uiop:read-file-string
     (uiop:subpathname *load-pathname* "README.md"))
  :in-order-to ((test-op (test-op postmaster-test))))
