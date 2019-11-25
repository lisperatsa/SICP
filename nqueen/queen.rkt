#lang racket

(define (pos x y) (list x y))

(define (pos-row p) (car p))
(define (pos-column p) (cadr p))

(define (diagonal? p pivot)

(define (n-queen n)
  (for/fold ([pattern empty-queens-pattern])
    ([r (in-range n)])
    (for*/list ([queens pattern])
                [c (in-range n)]
                #:when (safe? (pos r c) queens))
    (cons (pos r c) queens)))
