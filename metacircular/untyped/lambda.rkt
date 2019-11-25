#lang racket

(require "utils.rkt")
(provide (all-defined-out))

#| See if the given quoted expr is tagged 'lambda. |#
(define (lambda? expr) (tagged-list? expr 'lambda))

#| Extract parameters from given lambda-expr. |#
(define (lambda-parameters expr) (cadr expr))

#| Extract procedure body of given lambda-expr. |#
(define (lambda-body expr) (cddr expr))

#| Construct lambda-expr using given parameters and body. |#
; (: make-lambda (-> (Listof Any) (Listof Any) (Listof (Listof Any))))
(define (make-lambda parameters body) 
  (cons 'lambda (list parameters body)))

