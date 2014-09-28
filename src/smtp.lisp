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

(defmethod send ((account <account>) (email <email>))
  (let ((server (smtp-server (service account))))
    (cl-smtp:send-email (host server)
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
                        :authentication (if (and (slot-boundp account 'auth-method)
                                                 (auth-method account))
                                            (list (auth-method account)
                                                  (username account)
                                                  (password account))
                                            (list (username account)
                                                  (password account)))
                        :attachments (when (slot-boundp email 'attachments)
                                       (convert-attachment-list (attachments email))))))
