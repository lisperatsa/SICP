#lang typed/racket

(require "./analyze-env.rkt")
(require "./types.rkt")

(define-type EvalThunk (-> Environment Expr))

#| Analyze quoted exprs. First the inner function
   text-of-quotation is defined, whose work is to 
   extract the quoted part using annotated cadr.
   After that just make a EvalThunk lambda expr
   and return it.|#
(: analyze-quoted : (-> Expr EvalThunk))
(define (analyze-quoted expr)
  (: text-of-quotation : (-> Expr Expr))
  (define (text-of-quotation expr) 
    ((inst car Expr) expr))
  (let ((qval (text-of-quotation expr)))
    (lambda (env) qval)))

#| See if given expr is quoted. In order to do that
   just check if the car of given expr is symbol 
   'quote.|#
(: quoted? : (-> Expr Boolean))
(define (quoted? expr)
  (if (list? expr) (eq? (car expr) 'quote) #f))

#| See if given expr is self-evaluating expr, which
   in this case either number or string. |#
(: self-evaluating? : (-> Expr Boolean))
(define (self-evaluating? expr) 
  (or (number? expr) (string? expr)))

#| If given expr is self-evaluating, just wrap it in
   a EvalThunk type of lambda expr. |#
(: analyze-self-evaluating (-> Expr EvalThunk))
(define (analyze-self-evaluating expr)
  (lambda (env) expr))

#;(: meta-eval : (-> Expr Environment Expr))
#;(define (meta-eval expr env)
  ((analyze expr) env))

#| Analyze structure of any given expr. |#
(: analyze : (-> Expr EvalThunk))
(define (analyze expr)
  (cond [(self-evaluating? expr) (analyze-self-evaluating expr)]
        [(quoted? expr) (analyze-quoted expr)]
        [else (error "Unknown expression type -- ANALYZE" expr)]))

