#lang typed/racket

(provide (all-defined-out))
(require "./types.rkt")

;(define-type Variable Symbol)
;(define-type Value Any)
;(define-type Binding (Pairof Symbol Any))
;(define-type Frame (Listof Binding))
;(define-type Environment (U (Listof Null) Null (Listof Frame)))

#| Select the first frame of a given environment. |#
(: first-frame (-> Environment Frame))
(define (first-frame env) (car env))

#| Select enclosing frames of a given environment. |#
(: rest-frames (-> Environment Environment))
(define (rest-frames env) (cdr env))

#| Select enclosing environment of a given environment. |#
(: enclosing-environment : (-> Environment Environment))
(define (enclosing-environment env) (cdr env))

(define the-empty-environment '())
(: *environment* : Environment)
(define *environment* the-empty-environment)

#| Define selectors of a frame, |#
(: binding-variable (-> Binding Variable))
(define (binding-variable pair) (car pair))

(: binding-value (-> Binding Value))
(define (binding-value pair) (cdr pair))

#| Constructor of a frame using given variables and values|#
(: make-frame (-> (Listof Variable) (Listof Value) Frame))
(define (make-frame vars vals)
  (if (not (= (length vars) (length vals)))
    (error 'make-frame "given variables and values don't match")
    ((inst map Binding Variable Value) 
     (inst cons Variable Value) vars vals)))

#| Returns all the variables in a given frame. |#
(: frame-variables : (-> Frame (Listof Variable)))
(define (frame-variables frame) 
  ((inst map Variable Binding) car frame))

#| Returns all the values in a given frame. |#
(: frame-values : (-> Frame (Listof Value)))
(define (frame-values frame)
  ((inst map Value Binding) cdr frame))

#| If given variable exists in a given frame, 
   return the binding. Otherwise returns false. |#
(: variable-in-frame? : (-> Variable Frame (U Binding False)))
(define (variable-in-frame? var frame) (assoc var frame))

#| Pure procedure that returns newly crated frame whose members
   are updated with Binding. |#
(: add-binding-to-frame : (-> Variable Value Frame Frame))
(define (add-binding-to-frame var val frame)
  (let ((dup : (U Binding False) (variable-in-frame? var frame)))
    (cons (cons var val) (if dup (remove dup frame) frame))))

#| Add given mapping of (ann (cons var val) Binding) onto global environment 
   *environment*.|#
(: add-binding-to-global-frame! : (-> Variable Value Void))
(define (add-binding-to-global-frame! var val)
  (let ((new-binding : Binding (cons var val)))
    (if (null? *environment*) (set! *environment* (list (list new-binding)))
      (set! *environment* ((inst cons Frame Environment) 
                 (add-binding-to-frame var val (first-frame (ann *environment* Environment)))
                 (rest-frames *environment*))))))

#| Temporarily extend the environment with corresponding variables and
values given. As this is a pure function, after an evaluation of any expr
under newly created environment, the created environment is simply discarded.
Imitating the environment-model of evaluation process. |#
(: extend-environment : (-> (Listof Variable) (Listof Value) Environment 
                            Environment))
(define (extend-environment vars vals base-env)
  (: make-frame : (-> (Listof Variable) (Listof Value) (U Frame False)))
  (define (make-frame vars vals)
    (and (= (length vars) (length vals)) 
         ((inst map Binding Variable Value) (inst cons Variable Value) vars vals)))
  (let ((new-framep : (U Frame False) (make-frame vars vals)))
    (if new-framep (cons new-framep base-env)
      (error "Number of given variables and values don't match: " vars vals))))

(define frame (ann (list (ann (cons 'x 12) Binding) (ann (cons 'y 13) Binding)) Frame))

#| Returns the first occurrence of a given variable unde given environment. |#
(: lookup-variable-value : (-> Variable Environment Value))
(define (lookup-variable-value var env)
  (: env-iter : (-> Environment Value))
  (define (env-iter env)
    (: frame-iter : (-> Frame Value))
    (define (frame-iter frame)
      (let ((maybe-first-val : (U Binding False) (variable-in-frame? var frame)))
        (if maybe-first-val (binding-value maybe-first-val)
          (env-iter (enclosing-environment env)))))
    (if (eq? env the-empty-environment)
      (error "No binding in given environment:") (frame-iter (first-frame env))))
  (env-iter env))

#| Set a value of a variable to a given value in a frame where
   var first occurs in the global *environment* |#
(: set-variable-value! : (-> Variable Value Void))
(define (set-variable-value! var val)
  (: env-iter (-> Environment Environment))
  (define (env-iter env)
    (: frame-update : (-> Frame Environment))
    (define (frame-update frame)
      (cond [(variable-in-frame? var frame) 
             (cons (add-binding-to-frame var val frame) (rest-frames env))]
            [else (env-iter (enclosing-environment env))]))
    (if (eq? env the-empty-environment) (error "No binding in the current env")
      (frame-update (first-frame env))))
  (set! *environment* (env-iter *environment*)))

#| Wrapper of add-binding-to-glbal-frame|#
(: define-variable! : (-> Variable Value Void))
(define (define-variable! var val)
  (add-binding-to-global-frame! var val))

