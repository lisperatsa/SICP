#lang typed/racket
(require "./types.rkt")
(require "./analyze.rkt")
(require "./env.rkt")
(provide (all-defined-out))

#| See if given expr is a set! operation. Intuitive.|#
(: assignment? : Expr -> Boolean)
(define (assignment? expr)
  (if (list? expr) (eq? (car expr) 'set!) false))

#| Accessors. Simple. assignment-variable picks up
   a variable from a set! expr such as '(set! x 12).
   To do that simple cadr the expr. Assignment-value
   caddr the given expr RESP. |#
(: assignment-variable : (-> (Listof Expr) Expr))
(define (assignment-variable expr) )

(: assignment-value : (-> Expr Expr))
