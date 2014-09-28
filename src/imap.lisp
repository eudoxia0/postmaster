(in-package :cl-user)
(defpackage postmaster.imap
  (:use :cl :postmaster.email :postmaster.servers)
  (:import-from :postmaster.services
                :<account>
                :service
                :username
                :password
                :imap-server)
  (:export :<imap-session>
           :connect
           :disconnect))
(in-package :postmaster.imap)

(defclass <imap-session> ()
  ((folder :accessor folder :initarg :folder)))

(defmethod connect ((account <account>))
  (let* ((server (imap-server (service account)))
         (folder (funcall
                  (if (ssl server)
                      #'mel:make-imaps-folder
                      #'mel:make-imap-folder)
                  :host (host server)
                  :username (username account)
                  :password (password account))))
    (mel.folders.imap::make-imaps-connection folder)
    (make-instance '<imap-session>
                   :folder folder)))

(defmethod disconnect ((session <imap-session>))
  (mel.folders.imap::close-folder (folder session)))
