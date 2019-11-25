#lang rakcet

(define (install-rectangular-package)
  (define (real-part z) (car z))
  (define (imag-part x) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (sqr (real-part z))
             (sqr (imag-part z)))))
