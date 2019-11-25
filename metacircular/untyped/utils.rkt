#lang racket

(provide (all-defined-out))
#| Every expression given to the metacircular interpreter should be tagged in a 
 certain way(at its car part), or we regard the operator of the expr (car) as a kind of tag. procedure
 tagged-list? accepts a certain quoted expr and a tag(symbol) and see if the given
 expression is tagged properly. Returns false when given atomic value. |#
(define (tagged-list? expr tag)
  (if (pair? expr)
    (eq? (car expr) tag)
    false))

(define (true? x) (not (eq? x false)))
(define (false? x) (not (true? x)))

(define (self-evaluating? expr) 
  (or (number? expr) (string? expr)))


