(in-package :cl-user)
(defpackage postmaster.services
  (:use :cl :trivial-types :anaphora)
  (:import-from :postmaster.servers
                :<smtp-server>
                :<imap-server>)
  (:export :<service>
           :name
           :domains
           :smtp-server
           :imap-server
           :<account>
           :service
           :username
           :password
           :find-service-by-name
           :find-service-by-domain))
(in-package :postmaster.services)

;;; Services

(defclass <service> ()
  ((name :reader name :initarg :name :type string)
   (domains :reader domains :initarg :domains :type (list-of string))
   (smtp-server :reader smtp-server :initarg :smtp-server :type <smtp-server>)
   (imap-server :reader imap-server :initarg :imap-server :type <imap-server>)))

;;; Accounts

(defclass <account> ()
  ((service :reader service :initarg :service :type string)
   (username :reader username :initarg :username :type string)
   (password :reader password :initarg :password :type string)))

;;; Well-known services

(defparameter +well-known-services+
  (let ((table (make-hash-table)))
    (setf (gethash :gmail table)
          (make-instance '<service>
                         :name "GMail"
                         :domains (list "gmail.com" "googlemail.com")
                         :smtp-server (make-instance '<smtp-server>
                                                     :host "smtp.gmail.com"
                                                     :ssl :tls)
                         :imap-server (make-instance '<imap-server>
                                                     :host "imap.gmail.com")))
    table))

(defun find-service-by-name (name)
  "Find a service by name (A keyword)."
  (multiple-value-bind (val foundp) (gethash name +well-known-services+)
    ;; We do this so the output doesn't leak the fact that the service DB is a
    ;; hash table
    val))

(defun find-service-by-domain (domain)
  "Find a service by its domain name. Case insensitive."
  (loop for name being the hash-keys of +well-known-services+ do
    (let ((service (find-service-by-name name)))
      (if (member domain (domains service) :test #'equalp)
          (return-from find-service-by-domain service)))))
