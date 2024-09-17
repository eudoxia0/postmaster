(in-package :cl-user)
(defpackage postmaster.smtp
  (:use :cl :postmaster.email :postmaster.servers)
  (:import-from :postmaster.services
                :<account>
                :username
                :password
                :service
                :smtp-server)
  (:export :send))
(in-package :postmaster.smtp)

(defmethod send ((account <account>) (email <email>) &rest rest &key &allow-other-keys)
  (let ((server (smtp-server (service account))))
    (apply #'cl-smtp:send-email (host server)
           (from email)
           (to email)
           (subject email)
           (when (slot-boundp email 'body)
             (body email))
           :ssl (ssl server)
           :port (port server)
           :html-message
           (when (slot-boundp email 'html-body)
             (html-body email))
           :authentication (if (and (slot-boundp server 'auth-method)
                                    (auth-method server))
                               (list (auth-method server)
                                     (username account)
                                     (password account))
                               (list (username account)
                                     (password account)))
           :attachments (attachments email)
           rest)))
