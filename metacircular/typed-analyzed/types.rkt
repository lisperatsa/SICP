#lang typed/racket

(provide (all-defined-out))

#| Common type definitions for all the files. |#
; S-Expr definition
(define-type Expr 
    (U Null Number Symbol String (Pair Expr Expr) (Listof Expr)))

