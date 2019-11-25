#lang racket

(require "utils.rkt")

(provide (all-defined-out))
#|Connectives are either and or or, both have a form
 (and ,arg1 ...) or (or ,arg1 ...). |#

; select args from a connective-expr.
(define (connective-args expr) (cdr expr))

; select first arg from a connective-expr
(define (connective-rest-args expr) (cdr expr))
;select rest args from a connective-expr
(define (connective-first-arg expr) (car expr))

;given expr and-expr?
(define (and-expr? expr) (tagged-list? expr 'and))
;given expr or-expr?
(define (or-expr? expr) (tagged-list? expr 'or))

; see if given connective-expr has no args.
(define (connective-no-args? args) (null? args))

; see if given connective-expr has only one arg.
(define (connective-one-arg? args) 
  (and (not (null? args)) (null? (cdr args))))

