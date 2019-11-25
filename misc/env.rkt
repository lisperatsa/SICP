#lang racket

(provide (all-defined-out))
#| The environment should be defined as list(environment) 
 of list(frame) of assoc lists(var-val mapping).|#
(define *environment* (list (list (cons 'a 1) (cons 'b 2)) 
                            (list (cons 'c 3) (cons 'a 5))))

#| Define selectors and initial environment here.|#
(define (first-frame env) (car env))
(define (rest-frames env) (cdr env))
(define enclosing-environment rest-frames)
(define the-empty-environment null)

(define (variable-name pair) (car pair))
(define (variable-value pair) (cdr pair))

#| Constructor of a frame using given variables and values|#
(define (make-frame variables values)
  (and (= (length variables) (length values)) (map cons variables values)))

#| Returns all the variables in a given frame. |#
(define (frame-variables frame) (map car frame))
#| RESP. values |#
(define (frame-values frame) (map cdr frame))

#| Alias procedure for data abstraction. |#
(define (variable-in-frame? var frame) (assoc var frame))

#| Pure procedure that returns newly created frame whose members 
 are updated with `(cons ,var ,val). |#
(define (add-binding-to-frame var val frame)
  (let ((duplicatep (variable-in-frame? var frame)))
    (cons (cons var val) 
          (if duplicatep (remove duplicatep frame) frame))))

#| Add given mapping of `(cons ,var ,val) onto global *environment*. |#
(define (add-binding-to-global-frame! var val)
  (set! *environment* 
    (cons (add-binding-to-frame var val (first-frame *environment*))
          (rest-frames *environment*))) 
  *environment*)

#| Temporarily extend the environment with corresponding variables and
 values given. As this is a pure function, after an evaluation of any expr
 under newly created environment the created environment is simply discarded,
 imitating the environment-model of evaluation process. |#
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

(define update-binding-in-frame add-binding-to-frame)
#| Set a value of variable var to val in a frame where var's first
 occurrence in the global *environment*. |#
(define (set-variable-value! var val [env *environment*])
  (define (env-iter env)
    (define (frame-iter frame)
      (cond [(variable-in-frame? var frame) 
             (cons (add-binding-to-frame var val frame) (rest-frames env))]
            [else (env-iter (enclosing-environment env))]))
    (if (eq? env the-empty-environment)
      (error "No binding in the current environment") (frame-iter (first-frame env))))
  (set! *environment* (env-iter env)) *environment*)

#| Defining variables using define operator means to add or update
 binding of the first frame with `(cons ,var ,val). |#
(define (define-variable! var val [env *environment*])
  (add-binding-to-global-frame! var val))

