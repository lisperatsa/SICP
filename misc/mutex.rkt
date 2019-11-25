#lang racket

(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-p . args)
        (mutex 'acquire)
        (let ((val (apply p args)))
          (mutex 'release)
          val))
      serialized-p)))

(define (make-mutex)
  (let ((available true))
    (define (lock! available)
      (set! available false) available)
    (define (release! available)
      (set! available true) available)
    ; (: mutex (-> (U 'acquire 'release) Boolean))
    (define (mutex m)
      (cond [(eq? m 'acquire) (if available (lock! available) (mutex 'acquire))]
            [(eq? m 'release) (release! available)]
            [else (error "Unknown operand for MUTEX: " m)]))
    mutex))

