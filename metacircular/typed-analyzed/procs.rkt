#lang racket

(require "./utils.rkt")
(provide (except-out (all-defined-out) meta-eval))

(define (meta-eval expr env) (eval expr))
;(define-type Element Any)
;(define-type ProcedureExpr (Listof Any))
;(define-type ProcedureOps (Listof Any))

; Any quoted list should be firstly considered an expression
; to be evaluated. 
;(: application? (-> (Listof Any) Boolean))
(define (application? expr) (list? expr))

; Selector; choosing an operator from a procedure-expr.
; e.g (operator '(cons 1 (cons 2 null))) -> 'cons
;(: operator (-> ProcedureExpr Symbol))
(define (operator expr) (car expr))

;(: operands (-> ProcedureExpr ProcedureOps))
(define (operands expr) (cdr expr))

;(: first-operand (-> ProcedureOps Any))
(define (first-operand ops) (car ops))

; Selector; choosing operands from a ProcedureOps.
;(: operands (-> ProcedureOps ProcedureOps))
(define (rest-operands ops) (cdr ops))

;(: no-operands? (-> ProcedureOps Boolean))
(define (no-operands? ops) (null? ops))

;(: list-of-values (-> (Listof ProcedureOps) Environment 
;                   (Listof Any)))
(define (list-of-values expr-ops env)
  (if (no-operands? expr-ops)
    null
    (cons (meta-eval (first-operand expr-ops) env)
          (list-of-values (rest-operands expr-ops) env))))

; procedure is expressed as a tagged-list of 'procedure
; with parameters, body and environment consed together.
(define (make-procedure parameters body env)
  `(procedure ,parameters ,body ,env))

; See if the given list is a 'procedure.
(define (compound-procedure? p)
  (tagged-list? p 'procedure))

; selectors against a compound-procedure list.
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

#|Primitive procedures are tagged 'primitive, whose implementations are 
 its cadr part of hte list `(primitive ,procname).|#
(define (primitive-procedure? proc) (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

#| Define all the primitive procedures used in this m-eval program. 'primitive
 tag consed with its car part. |#
;(: primitive-procedures (Listof (Pairof Symbol Procedure)))
(define primitive-procedures
  (list (cons 'car car)
        (cons 'cdr cdr)
        (cons 'cons cons)
        (cons 'null? null?)
        (cons 'symbol? symbol?)
        (cons 'list list) 
        (cons 'append append)
        (cons 'eq? eq?)
        (cons 'cadr cadr)
        (cons 'caddr caddr)
        (cons 'number? number?)
        (cons 'string? string?)
        (cons 'pair? pair?)
        (cons 'map map)
        (cons 'read read)
        (cons '+ +)
        (cons '- -)
        (cons '* *)
        (cons '/ /)
        (cons '< <)
        (cons '> >)
        (cons '= =)
        (cons 'remainder remainder)
        (cons 'procedure? procedure?)
        (cons 'ormap ormap)
        (cons 'andmap andmap)
        (cons 'quotient quotient)))

; extract all the identifiers of pre-defined primitive procedures.
; (: primitive-procedure-names (-> (Listof Symbol)))
(define (primitive-procedure-names)
  (map car primitive-procedures))

; extract all the procedure objects of primitive procedures.
; (: primitive-procedure-objects (-> (Listof (Listof Symbol Procedure))))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cdr proc)))
       primitive-procedures))

#|In order to apply primitive procedures, we just call apply from underlying Lisp
 implementation. To achieve that we rename the underlying apply.|#
(define apply-in-underlying-scheme apply)

(define (apply-primitive-procedure primitive-proc args)
  (apply-in-underlying-scheme 
    (primitive-implementation primitive-proc) args))

