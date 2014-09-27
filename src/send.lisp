(in-package :cl-user)
(defpackage postmaster.send
  (:use :cl :trivial-types)
  (:export :<smtp-server>
           :host
           :port
           :ssl
           :define-smtp-server))
(in-package :postmaster.send)

;;; SMTP configuration

(defclass <smtp-server> ()
  ((host :reader host :initarg :host :type string)
   (port :reader port :initarg :port :type integer)
   (ssl :reader ssl :initarg :ssl :type (or null keyword)
        :initform :starttls)))

(defun define-smtp-server (&key host port ssl)
  (make-instance
   '<smtp-server>
   :host host
   :ssl ssl
   :port (if port
             port
             ;; If the port has not been specified, set it according to the SSL
             ;; preferences.
             (case (ssl server)
               (:tls 465)
               (:starttls 587)
               (nil 25)
               (t
                (error "Unknown SSL preference ~A." (ssl server)))))))

;;; Email sender class

(defclass <email-sender> ()
  ((server :reader server :initarg :server :type <smtp-server>)
   (auth-method :reader auth-method :initarg :auth-method :type (or null keyword))
   (username :reader username :initarg :username :type string)
   (password :reader password :initarg :password :type string)))
