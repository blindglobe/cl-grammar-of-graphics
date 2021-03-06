;; Mirko Vukovic
;; Time-stamp: <2011-10-03 21:00:10 gg-data.lisp>
;; 
;; Copyright 2011 Mirko Vukovic
;; Distributed under the terms of the GNU General Public License
;; 
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(in-package :cl-gg)

(defclass gg-data ()
  ((name :accessor name
	 :documentation "The name of the data, that can be used in the legend")
   (source :accessor source
	   :documentation "Data source
Possible data sources are
- file path
- a stream
- a lisp variable such as a list, vector, matrix
- gsll/antik's grid variable

Individual renderers may have restrictions on the source type")
   (unit :accessor unit))
  (:documentation "Store data information.  This is a base class, not
  to be used directly"))

(defmethod print-object ((self gg-data) stream)
  (print-unreadable-object (self stream :type t :identity t)))

(defmethod describe-object ((self gg-data) stream)
  (format stream "A grammar of graphics data object of type ~a
It's name is ~a
The data source is of type ~a
It's units, if any are ~a~%"
	  (class-name (class-of self))
	  (name self) (type-of (source self)) (unit self)))

(defclass column (gg-data)
  ((column-index :accessor column-index))
  (:documentation "Access column-index for columnar data"))

(defmethod describe-object :after  ((self gg-data) stream)
  (format stream "The data column is ~a" (column-index self)))

(defun make-column-data (source column-index &optional name unit)
  (let ((dat (make-instance 'column)))
    (setf (source dat) source
	  (column-index dat) column-index)
    (when name
      (setf (name dat) name))
    (when unit
      (setf (unit dat) unit))
    dat))

(defclass list-data (gg-data)
  ()
  (:documentation "Used to store specify a list of numbers

The data is stored in the `source' slot"))

(defun make-list-data (source &optional name unit)
  (let ((dat (make-instance 'list-data)))
    (setf (source dat) source)
    (when name
      (setf (name dat) name))
    (when unit
      (setf (unit dat) unit))
    dat))

(defclass matrix-data (column)
  ()
  (:documentation "Specializer for matrices.  It uses the `column'
  slot to specify the columns of interest"))

(defun make-matrix-data (source columns &optional name unit)
  (let ((dat (make-instance 'matrix-data)))
    (setf (source dat) source
	  (column-index dat) columns)
    (when name
      (setf (name dat) name))
    (when unit
      (setf (unit dat) unit))
    dat))