(in-package :cl-user)
(defpackage postmaster.email
  (:use :cl :trivial-types)
  (:export :<email>
           :from
           :to
           :subject
           :body
           :html-body))
(in-package :postmaster.email)

(defclass <attachment> ()
  ((name :reader name :initarg :name :type string)
   (path :reader path :initarg :path :type pathname)
   (mime-type :reader mime-type :initarg :mime-type :type string)))

(defclass <email> ()
  ((from :reader from :initarg :from :type string)
   (to :reader to :initarg :to :type (or string (list-of string)))
   (subject :reader subject :initarg :subject :type string)
   (body :reader body :initarg :body :type string)
   (html-body :reader html-body :initarg :html-body :type string)
   (attachments :reader attachments :initarg :attachments
                :type (list-of <attachment>))))
