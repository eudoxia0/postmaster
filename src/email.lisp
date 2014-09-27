(in-package :cl-user)
(defpackage postmaster.email
  (:use :cl :trivial-types)
  (:export :<attachment>
           :path
           :name
           :mime-type
           :attach
           :convert-attachment-list
           :<email>
           :from
           :to
           :subject
           :body
           :html-body
           :attachments))
(in-package :postmaster.email)

(defclass <attachment> ()
  ((path :reader path :initarg :path :type pathname)
   (name :reader name :initarg :name :type string)
   (mime-type :reader mime-type :initarg :mime-type :type string)))

(defun attach (&key path (name (pathname-file path))
                 (mime-type (mimes:mime path)))
  (make-instance '<attachment>
                 :path path
                 :name name
                 :mime-type mime-type))

(defmethod convert-attachment ((attachment <attachment>))
  "Convert a Postmaster attachment to the corresponding CL-SMTP class."
  (cl-smtp:make-attachment (path attachment)
                           (name attachment)
                           (mime-type attachment)))

(defun convert-attachment-list (list)
  (mapcar #'(lambda (attach)
              (convert-attachment attach))
          list))

(defclass <email> ()
  ((from :reader from :initarg :from :type string)
   (to :reader to :initarg :to :type (or string (list-of string)))
   (subject :reader subject :initarg :subject :type string)
   (body :reader body :initarg :body :type string)
   (html-body :reader html-body :initarg :html-body :type string)
   (attachments :reader attachments :initarg :attachments
                :type (list-of <attachment>))))
