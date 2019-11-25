#lang racket

;(require "./types.rkt")
;(provide (all-defined-out))


;(: meta-eval : (-> Any Environment AnyValues))
(define (meta-eval expr env) ((analyze expr) env))

(require "./if.rkt")
; (: analyze-if : (-> Expr EvalThunk))
(define (analyze-if expr)
  (let ((pproc (analyze (if-predicate expr)))
        (cproc (analyze (if-consequent expr)))
        (aproc (analyze (if-alternative expr))))
    (lambda (env) (if (pproc env)
                    (cproc env) (aproc env)))))

;(: analyze : (-> Any (-> Environment AnlyValues)))
(define (analyze expr) (lambda (env) (eval expr)))
#;(define (analyze expr) 
  (cond [(self-evaluating? expr) (analyze-self-evaluating expr)]
        [(quoted? expr) (analyze-quoted expr)]
        [(variable? expr) (analyze-variable expr)]
        [(assignment? expr) (analyze-assignment expr)]
        [(definition? expr) (analyze-definition expr)]
        [(if? expr) (analyze-if expr)]
        [(lambda? expr) (analyze-lambda expr)]
        [(cond? expr) (analyze-cond expr)]
        [(begin? expr) (analyze-begin expr)]
        [(application? expr) (analyze-expr expr)]
        [else (error "Unknown expr ANALYZE: " expr)]))

