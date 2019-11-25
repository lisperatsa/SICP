#lang rakcet

(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-p . args)
        (mutex 'aquire)
        (let ((val (apply p args)))
          (mutex 'release)
          val))
      serialized-p)))

(define (the-mutex)
  (let ((available true))
    (define (inquire m)
      (cond [(eq? m 'aquire) 
             (if available (lock! available) (inquire 'aquire))]
            [(eq? m 'release) 
             (release! available)]
            [else (error "Unknown operation for INQUIRE: " m)]))
    (define (lock! flag)
      (if flag (begin (set! available false) false) false))
    (define (release! flag) (set! flag true) true)
    inquire))

