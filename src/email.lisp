(in-package :cl-user)
(defpackage postmaster.email
  (:use :cl :trivial-types)
  (:export :<attachment>
           :path
           :name
           :mime-type
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

(defmethod initialize-instance :after ((attachment <attachment>) &key)
  (unless (slot-boundp attachment 'name)
    (setf (slot-value attachment 'name)
          (pathname-name (path attachment))))
  (unless (slot-boundp attachment 'mime-type)
    (setf (slot-value attachment 'mime-type)
          (mimes:mime (path attachment)))))

(defun convert-attachment-list (list)
  "Convert a list of Postmaster attachments to the corresponding CL-SMTP class."
  (mapcar #'(lambda (attachment)
              (cl-smtp:make-attachment (path attachment)
                                       :name (name attachment)
                                       :mime-type (mime-type attachment)))
          list))

(defclass <email> ()
  ((from :reader from :initarg :from :type string)
   (to :reader to :initarg :to :type (or string (list-of string)))
   (subject :reader subject :initarg :subject :type string)
   (body :reader body :initarg :body :type string)
   (html-body :reader html-body :initarg :html-body :type string)
   (attachments :reader attachments :initarg :attachments
                :type (list-of <attachment>))))
