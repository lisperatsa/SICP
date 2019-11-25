#lang typed/racket

(require "./types.rkt")
(provide (all-defined-out))

(: tagged-list? : (-> Expr Symbol Boolean))
(define (tagged-list? expr tag)
  (and (list? expr) (eq? (car expr) tag)))

(: true? : (-> Any Boolean))
(define (true? x) (eq? x #t))
