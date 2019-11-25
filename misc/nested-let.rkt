#lang racket

(define-syntax (let*->nested-lets/syntax stx)
  (syntax-case stx ()
    [(_ (let* ([var val]) body))
     #'(let ([var val]) body)]
    [(_ (let* ([var1 val1] [var2 val2] ...) body))
     #'(let ([var1 val1])
         (let*->nested-lets (let* ([var2 val2] ...) body)))]))

