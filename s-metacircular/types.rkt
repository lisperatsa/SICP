#lang typed/racket

(define-type Pred (-> Any Boolean))
(define-type Expr (U (Listof Any) Any))
