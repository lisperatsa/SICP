#lang racket

(require "./utils.rkt")
(require "./lambda.rkt")
(require "./env.rkt")
(provide (all-defined-out))

#|Helper functions for evaluating definition-exprs whose form is either 
 `(define (,var ,parm1 ...) ,body) or `(define ,var ,expr). The former 
 is just a syntax sugar for `(define ,var (lambda (,parm1 ...) ,body))
|#

;(define-type Expr (Listof Any))
; See if given expr is 'define tagged-list
; (: definition? (-> Expr Boolean))
(define (definition? expr) (tagged-list? expr 'define))

; Choose variales from a given definition-expr.
; Beware of the two distinct forms of define-expr,
; (: definition-value (-> Expr Expr))
(define (definition-variable expr)
  (if (symbol? (cadr expr)) ;type `(define ,var ,expr) ?
    (cadr expr) ; extract var of `(define ,var ,expr)
    (caadr expr))) ;extract avrs from `(define ,(var param1 ...) ,body)

; Choose parameters from a given define-expr
; (: definition-value (-> Expr Expr))
(define (definition-value expr)
  (if (symbol? (cadr expr)) ; type `(define ,var ,expr)
    (caddr expr)
    (make-lambda (cdadr expr) (caddr expr))))

