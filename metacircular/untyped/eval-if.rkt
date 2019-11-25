#lang racket

(require "utils.rkt")
(require )
(provide (all-defined-out))

#| Procedure definitions for evaluating if expression. Since if-expr is a special form,
 we need to be aware of the evaluation order of the given quoted if expression. |#

#| This procedure checks if a given quoted expression is tagged if. Using tagged-list 
 from utils.rkt.
|#
(define (if? expr) (tagged-list? expr 'if))

#| Extract predicate part of given quoted if-expr. |#
(define (if-predicate quoted-expr) (cadr quoted-expr))

#| Extract consequent part of given quoted if-expr. |#
(define (if-consequent quoted-expr) (caddr quoted-expr))

#| Extract alternative clause of given quoted if-expr. Else clause
 must be provided. If not then return error. |#
(define (if-alternative quoted-expr)
  (if (not (null? (cdddr quoted-expr)))
    (cadddr quoted-expr)
    (error "ELSE clause must be given to if -- " quoted-expr)))

#| Construct a 'if tagged-expression using given predicate, 
consequent, and alternative exprs. |#
(define (make-if predicate consequence alternative)
  `(if ,predicate ,consequence ,alternative))

