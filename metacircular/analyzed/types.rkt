#lang typed/racket
(provide (all-defined-out))

(define-type Value Any)
(define-type Variable Symbol)
(define-type Frame (Pairof Variable Value))
(define-type Environment (Listof Frame))
(define-type Expr (Rec Expr 
                       (U Symbol Number String Null 
                          (Pairof Expr Expr) (Listof Expr))))
(define-type EvalThunk (-> Environment Expr))
