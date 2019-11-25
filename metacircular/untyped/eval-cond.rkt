#lang racket

(require "./utils.rkt")
(require "./eval-if.rkt")
(require "eval-if.rkt")
(require "./eval-sequence.rkt")
(provide (all-defined-out))

#| cond expr has a form `(cond ,((,pred1 ,coseq1) ...) . Helper functions
 for evaluating this expr are below. |#

; See if given expr is cond-expr
; (: cond? (-> Expr Boolean))
(define (cond? expr) (tagged-list? expr 'cond))

(define (cond-first-clause clauses) (car clauses))

(define (cond-rest-clauses clauses) (cdr clauses))

; Select predicate part of a given cond-clause
(define (cond-clause-predicate clause) (car clause))

; Select cond clauses from cond-expr
(define (cond-clauses expr) (cadr expr))

; Select action part of a given cond-clause
(define (cond-clause-actions clause) (cdr clause))

; See if given clause is an else-clause
(define (cond-else-clause? clause) 
  (eq? (cond-clause-predicate clause) 'else))

; Any proper cond-expr `(cond ,((,pred1 ,action1) ... (else ,action-else))) 
; can be converted to equivalent nested-if clause 
; `(if ,pred1 ,action1 (if ,pred2 ,action2 (... ,action-else))))
(define (expand-clauses clauses)
  (if (null? clauses)
    'false
    (let ((first-clause (car clauses))
          (rest-clauses (cdr clauses)))
      (if (cond-else-clause? first-clause)
        (if (null? rest-clauses)
          (sequence->expr (cond-clause-actions first-clause))
          (error "ELSE clause isn't the last -- COND->IF" clauses))
        (make-if (cond-clause-predicate first-clause)
                 (sequence->expr (cond-clause-actions first-clause))
                 (expand-clauses rest-clauses))))))

(define (cond->if expr) (expand-clauses (cond-clauses expr)))

