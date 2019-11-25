#lang racket

; (: analyze-quoted : (-> Expr Expr))
(define (analyze-quoted expr)
  (define (text-of-quotation expr)
    (cadr expr))
  (let ((qval (text-of-quotation expr)))
    (lambda (env) qval)))

