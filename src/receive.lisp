(in-package :cl-user)
(defpackage postmaster.receive
  (:use :cl :postmaster.email))
(in-package :postmaster.receive)

(defclass <imap-server> ()
  ((host :reader host :initarg :host :type string)
   (port :reader port :initarg :port :type integer)
   (ssl :reader ssl :initarg :ssl :type boolean :initform t)))

(defclass <email-receiver> ()
  ((server :reader server :initarg :server :type <imap-server>)
   (username :reader username :initarg :username :type string)
   (password :reader password :initarg :password :type string)))

(defclass <imap-session> ()
  ((mailbox :accessor mailbox :initarg :mailbox)))

(defmethod connect ((profile <email-receiver>))
  (let* ((server (server profile))
         (box (funcall
               (if (ssl server)
                        #'mel:make-imaps-folder
                        #'mel:make-imap-folder)
               :host (host server)
               :username (username profile)
               :password (password profile))))
    (make-instance '<imap-session>
                   :mailbox box)))
