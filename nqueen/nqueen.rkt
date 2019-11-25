#lang racket
(define (flatmap fn lst)
  (foldr append null (map fn lst)))

(struct point (row column) #:transparent)
(define empty-board null)

(define (diagonal? pos pivot)
  (let ((piv-row (point-row pivot)) (piv-column (point-column pivot))
        (pos-row (point-row pos)) (pos-column (point-column pos)))
    (or (= (+ piv-row piv-column) (+ pos-row pos-column))
        (= (abs (- piv-row piv-column)) (abs (- pos-row pos-column))))))

(define (horizontal? pos pivot)
  (= (point-row pos) (point-row pivot)))

(define (column-n positions k)
  (filter (lambda (p) (= (point-column p) k)) positions))

(define (safe? k positions)
  (let ((target (car (column-n positions k))))
    (not (ormap (lambda (x) (or (diagonal? x target) (horizontal? x target)))
                positions))))

(define (adjoin-position new-row k rest-of-queens)
  (cons (point new-row k) rest-of-queens))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
      (list empty-board)
      (filter 
        (lambda (positions) (safe? k positions))
        (flatmap 
          (lambda (rest-of-queens)
            (map (lambda (new-row) (adjoin-position new-row k rest-of-queens))
                   (range board-size)))
          (queen-cols (sub1 k))))))
  (queen-cols board-size))

