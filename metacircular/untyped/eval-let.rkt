#lang racket

(require "./utils.rkt")
(provide (all-defined-out))

#| Let clause has a form `(let ((,var1 ,val1) ...) ,body), which is 
 a syntax suger for `((lambda ,(var1 ...) ,body) ,val1 ...).|#

; see if given expr is let-expr
(define (let? expr) (tagged-list? expr 'let))
; select body part of a let-expr
(define let-body cddr)
; select clauses of a let-expr
(define let-clauses cadr)
; select identifier of a var-val clause 
(define let-clause-identifier car)
; select value of a var-val clause
(define let-clause-value cadr)

; convert let-expr into a lambda-expr
(define (let->combination expr)
  (let ([body (let-body expr)]
        [clauses (let-clauses expr)])
    `((lambda ,(map let-clause-identifier clauses) ,@body)
      ,@(map let-clause-value clauses))))

