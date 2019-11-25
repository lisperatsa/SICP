#lang racket


(define-syntax (our-and stx)
  (syntax-case stx ()
    [(_) #'true]
    [(_ term) #'term]
    [(_ t1 t2 ...) #'(if t1 (our-and t2 ...) false)]))

(define-syntax (our-or stx)
  (syntax-case stx ()
    ((_) #'false)
    ((_ term) #'term)
    ((_ t1 t2 ...) #'(if t1 t1 (our-or t2 ...)))))
