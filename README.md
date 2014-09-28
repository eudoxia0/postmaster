# Postmaster - Email for humans

Postmaster is a simple, easy to use SMTP/IMAP library with an API inspired by
[NodeMailer][nm].

[nm]: http://www.nodemailer.com/

# Usage

## Services

~~~lisp
(in-package :postmaster.services)

;; You can find services by name
(find-service-by-name "gmail")

;; ... Or by domain name
(find-service-by-domain "gmail.com")

;; Failing that, you can define your own
(defparameter *s*
  (make-instance '<service>
                 :name "GMail"
                 :domains (list "gmail.com" "googlemail.com")
                 :smtp-server (make-instance '<smtp-server>
                                             :host "smtp.gmail.com"
                                             :ssl :tls)))
~~~

Class defaults (SSL, ports) are safe and sane.

# License

Copyright (c) 2014 Fernando Borretti (eudoxiahp@gmail.com)

Licensed under the MIT License.
