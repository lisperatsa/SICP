#lang racket

(define (filter-map pred lst)
  (define (iter lst [acc null])
    (if (null? lst) (reverse acc)
      (let ((elm (car lst)))
        (if (pred elm)
          (iter (cdr lst) (cons elm acc))
          (iter (cdr lst) acc)))))
  (iter lst))

