#lang racket

(require "./lazy.rkt")

(provide (all-defined-out))

(define the-empty-stream null)

(define stream-null? null?)


(define-syntax (cons-stream stx)
  (syntax-case stx ()
              ((_ a b) #'(cons a (delay b)))))

(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))

(define (stream-foldl proc initial stream) 
  (if (stream-null? stream)
    initial
    (stream-foldl proc (proc initial (stream-car stream))
                  (stream-cdr stream))))

(define (stream-foldr proc initial stream)
  (if (stream-null? stream)
    initial
    (proc (stream-car stream) (stream-foldr proc initial 
                                           (stream-cdr stream)))))

(define (stream-map proc . argstreams)
  (if (ormap stream-null? argstreams)
    the-empty-stream
    (cons-stream
      (apply proc (map stream-car argstreams))
      (apply stream-map 
             (cons proc (map stream-cdr argstreams))))))

(define (stream-ref s n)
  (if (zero? n)
    (stream-car s)
    (stream-ref (stream-cdr s) (sub1 n))))

(define (stream-for-each proc s)
  (if (stream-null? s)
    'done
    (begin (proc (stream-car s))
           (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each displayln s))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter
                        pred
                        (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(define (stream-enumerate-interval low high)
  (if (> low high)
    the-empty-stream
    (cons-stream low (stream-enumerate-interval (add1 low) high))))

(define (stream-take nat infinite-stream)
  (if (zero? nat) null
    (cons (stream-car infinite-stream) (stream-take (sub1 nat)
                                                    (stream-cdr infinite-stream)))))

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (add1 n))))

