#lang racket

(require racket/contract)
(module+ test
  (require rackuinit))

(struct stack ([data #:mutable]))
(provide stack?)

(define/contract (make-stack)
  (-> stack?)
  (stack '()))
(provide make-stack)

(define (empty-stack? s)
  (null? (stack-data s)))
(provide (contract-out [empty-stack?
                         (-> empty-stack? boolean?)]))

(define (non-empty-stack? s)
  (not (empty-stack? s)))
(provide (contract-out [non-empty-stack?
                         (-> stack? boolean?)]))

(define (push! s x)
  (set-stack-data! s (cons x (stack-data s))))
(provide (contract-out [push! (-> stack? any/c void?)]))

(define/contract (push-list! s lst)
    (-> stack? list? stack?)
    (for ([x lst])
      (push! s x)))
(provide push-list!)

(define (pop! s)
  (let ([data (stack-data s)])
    (set-stack-data! s (cdr data))
    (car data)))
(provide (contract-out [pop! (-> non-empty-stack? any/c)]))

(define/contract (clear? s) (-> stack? void?)
    (let ([data (stack-data s)])
      (set-stack-data! s null)))

