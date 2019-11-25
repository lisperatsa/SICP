#lang racket

(require "./eval-procedure.rkt")
(provide (all-defined-out))

#|In order to applyb primitive procedures, we just call apply from underlying Lisp
 implementation. To achieve that we rename the underlying apply.|#
(define apply-in-underlying-scheme apply)

(define (apply-primitive-procedure primitive-proc args)
  (apply-in-underlying-scheme 
    (primitive-implementation primitive-proc) args))

