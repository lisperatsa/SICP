#lang racket

(require "utils.rkt")
(provide (all-defined-out))

#| See if given quoted expr is 'begin. |#
(define (begin? expr) (tagged-list? expr 'begin))

#| Extract action exprs from `(begin ,expr1 ...) |#
(define (begin-actions expr) (cdr expr))

#| See if we're looking at a last expr in begin-expr. |#
(define (last-expr? actions) (null? (cdr actions)))

#| name imples |#
(define (first-expr seq) (car seq))

#| RESP.|#
(define (rest-exprs seq) (cdr seq))

; given a sequence of exprs, append 'begin onto the top
(define (make-begin seq) (cons 'begin seq))
 
; convert sequence of expressions into begin form.
(define (sequence->expr seq)
  (cond ((null? seq) seq)
        ((last-expr? seq) (first-expr seq))
        (else (make-begin seq))))


