;;;; General Elementary Cellular Automata
;;
;;; Usage
;; Compile: csc elementary.scm
;; Execute: ./elementary RULE COUNT
;;
;;; Arguments
;; - RULE:  Number corresponding to rule
;; - COUNT: Number of iterations to run
;;
;;; Dependencies
;; - Chicken Scheme
;;
;;; Chicken Eggs
;; - vector-lib
;;
;;; License
;; Copyright (C) 2021-2026 Robert Coffey
;; Released under the MIT license.

(import (chicken process-context)
        vector-lib)

(define args (command-line-arguments))
(define rule-number (string->number (if (null? args) "90" (car args))))
(define iteration-count (string->number (if (null? args) "8" (cadr args))))

(define (integer->rule int)
  (define (aux int)
    (if (zero? int)
        '()
        (cons (not (zero? (modulo int 2)))
              (aux (inexact->exact (floor (/ int 2)))))))
  (let* ((rule (if (zero? int) '#(#f) (list->vector (aux int))))
         (len (vector-length rule)))
    (if (< len 8)
        (vector-append rule (make-vector (- 8 len) #f))
        rule)))

(define rule (integer->rule rule-number))

(define cell-count (+ (* 2 (+ 1 iteration-count)) 1))
(define cells-curr (make-vector cell-count #f))
(define cells-last (make-vector cell-count #f))
(vector-set! cells-curr (inexact->exact (floor (/ cell-count 2))) #t)

(define (draw-cells)
  (let loop ((i 1))
    (when (< i (- cell-count 1))
      (display (if (vector-ref cells-curr i) "*" " "))
      (loop (+ i 1))))
  (newline))

(define (copy-cells)
  (let loop ((i 1))
    (when (< i (- cell-count 1))
      (vector-set! cells-last i (vector-ref cells-curr i))
      (loop (+ i 1)))))

(define (cell-index->rule-index index)
  (define (aux int index)
    (+ (if (vector-ref cells-last index) 1 0) (* 2 int)))
  (aux (aux (aux 0 (- index 1)) index) (+ index 1)))

(define (update-cell index)
  (vector-set! cells-curr index
               (vector-ref rule (cell-index->rule-index index))))

(define (update-cells)
  (let loop ((i 1))
    (when (< i (- cell-count 1))
      (update-cell i)
      (loop (+ i 1)))))

(let loop ((i 0))
  (when (< i iteration-count)
    (draw-cells)
    (copy-cells)
    (update-cells)
    (loop (+ i 1))))
