#lang racket

(provide (except-out memo-proc))

(define (memo-proc proc)
  (let ((executed? false) (result false))
    (lambda ()
      (if (not executed?)
        (begin (set! result (proc))
               (set! executed? true)
               result)
        result))))

(define (force delayed-object) (delayed-object))

(define-syntax (delay stx)
  (syntax-case stx ()
    ((_ expr) #'(memo-proc (lambda () expr)))))

