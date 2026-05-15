#!/usr/bin/env -S sbcl --script

;;;
;; --- game-of-life.lisp ---
;;
;; John Conway's: Game of Life, printed directly to the terminal.
;;
;; Copyright (C) 2021-2026 Robert Coffey
;; Released under the MIT license.
;;;

(defparameter *grid-width* 40)   ; Cell grid width in characters
(defparameter *grid-height* 24)  ; Cell grid height in characters

(defparameter *sleep-time* (/ 1 10))  ; Number of seconds to sleep between updates

(defparameter *initial-grid*
  '("0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"
    "0000000000000000000000000000000000000000"))

;; Create an array of cells
(defun create-cells ()
  (make-array (list *grid-height* *grid-width*)
              :initial-element 0))

;; Create and setup an array of cells with values from initial-grid
(defun init-cells (initial-grid)
  (let ((cells (create-cells)))
    (loop for y from 0 below *grid-height* do
      (loop for x from 0 below *grid-width* do
        (setf (aref cells y x)
              (digit-char-p (aref (nth y initial-grid) x)))))
    cells))

;; Print an array of cells
(defun draw-cells (cells)
  (terpri)
  (loop for y from 0 below *grid-height* do
    (loop for x from 0 below *grid-width* do
      (if (= (aref cells y x) 1)
          (princ "O")
          (princ ".")))
    (fresh-line)))

;; Create a copy of an array of cells
(defun copy-cells (cells)
  (let ((copy (create-cells)))
    (loop for y from 0 below *grid-height* do
      (loop for x from 0 below *grid-width* do
        (setf (aref copy y x)
              (aref cells y x))))
    copy))

;; Get the number of living neighbors of a given cell
(defun get-neighbor-count (cells y x)
  (let ((count 0))
    ;; Row of cells above
    (when (> y 0)
      (progn
        (setf count (+ count (aref cells (1- y) x)))
        (when (> x 0)
          (setf count (+ count (aref cells (1- y) (1- x)))))
        (when (< x (1- *grid-width*))
          (setf count (+ count (aref cells (1- y) (1+ x)))))))
    ;; Row of cells below
    (when (< y (1- *grid-height*))
      (progn
        (setf count (+ count (aref cells (1+ y) x)))
        (when (> x 0)
          (setf count (+ count (aref cells (1+ y) (1- x)))))
        (when (< x (1- *grid-width*))
          (setf count (+ count (aref cells (1+ y) (1+ x)))))))
    ;; Cell to the left
    (when (> x 0)
      (setf count (+ count (aref cells y (1- x)))))
    ;; Cell to the right
    (when (< x (1- *grid-width*))
      (setf count (+ count (aref cells y (1+ x)))))
    count))

;; Should a given cell live
(defun should-live (cells y x)
  (let ((is-alive (aref cells y x))
        (neighbor-count (get-neighbor-count cells y x)))
    (if (= is-alive 1)
        (cond ((< neighbor-count 2) 0)
              ((> neighbor-count 3) 0)
              (t 1))
        (cond ((= neighbor-count 3) 1)
              (t 0)))))

;; Update an array of cells
(defun update-cells (cells)
  (let ((snapshot (copy-cells cells)))
    (loop for y from 0 below *grid-height* do
      (loop for x from 0 below *grid-width* do
        (setf (aref cells y x)
              (should-live snapshot y x))))
    cells))

(defun main ()
  (let ((cells (init-cells *initial-grid*)))
    (loop while T do
      (draw-cells cells)
      (setf cells (update-cells cells))
      (sleep *sleep-time*))))
(main)
