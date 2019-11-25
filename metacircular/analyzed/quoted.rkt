#lang racket
;#lang typed/racket
;(require "./types.rkt")

; (: text-of-quotation : (-> Expr Expr))
#| Extract quoted expr from given expr. As it is 
   doubly quoted like ''(a b c), all you need is to 
   cadr the argument. |#
(define (text-of-quotation expr)
  (if (list? expr) (cadr expr)
    (error "Invalid form given to text-of-quotation: " expr)))

;(: analyze-quoted : (-> Expr EvalThunk))
#| Analyze quoted expression and returns it in a EvalThunk. 
   text-of-quotation does the work. |#
(define (analyze-quoted expr)
  (let ((qval (text-of-quotation expr)))
    (lambda (env) qval)))
