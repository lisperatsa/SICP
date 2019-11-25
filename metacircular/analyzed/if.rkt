#lang typed/racket

(require "./types.rkt")
(require "./utils.rkt")
(provide (all-defined-out))

(: if? (-> Expr Boolean))
(define (if? expr)
  (and (list? expr) (tagged-list? expr 'if)))

(: if-predicate : (-> Expr Expr))
(define (if-predicate expr)
  (if (list? expr) (cadr expr) 
    (error "invalid expr given")))

(: if-consequent : (-> Expr Expr))
(define (if-consequent expr)
  (if (list? expr) (caddr expr)
    (error "invalid expr given")))

(: if-alternative : (-> Expr Expr))
(define (if-alternative expr)
  (if (list? expr) (cadddr expr)
    (error "invalid expr given")))

