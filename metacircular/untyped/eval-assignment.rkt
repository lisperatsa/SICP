#lang racket

(require "utils.rkt")
(provide (all-defined-out))

; See if given expr is assignment operation.
(define (assignment? expr)
  (tagged-list? expr 'set!))

#| Accessors. No explanation needed. |#
(define (assignment-variable expr) (cadr expr))
(define (assignment-value expr) (caddr expr))
