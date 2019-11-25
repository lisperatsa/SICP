#lang racket

(require "utils.rkt")
;(require "types.rkt")
(provide (all-defined-out))

; given expr is variable?, meaning a symbol?
; (: variable? (-> Expr Boolean))
(define (variable? expr) (symbol? expr))

; expecting form ''expr <=> '(quote expr).
; (: quoted? (-> Expr boolean))
(define (quoted? expr) (tagged-list? expr 'quote))
; (: text-of-quotation (-> Expr Expr))
(define (text-of-quotation expr) (cadr expr))

