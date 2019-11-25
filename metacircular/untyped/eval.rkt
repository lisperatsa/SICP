#lang racket

(require "./utils.rkt")
(require "./env.rkt")
(require "./lambda.rkt")
(require "./eval-let.rkt")
(require "./eval-variable.rkt")
(require "./eval-cond.rkt")

(provide (all-defined-out))

(define (meta-eval expr env)
  (cond [(self-evaluating? expr) expr]
        [(variable? expr) (lookup-variable-value expr env)]
        [(quoted? expr) (text-of-quotation expr)]
        [(assignment? expr) (eval-assignment expr env)]
        [(definition? expr) (eval-definition expr env)]
        [(let? expr) (eval-let expr env)]
        [(if? expr) (eval-if expr env)]
        [(lambda? expr) (make-procedure (lambda-parameters expr)
                                        (lambda-body expr)
                                        env)]
        [(begin? expr) (eval-sequence (begin-actions expr) env)]
        [(cond? expr) (meta-eval (cond->if expr) env)]
        [(application? expr) 
         (meta-apply (meta-eval (operator expr) env)
                (list-of-values (operands expr) env))]
        [else (error "unknown expression -- EVAL" expr)]))
 
(require "eval-if.rkt")
#| Evaluate given tagged-if-expr. Evaluation process itself is quite simple. |#
(define (eval-if expr env)
  (if (true? (meta-eval (if-predicate expr) env))
    (meta-eval (if-consequent expr) env)
    (meta-eval (if-alternative expr) env)))

(require "eval-sequence.rkt")
#| Evaluate body part of given tagged-begin-expr.|#
(define (eval-sequence actions env)
  (cond [(last-expr? actions) (meta-eval (first-expr actions) env)]
        [else (meta-eval (first-expr actions) env)
              (eval-sequence (rest-exprs actions) env)]))

(require "eval-definition.rkt")
#| Evaluate given definition-expr. |#
(define (eval-definition expr env)
  (define-variable! (definition-variable expr)
                    (meta-eval (definition-value expr) env)
                    env))

#|Evaluate given assignment-expr.|#
(require "eval-assignment.rkt")
(define (eval-assignment expr env)
  (set-variable-value! (assignment-variable expr)
                       (meta-eval (assignment-value expr) env)
                       env))

#|Evaluate connectives, and or|#
(require "eval-connective.rkt")

#| eval-and firstly list up the given argumetns of and-expr 
   and put it in args. then, in the cond-expr|#
(define (eval-and expr env)
  (let ((args (connective-args expr)))
    (cond [(connective-no-args? args) #t]
          [(connective-one-arg? args) (connective-first-arg args)]
          [else 
            (let ((first-arg (meta-eval (connective-first-arg args) env)))
              (if first-arg 
                (eval-and (connective-rest-args args) env) 
                #f))])))

(define (eval-or expr env)
  (let ([args (connective-args expr)])
    (cond [(connective-no-args? args) #f]
          [(connective-one-arg? args) (connective-first-arg args)]
          [else 
            (let ([first-arg (meta-eval (connective-first-arg args) env)])
                  (if first-arg first-arg 
                    (eval-or (connective-rest-args args) env)))])))

#| Evaluate a let-expr.|#
(define (eval-let expr env)
  (meta-eval (let->combination expr) env))

#| APPLY: apply given procedure to given arguments, according to the
 kind of a given procedure, either primitive or compound. |#
(require "eval-procedure.rkt")
(define (meta-apply procedure arguments)
  (cond [(primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments)]
        [(compound-procedure? procedure)
         (eval-sequence 
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             arguments
             (procedure-environment procedure)))]
        [else (error "Unknown procedure type -- APPLY" procedure)]))

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
        (cons 'displayln displayln)
        (cons 'display display)
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
        (cons 'null null)
        (cons '< <)
        (cons '> >)
        (cons '= =)
        (cons 'remainder remainder)
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

; (: input-prompt String)
(define input-prompt ";;; M-Eval input:")
; (: output-prompt String)
(define output-prompt ";;; M-Eval value:")
; (: driver-loop (-> Void))
#;(define (driver-loop)
  (let ((input (read)))
    (let ((output (meta-eval input *environment*)))
      (announce-output output-prompt)
      (user-output output)
      (driver-loop))))

; (: announce-output (-> String Void))
(define (announce-output output-str)
  (newline)
  (displayln output-str)
  (newline))

