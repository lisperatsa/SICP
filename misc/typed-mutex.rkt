#lang typed/racket

(: make-mutex (-> (-> (U 'aquire 'release) Boolean)))
(define (make-mutex)
  (: lock! (-> Boolean Boolean))
  (define (lock! flag)
    (if flag (begin (set! flag false) false) false))
  (: release! (-> Boolean Boolean))
  (define (release! available)
    (if available true (set! available true))
    available)
  (let ((available : Boolean true))
    (: mutex (-> (U 'aquire 'release) Boolean))
    (define (mutex m)
      (cond [(eq? m 'aquire) (if available (lock! available) (mutex 'aquire))]
            [(eq? m 'release) (release! available)]
            [else (error "Unknown operand for MUTEX: " m)]))
    mutex))

;わからんぬ
(: make-serializer (All (c a b ...) (-> (-> a b ... b c))))
(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-proc . args)
        (mutex 'aquire)
        (let ((val (apply p args)))
          (mutex 'release)
          val))
      (serialized-proc))))

