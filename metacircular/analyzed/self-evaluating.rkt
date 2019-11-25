#lang racket

(provide (all-defined-out))

#| See if given expr is self-evaluating. |#
(define (self-evaluating? expr)
  (or (number? expr) (string? expr)))

#||#
;(: analyze-self-evaluating : (-> Expr EvalThunk))
(define (analyze-self-evaluating expr)
  (lambda (env) expr))
