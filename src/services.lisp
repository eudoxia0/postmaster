(in-package :cl-user)
(defpackage postmaster.services
  (:use :cl :trivial-types)
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
  (list
   (make-instance '<service>
                  :name "GMail"
                  :domains (list "gmail.com" "googlemail.com")
                  :smtp-server (make-instance '<smtp-server>
                                              :host "smtp.gmail.com"
                                              :ssl :tls)
                  :imap-server (make-instance '<imap-server>
                                              :host "imap.gmail.com"))))

(defun find-service-by-name (name)
  "Find a service by name (A case-insensitive string)."
  (loop for service in +well-known-services+ do
    (if (equalp name (name service))
        (return-from find-service-by-name service))))

(defun find-service-by-domain (domain)
  "Find a service by its domain name. Case insensitive."
  (loop for service in +well-known-services+ do
    (if (member domain (domains service) :test #'equalp)
        (return-from find-service-by-domain service))))
