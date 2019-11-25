#lang racket

(require "utils.rkt")
(require "./eval-procedure.rkt")
(provide (all-defined-out))
#| The environment should be defined as list(environment) 
 of list(frame) of assoc lists(var-val mapping).|#

;(define *environment* (list (list (cons 'a 1) (cons 'b 2)) (list (cons 'c 3) (cons 'a 5))))
;(define-type Variable Symbol)
;(define-type Value Any)
;(define-type Binding (Pairof Symbol Any))
;(define-type Frame (Listof Binding))
;(define-type Environment (Listof Frame))
;(: first-frame (-> Environment Frame))

(define (first-frame env) (car env))
;(: rest-frames (-> Environment (Listof Frame)))
(define (rest-frames env) (cdr env))
(define enclosing-environment rest-frames)
;(: the-empty-environment Null)
(define the-empty-environment '(()))
(define *environment* the-empty-environment)

#| Define selectors and initial environment here.|#
;(: variable-name (-> Binding Symbol))
(define (variable-name pair) (car pair))
;(: variable-value (-> Binding Any))
(define (variable-value pair) (cdr pair))

#| Constructor of a frame using given variables and values|#
;(: make-frame (-> (Listof Variable) (Listof Value) Frame)) 
(define (make-frame variables values)
  (and (= (length variables) (length values)) (map cons variables values)))

#| Returns all the variables in a given frame. |#
;(: frame-variables (-> Frame (Listof Variable)))
(define (frame-variables frame) (map car frame))
#| RESP. values |#
;(: frame-values (-> Frame (Listof Value)))
(define (frame-values frame) (map cdr frame))

#| Alias procedure for data abstraction. |#
;(: variable-in-frame? (-> Symbol Frame Boolean))
(define (variable-in-frame? var frame) (assoc var frame))

#| Pure procedure that returns newly created frame whose members 
 are updated with `(cons ,var ,val). |#
;(: add-binding-to-frame (-> Variable Value Frame Frame))
(define (add-binding-to-frame var val frame)
  (let ((duplicatep (variable-in-frame? var frame)))
    (cons (cons var val) 
          (if duplicatep (remove duplicatep frame) frame))))

#| Add given mapping of `(cons ,var ,val) onto global *environment*. |#
;(: add-binding-to-global-frame! (-> Variable Value))
(define (add-binding-to-global-frame! var val)
  (set! *environment* 
    (cons (add-binding-to-frame var val (first-frame *environment*))
          (rest-frames *environment*))))
 
#| Temporarily extend the environment with corresponding variables and
 values given. As this is a pure function, after an evaluation of any expr
 under newly created environment the created environment is simply discarded,
 imitating the environment-model of evaluation process. |#
;(: extend-environment (-> (Listof Variable) (Listof Value) Environment Environment))
(define (extend-environment variables values base-env)
  (define (make-frame vars vals) 
    (and (= (length vars) (length vals)) (map cons vars vals)))
  (let ((new-framep (make-frame variables values)))
    (if new-framep (cons new-framep base-env)
      (error "Number of given variables and values don't match: " 
             variables values))))

#| Returns the first occurrence of the given var under given environment env. |#
; (: lookup-variable-value (-> Variable Environment Value))
(define (lookup-variable-value var env)
  (define (env-iter env)
    (define (frame-iter frame)
      (let ((maybe-first-var-val (variable-in-frame? var frame)))
        (if maybe-first-var-val (variable-value maybe-first-var-val) 
          (env-iter (enclosing-environment env)))))
    (if (eq? env the-empty-environment) 
      (error "No binding in given environment:") (frame-iter (first-frame env))))
  (env-iter env))


#| Set a value of variable var to val in a frame where var's first
 occurrence in the global *environment*. |#
;(: set-variable-value! (-> Variable Value (Environment)))
(define (set-variable-value! var val [env *environment*])
  (define (env-iter env)
    (define (frame-iter frame)
      (cond [(variable-in-frame? var frame) 
             (cons (add-binding-to-frame var val frame) (rest-frames env))]
            [else (env-iter (enclosing-environment env))]))
    (if (or (eq? env the-empty-environment) (null? env))
      (error "No binding in the current environment") (frame-iter (first-frame env))))
  (set! *environment* (env-iter env)))
 
#| Defining variables using define operator means to add or update
 binding of the first frame with `(cons ,var ,val). |#
;(: define-variable! (-> Variable Value (Environment)))
(define (define-variable! var val [env *environment*])
  (add-binding-to-global-frame! var val))
 
#| Setup initial environment in order to start evalating the program about to be given. |#
;(: setup-environment (-> Environment))
(define (setup-environment)
  (let ((initial-env
          (extend-environment (primitive-procedure-names)
                              (primitive-procedure-objects)
                              the-empty-environment)))
    (define-variable! 'true #t initial-env)
    (define-variable! 'false #f initial-env)
    initial-env))
(set! *environment* (setup-environment))

