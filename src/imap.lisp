(in-package :cl-user)
(defpackage postmaster.imap
  (:use :cl :postmaster.email)
  (:export :<imap-server>
           :host
           :port
           :ssl
           :<imap-account>
           :server
           :username
           :password
           :<imap-session>
           :connect
           :disconnect))
(in-package :postmaster.imap)

(defclass <imap-server> ()
  ((host :reader host :initarg :host :type string)
   (port :reader port :initarg :port :type integer)
   (ssl :reader ssl :initarg :ssl :type boolean :initform t)))

(defclass <imap-account> ()
  ((server :reader server :initarg :server :type <imap-server>)
   (username :reader username :initarg :username :type string)
   (password :reader password :initarg :password :type string)))

(defclass <imap-session> ()
  ((folder :accessor folder :initarg :folder)))

(defmethod connect ((profile <imap-account>))
  (let* ((server (server profile))
         (folder (funcall
                  (if (ssl server)
                      #'mel:make-imaps-folder
                      #'mel:make-imap-folder)
                  :host (host server)
                  :username (username profile)
                  :password (password profile))))
    (mel.folders.imap::make-imaps-connection folder)
    (make-instance '<imap-session>
                   :folder folder)))

(defmethod disconnect ((session <imap-session>))
  (mel.folders.imap::close-folder (folder session)))
