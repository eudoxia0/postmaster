(in-package :cl-user)
(defpackage postmaster.servers
  (:use :cl :trivial-types)
  (:export :<smtp-server>
           :<imap-server>
           :host
           :port
           :ssl
           :auth-method))
(in-package :postmaster.servers)

(defclass <server> ()
  ((host :reader host :initarg :host :type string)
   (port :reader port :initarg :port :type integer)))

;;; SMTP

(defclass <smtp-server> (<server>)
  ((ssl :reader ssl :initarg :ssl :type (or null keyword)
        :initform :starttls)
   (auth-method :reader auth-method :initarg :auth-method
                :type (or null keyword))))

(defmethod initialize-instance :after ((server <smtp-server>) &key)
  "If the port has not been specified, set it according to the SSL preferences."
  (unless (slot-boundp server 'port)
    (setf (slot-value server 'port)
          (case (ssl server)
            (:tls 465)
            (:starttls 587)
            (nil 25)
            (t
             (error "Unknown SSL preference ~A." (ssl server)))))))

;;; IMAP

(defclass <imap-server> (<server>)
  ((ssl :reader ssl :initarg :ssl :type boolean :initform t)))

(defmethod initialize-instance :after ((server <imap-server>) &key)
  (unless (slot-boundp server 'port)
    (setf (slot-value server 'port)
          (if (ssl server)
              993
              143))))
