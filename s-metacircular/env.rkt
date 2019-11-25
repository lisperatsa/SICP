#lang typed/racket

(define-type Mapping (Pairof Symbol Any))
(define-type Frame (Listof Mapping))
(define-type Environment (Listof Frame))
(define-type Variable Symbol)
(define-type Variables (Listof Variable))
(define-type Value Any)
(define-type Values (Listof Value))
 
(: *environment* Environment)
(define *environment* (list (list (cons 'a 1) (cons 'b 2))))

(: first-frame (-> Environment Frame))
(define (first-frame env) (car env))

(: rest-frames (-> Environment Environment))
(define (rest-frames env) (cdr env))

(: enclosing-environment (-> Environment Environment))
(define (enclosing-environment env) (cdr env))

(define the-empty-environment null)

(: make-frame (-> Variables Values Frame))
(define (make-frame vars vals)
  (if (= (length vars) (length vals))
    (map (inst cons Symbol Any) vars vals) 
    (error "Var-Val pair not match: " vars vals)))

(: new-frame (-> (Listof Null)))
(define (new-frame) (list (list)))

(: frame-variables (-> Frame Variables))
(define (frame-variables frame)
  (map (inst car Symbol) frame))

(: frame-values (-> Frame Values))
(define (frame-values frame) (map (inst cdr Symbol) frame))

(define variable-in-frame? assoc)
(: append-frame (-> Frame Environment Environment))
(define (append-frame frame env) (cons frame env))

(: add-binding-to-frame (-> Variable Value Frame Frame))
(define (add-binding-to-frame var val frame)
  (let ((duplicatep (variable-in-frame? var frame)))
    (cons (cons var val)
          (if duplicatep (remove duplicatep frame) frame))))

(: add-binding-to-global-frame! (-> Variable Value Environment))
(define (add-binding-to-global-frame! var val)
  (set! *environment*
    (append-frame 
      (add-binding-to-frame var val (first-frame *environment*))
      *environment*))
  *environment*)

