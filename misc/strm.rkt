#lang racket

(require "stream.rkt")

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (add1 n))))

(define integers (integers-starting-from 1))

(define (divisible? x y) (= (remainder x y) 0))

(define no-sevens
  (stream-filter (lambda (x) (not (divisible? x 7)))
                 integers))

(define (fibgen a b) (cons-stream a (fibgen b (+ a b))))
(define fibs (fibgen 0 1))

(define (scale-stream stream n)
  (stream-map (lambda (x) (* x n)) stream))

(define double (cons-stream 1 (scale-stream double 2)))

(define (sieve integer-stream)
  (cons-stream 
    (stream-car integer-stream)
    (stream-filter 
      (lambda (x) 
        (divisible? x (stream-car integer-stream)))
      (stream-cdr integer-stream))))

(define (stream-prime? n)
  (define divisible? (lambda (x y) (zero? (remainder x y))))
  (define (iter ps)
    (cond ((> (sqr (stream-car ps)) n) true)
          ((divisible? n (stream-car ps)) false)
          (else (iter (stream-cdr ps)))))
  (iter (sieve (integers-starting-from 2))))

(define (add-streams s1 s2) (stream-map + s1 s2))
(define (mul-streams s1 s2) (stream-map * s1 s2))

(define fibs/add-streams (cons-stream 0
                                      (cons-stream 1 
                                                   (add-streams (stream-cdr fibs/add-streams)
                                                                fibs/add-streams))))

(define (stream-append s1 s2)
  (if (stream-null? s1)
    s2
    (cons-stream (stream-car s1)
                 (stream-append (stream-cdr s1) s2))))

(define (expand num den radix)
  (cons-stream
    (quotient (* num radix) den)
    (expand (remainder (* num radix) den) den radix)))

(define (sum-n n stream)
  (if (zero? n) 0
    (+ (stream-car stream) 
       (sum-n (sub1 n) (stream-cdr stream)))))

(define (partial-sums s)
  (define (iter n s)
    (cons-stream (sum-n n s) (iter (add1 n) s))) 
  (iter 0 s))

