#lang racket                          

;(: primitive-procedures : 
;   (List (Pair 'car (All (a b) (case-> (-> (Pairof a b) a)
;                                        (-> (Listof a) a))))
;         (Pair 'cdr (All (a b) (case-> (-> (Pairof a b) b)
;                                       (-> (Listof a) (Listof a)))))
;         (Pair 'cadr (All (a b c) (case-> (-> (List* a b c) b)
;                                          (-> (Listof a) a))))
;         (Pair 'cons (All (a b) (case-> (-> a (Listof a) (Listof a)) 
;                                        (-> a b (Pairof a b)))))
;         (Pair 'append (All (a) (case-> (-> (Pairof a (Listof a)) 
;                                            (Listof a) * (Pairof a (Listof a)))
;                                        (-> (Listof a) * (Listof a)))))
;         (Pair 'list (All (a) (-> a * (Listof a))))
;         (Pair 'caddr (All (a b c d) (case-> (-> (List* a b c d) c) 
;                                             (-> (Listof a) a))))
;         (Pair 'ormap (All (a c b ...) (-> (-> a b ... b c) (Listof a) 
;                                           (Listof b) ... b (U False c))))
;         (Pair 'andmap (All (a c d b ...) (case-> (-> (-> a c : d) (Listof a) c)
;                                                  (-> (-> a b ... b c) (Listof a) 
;                                                      (Listof b) ... b (U True c)))))
;         (Pair 'eq? (-> Any Any Boolean))
;         (Pair 'number? (-> Any Boolean : Number))
;         (Pair 'string? (-> Any Boolean : String))
;         (Pair 'pair? (-> Any Boolean : (Pairof Any Any)))
;         (Pair 'map (All (c a b ...) 
;                         (case-> 
;                           (-> (-> a c) (Pairof a (Listof a)) (Pairof c (Listof c)))
;                           (-> (-> a b ... b c) (Listof a) (Listof b) ... b (Listof c)))))
;         (Pair 'read (->* () (Input-Port) Any))
;         (Pair '+ (case->
;                     (-> Zero)
;                     (-> Number Number)
;                     (-> Zero Zero Zero)
;                     (-> Number Zero Number)
;                     (-> Zero Number Number)
;                     (-> Positive-Byte Positive-Byte Positive-Index)
;                     (-> Byte Byte Index)
;                     (-> Positive-Byte Positive-Byte Positive-Byte Positive-Index)
;                     (-> Byte Byte Byte Index)
;                     (-> Positive-Index Index Positive-Fixnum)
;                     (-> Index Positive-Index Positive-Fixnum)
;                     (-> Positive-Index Index Index Positive-Fixnum)
;                     (-> Index Positive-Index Index Positive-Fixnum)
;                     (-> Index Index Positive-Index Positive-Fixnum)
;                     (->* (Index Index) (Index) Nonnegative-Fixnum)
;                     (-> Negative-Fixnum One Nonpositive-Fixnum)
;                     (-> One Negative-Fixnum Nonpositive-Fixnum)
;                     (-> Nonpositive-Fixnum Nonnegative-Fixnum Fixnum)
;                     (-> Nonnegative-Fixnum Nonpositive-Fixnum Fixnum)
;                     (-> Positive-Integer
;                         Nonnegative-Integer
;                         Nonnegative-Integer
;                         *
;                         Positive-Integer)
;                     (-> Nonnegative-Integer
;                         Positive-Integer
;                         Nonnegative-Integer
;                         *
;                         Positive-Integer)
;                     (-> Nonnegative-Integer
;                         Nonnegative-Integer
;                         Positive-Integer
;                         Nonnegative-Integer
;                         *
;                         Positive-Integer)
;                     (-> Negative-Integer
;                         Nonpositive-Integer
;                         Nonpositive-Integer
;                         *
;                         Negative-Integer)
;                     (-> Nonpositive-Integer
;                         Negative-Integer
;                         Nonpositive-Integer
;                         *
;                         Negative-Integer)
;                     (-> Nonpositive-Integer
;                         Nonpositive-Integer
;                         Negative-Integer
;                         Nonpositive-Integer
;                         *
;                         Negative-Integer)
;                     (-> Nonnegative-Integer * Nonnegative-Integer)
;                     (-> Nonpositive-Integer * Nonpositive-Integer)
;                     (-> Integer * Integer)
;                     (-> Positive-Exact-Rational
;                         Nonnegative-Exact-Rational
;                         Nonnegative-Exact-Rational
;                         *
;                         Positive-Exact-Rational)
;                     (-> Nonnegative-Exact-Rational
;                         Positive-Exact-Rational
;                         Nonnegative-Exact-Rational
;                         *
;                         Positive-Exact-Rational)
;                     (-> Nonnegative-Exact-Rational
;                         Nonnegative-Exact-Rational
;                         Positive-Exact-Rational
;                         Nonnegative-Exact-Rational
;                         *
;                         Positive-Exact-Rational)
;                     (-> Negative-Exact-Rational
;                         Nonpositive-Exact-Rational
;                         Nonpositive-Exact-Rational
;                         *
;                         Negative-Exact-Rational)
;                     (-> Nonpositive-Exact-Rational
;                         Negative-Exact-Rational
;                         Nonpositive-Exact-Rational
;                         *
;                         Negative-Exact-Rational)
;                     (-> Nonpositive-Exact-Rational
;                         Nonpositive-Exact-Rational
;                         Negative-Exact-Rational
;                         Nonpositive-Exact-Rational
;                         *
;                         Negative-Exact-Rational)
;                     (-> Nonnegative-Exact-Rational * Nonnegative-Exact-Rational)
;                     (-> Nonpositive-Exact-Rational * Nonpositive-Exact-Rational)
;                     (-> Exact-Rational * Exact-Rational)
;                     (-> Positive-Flonum Nonnegative-Real Nonnegative-Real * Positive-Flonum)
;                     (-> Nonnegative-Real Positive-Flonum Nonnegative-Real * Positive-Flonum)
;                     (-> Nonnegative-Real
;                         Nonnegative-Real
;                         Positive-Flonum
;                         Nonnegative-Real
;                         *
;                         Positive-Flonum)
;                     (-> Positive-Real Nonnegative-Flonum Nonnegative-Flonum * Positive-Flonum)
;                     (-> Nonnegative-Flonum Positive-Real Nonnegative-Flonum * Positive-Flonum)
;                     (-> Nonnegative-Flonum
;                         Nonnegative-Flonum
;                         Positive-Real
;                         Nonnegative-Flonum
;                         *
;                         Positive-Flonum)
;                     (-> Negative-Flonum Nonpositive-Real Nonpositive-Real * Negative-Flonum)
;                     (-> Nonpositive-Real Negative-Flonum Nonpositive-Real * Negative-Flonum)
;                     (-> Nonpositive-Real
;                         Nonpositive-Real
;                         Negative-Flonum
;                         Nonpositive-Real
;                         *
;                         Negative-Flonum)
;                     (-> Negative-Real Nonpositive-Flonum Nonpositive-Flonum * Negative-Flonum)
;                     (-> Nonpositive-Flonum Negative-Real Nonpositive-Flonum * Negative-Flonum)
;                     (-> Nonpositive-Flonum
;                         Nonpositive-Flonum
;                         Negative-Real
;                         Nonpositive-Flonum
;                         *
;                         Negative-Flonum)
;                     (-> Nonnegative-Flonum Nonnegative-Real Nonnegative-Real * Nonnegative-Flonum)
;                     (-> Nonnegative-Real Nonnegative-Flonum Nonnegative-Real * Nonnegative-Flonum)
;                     (-> Nonnegative-Real
;                         Nonnegative-Real
;                         Nonnegative-Flonum
;                         Nonnegative-Real
;                         *
;                         Nonnegative-Flonum)
;                     (-> Nonpositive-Flonum Nonpositive-Real Nonpositive-Real * Nonpositive-Flonum)
;                     (-> Nonpositive-Real Nonpositive-Flonum Nonpositive-Real * Nonpositive-Flonum)
;                     (-> Nonpositive-Real
;                         Nonpositive-Real
;                         Nonpositive-Flonum
;                         Nonpositive-Real
;                         *
;                         Nonpositive-Flonum)
;                     (-> Flonum Real Real * Flonum)
;                     (-> Real Flonum Real * Flonum)
;                     (-> Real Real Flonum Real * Flonum)
;                     (-> Flonum Flonum * Flonum)
;                     (-> Positive-Single-Flonum
;                         (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         *
;                         Positive-Single-Flonum)
;                     (-> (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         Positive-Single-Flonum
;                         (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         *
;                         Positive-Single-Flonum)
;                     (-> (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         Positive-Single-Flonum
;                         (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         *
;                         Positive-Single-Flonum)
;                     (-> (U Positive-Exact-Rational Positive-Single-Flonum)
;                         Nonnegative-Single-Flonum
;                         Nonnegative-Single-Flonum
;                         *
;                         Positive-Single-Flonum)
;                     (-> Nonnegative-Single-Flonum
;                         (U Positive-Exact-Rational Positive-Single-Flonum)
;                         Nonnegative-Single-Flonum
;                         *
;                         Positive-Single-Flonum)
;                     (-> Nonnegative-Single-Flonum
;                         Nonnegative-Single-Flonum
;                         (U Positive-Exact-Rational Positive-Single-Flonum)
;                         Nonnegative-Single-Flonum
;                         *
;                         Positive-Single-Flonum)
;                     (-> Negative-Single-Flonum
;                         (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         *
;                         Negative-Single-Flonum)
;                     (-> (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         Negative-Single-Flonum
;                         (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         *
;                         Negative-Single-Flonum)
;                     (-> (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         Negative-Single-Flonum
;                         (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         *
;                         Negative-Single-Flonum)
;                     (-> (U Negative-Exact-Rational Negative-Single-Flonum)
;                         Nonpositive-Single-Flonum
;                         Nonpositive-Single-Flonum
;                         *
;                         Negative-Single-Flonum)
;                     (-> Nonpositive-Single-Flonum
;                         (U Negative-Exact-Rational Negative-Single-Flonum)
;                         Nonpositive-Single-Flonum
;                         *
;                         Negative-Single-Flonum)
;                     (-> Nonpositive-Single-Flonum
;                         Nonpositive-Single-Flonum
;                         (U Negative-Exact-Rational Negative-Single-Flonum)
;                         Nonpositive-Single-Flonum
;                         *
;                         Negative-Single-Flonum)
;                     (-> Nonnegative-Single-Flonum
;                         (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         *
;                         Nonnegative-Single-Flonum)
;                     (-> (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         Nonnegative-Single-Flonum
;                         (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         *
;                         Nonnegative-Single-Flonum)
;                     (-> (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         Nonnegative-Single-Flonum
;                         (U Nonnegative-Exact-Rational Nonnegative-Single-Flonum)
;                         *
;                         Nonnegative-Single-Flonum)
;                     (-> Nonpositive-Single-Flonum
;                         (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         *
;                         Nonpositive-Single-Flonum)
;                     (-> (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         Nonpositive-Single-Flonum
;                         (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         *
;                         Nonpositive-Single-Flonum)
;                     (-> (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         Nonpositive-Single-Flonum
;                         (U Nonpositive-Exact-Rational Nonpositive-Single-Flonum)
;                         *
;                         Nonpositive-Single-Flonum)
;                     (-> Single-Flonum
;                         (U Exact-Rational Single-Flonum)
;                         (U Exact-Rational Single-Flonum)
;                         *
;                         Single-Flonum)
;                     (-> (U Exact-Rational Single-Flonum)
;                         Single-Flonum
;                         (U Exact-Rational Single-Flonum)
;                         *
;                         Single-Flonum)
;                     (-> (U Exact-Rational Single-Flonum)
;                         (U Exact-Rational Single-Flonum)
;                         Single-Flonum
;                         (U Exact-Rational Single-Flonum)
;                         *
;                         Single-Flonum)
;                     (-> Single-Flonum Single-Flonum * Single-Flonum)
;                     (-> Positive-Inexact-Real
;                         Nonnegative-Real
;                         Nonnegative-Real
;                         *
;                         Positive-Inexact-Real)
;                     (-> Nonnegative-Real
;                         Positive-Inexact-Real
;                         Nonnegative-Real
;                         *
;                         Positive-Inexact-Real)
;                     (-> Nonnegative-Real
;                         Nonnegative-Real
;                         Positive-Inexact-Real
;                         Nonnegative-Real
;                         *
;                         Positive-Inexact-Real)
;                     (-> Positive-Real
;                         Nonnegative-Inexact-Real
;                         Nonnegative-Inexact-Real
;                         *
;                         Positive-Inexact-Real)
;                     (-> Nonnegative-Inexact-Real
;                         Positive-Real
;                         Nonnegative-Inexact-Real
;                         *
;                         Positive-Inexact-Real)
;                     (-> Nonnegative-Inexact-Real
;                         Nonnegative-Inexact-Real
;                         Positive-Real
;                         Nonnegative-Inexact-Real
;                         *
;                         Positive-Inexact-Real)
;                     (-> Negative-Inexact-Real
;                         Nonpositive-Real
;                         Nonpositive-Real
;                         *
;                         Negative-Inexact-Real)
;                     (-> Nonpositive-Real
;                         Negative-Inexact-Real
;                         Nonpositive-Real
;                         *
;                         Negative-Inexact-Real)
;                     (-> Nonpositive-Real
;                         Nonpositive-Real
;                         Negative-Inexact-Real
;                         Nonpositive-Real
;                         *
;                         Negative-Inexact-Real)
;                     (-> Negative-Real
;                         Nonpositive-Inexact-Real
;                         Nonpositive-Inexact-Real
;                         *
;                         Negative-Inexact-Real)
;                     (-> Nonpositive-Inexact-Real
;                         Negative-Real
;                         Nonpositive-Inexact-Real
;                         *
;                         Negative-Inexact-Real)
;                     (-> Nonpositive-Inexact-Real
;                         Nonpositive-Inexact-Real
;                         Negative-Real
;                         Nonpositive-Inexact-Real
;                         *
;                         Negative-Inexact-Real)
;                     (-> Nonnegative-Inexact-Real
;                         Nonnegative-Real
;                         Nonnegative-Real
;                         *
;                         Nonnegative-Inexact-Real)
;                     (-> Nonnegative-Real
;                         Nonnegative-Inexact-Real
;                         Nonnegative-Real
;                         *
;                         Nonnegative-Inexact-Real)
;                     (-> Nonnegative-Real
;                         Nonnegative-Real
;                         Nonnegative-Inexact-Real
;                         Nonnegative-Real
;                         *
;                         Nonnegative-Inexact-Real)
;                     (-> Nonpositive-Inexact-Real
;                         Nonpositive-Real
;                         Nonpositive-Real
;                         *
;                         Nonpositive-Inexact-Real)
;                     (-> Nonpositive-Real
;                         Nonpositive-Inexact-Real
;                         Nonpositive-Real
;                         *
;                         Nonpositive-Inexact-Real)
;                     (-> Nonpositive-Real
;                         Nonpositive-Real
;                         Nonpositive-Inexact-Real
;                         Nonpositive-Real
;                         *
;                         Nonpositive-Inexact-Real)
;                     (-> Inexact-Real Real Real * Inexact-Real)
;                     (-> Real Inexact-Real Real * Inexact-Real)
;                     (-> Real Real Inexact-Real Real * Inexact-Real)
;                     (-> Positive-Real Nonnegative-Real Nonnegative-Real * Positive-Real)
;                     (-> Nonnegative-Real Positive-Real Nonnegative-Real * Positive-Real)
;                     (-> Nonnegative-Real
;                         Nonnegative-Real
;                         Positive-Real
;                         Nonnegative-Real
;                         *
;                         Positive-Real)
;                     (-> Negative-Real Nonpositive-Real Nonpositive-Real * Negative-Real)
;                     (-> Nonpositive-Real Negative-Real Nonpositive-Real * Negative-Real)
;                     (-> Nonpositive-Real
;                         Nonpositive-Real
;                         Negative-Real
;                         Nonpositive-Real
;                         *
;                         Negative-Real)
;                     (-> Nonnegative-Real * Nonnegative-Real)
;                     (-> Nonpositive-Real * Nonpositive-Real)
;                     (-> Real * Real)
;                     (-> Exact-Number * Exact-Number)
;                     (-> Float-Complex Number Number * Float-Complex)
;                     (-> Number Float-Complex Number * Float-Complex)
;                     (-> Number Number Float-Complex Number * Float-Complex)
;                     (-> Flonum Inexact-Complex Inexact-Complex * Float-Complex)
;                     (-> Inexact-Complex Flonum Inexact-Complex * Float-Complex)
;                     (-> Inexact-Complex Inexact-Complex Flonum Inexact-Complex * Float-Complex)
;                     (-> Single-Flonum-Complex
;                         (U Exact-Rational Single-Flonum Single-Flonum-Complex)
;                         (U Exact-Rational Single-Flonum Single-Flonum-Complex)
;                         *
;                         Single-Flonum-Complex)
;                     (-> (U Exact-Rational Single-Flonum Single-Flonum-Complex)
;                         Single-Flonum-Complex
;                         (U Exact-Rational Single-Flonum Single-Flonum-Complex)
;                         *
;                         Single-Flonum-Complex)
;                     (-> (U Exact-Rational Single-Flonum Single-Flonum-Complex)
;                         (U Exact-Rational Single-Flonum Single-Flonum-Complex)
;                         Single-Flonum-Complex
;                         (U Exact-Rational Single-Flonum Single-Flonum-Complex)
;                         *
;                         Single-Flonum-Complex)
;                     (-> Inexact-Complex
;                         (U Inexact-Complex Real)
;                         (U Inexact-Complex Real)
;                         *
;                         Inexact-Complex)
;                     (-> (U Inexact-Complex Real)
;                         Inexact-Complex
;                         (U Inexact-Complex Real)
;                         *
;                         Inexact-Complex)
;                     (-> (U Inexact-Complex Real)
;                         (U Inexact-Complex Real)
;                         Inexact-Complex
;                         (U Inexact-Complex Real)
;                         *
;                         Inexact-Complex)
;                     (-> Number * Number)))
;         (Pair '- (case->
;                         (-> Zero Zero Zero)
;                         (-> Positive-Fixnum Negative-Fixnum)
;                         (-> Nonnegative-Fixnum Nonpositive-Fixnum)
;                         (-> Zero Positive-Fixnum Negative-Fixnum)
;                         (-> Zero Nonnegative-Fixnum Nonpositive-Fixnum)
;                         (-> Positive-Integer Negative-Integer)
;                         (-> Nonnegative-Integer Nonpositive-Integer)
;                         (-> Negative-Integer Positive-Integer)
;                         (-> Nonpositive-Integer Nonnegative-Integer)
;                         (-> Zero Positive-Integer Negative-Integer)
;                         (-> Zero Nonnegative-Integer Nonpositive-Integer)
;                         (-> Zero Negative-Integer Positive-Integer)
;                         (-> Zero Nonpositive-Integer Nonnegative-Integer)
;                         (-> Positive-Exact-Rational Negative-Exact-Rational)
;                         (-> Nonnegative-Exact-Rational Nonpositive-Exact-Rational)
;                         (-> Negative-Exact-Rational Positive-Exact-Rational)
;                         (-> Nonpositive-Exact-Rational Nonnegative-Exact-Rational)
;                         (-> Zero Positive-Exact-Rational Negative-Exact-Rational)
;                         (-> Zero Nonnegative-Exact-Rational Nonpositive-Exact-Rational)
;                         (-> Zero Negative-Exact-Rational Positive-Exact-Rational)
;                         (-> Zero Nonpositive-Exact-Rational Nonnegative-Exact-Rational)
;                         (-> Positive-Flonum Negative-Flonum)
;                         (-> Nonnegative-Flonum Nonpositive-Flonum)
;                         (-> Negative-Flonum Positive-Flonum)
;                         (-> Nonpositive-Flonum Nonnegative-Flonum)
;                         (-> Zero Positive-Flonum Negative-Flonum)
;                         (-> Zero Nonnegative-Flonum Nonpositive-Flonum)
;                         (-> Zero Negative-Flonum Positive-Flonum)
;                         (-> Zero Nonpositive-Flonum Nonnegative-Flonum)
;                         (-> Positive-Single-Flonum Negative-Single-Flonum)
;                         (-> Nonnegative-Single-Flonum Nonpositive-Single-Flonum)
;                         (-> Negative-Single-Flonum Positive-Single-Flonum)
;                         (-> Nonpositive-Single-Flonum Nonnegative-Single-Flonum)
;                         (-> Zero Positive-Single-Flonum Negative-Single-Flonum)
;                         (-> Zero Nonnegative-Single-Flonum Nonpositive-Single-Flonum)
;                         (-> Zero Negative-Single-Flonum Positive-Single-Flonum)
;                         (-> Zero Nonpositive-Single-Flonum Nonnegative-Single-Flonum)
;                         (-> Positive-Inexact-Real Negative-Inexact-Real)
;                         (-> Nonnegative-Inexact-Real Nonpositive-Inexact-Real)
;                         (-> Negative-Inexact-Real Positive-Inexact-Real)
;                         (-> Nonpositive-Inexact-Real Nonnegative-Inexact-Real)
;                         (-> Zero Positive-Inexact-Real Negative-Inexact-Real)
;                         (-> Zero Nonnegative-Inexact-Real Nonpositive-Inexact-Real)
;                         (-> Zero Negative-Inexact-Real Positive-Inexact-Real)
;                         (-> Zero Nonpositive-Inexact-Real Nonnegative-Inexact-Real)
;                         (-> Positive-Real Negative-Real)
;                         (-> Nonnegative-Real Nonpositive-Real)
;                         (-> Negative-Real Positive-Real)
;                         (-> Nonpositive-Real Nonnegative-Real)
;                         (-> Zero Positive-Real Negative-Real)
;                         (-> Zero Nonnegative-Real Nonpositive-Real)
;                         (-> Zero Negative-Real Positive-Real)
;                         (-> Zero Nonpositive-Real Nonnegative-Real)
;                         (-> Number Zero Number)
;                         (-> One One Zero)
;                         (-> Positive-Byte One Byte)
;                         (-> Positive-Index One Index)
;                         (-> Positive-Fixnum One Nonnegative-Fixnum)
;                         (-> Positive-Integer One Nonnegative-Integer)
;                         (-> Nonnegative-Fixnum Nonnegative-Fixnum Fixnum)
;                         (-> Negative-Fixnum Nonpositive-Fixnum Fixnum)
;                         (-> Positive-Integer
;                             Nonpositive-Integer
;                             Nonpositive-Integer
;                             *
;                             Positive-Integer)
;                         (-> Nonnegative-Integer
;                             Nonpositive-Integer
;                             Nonpositive-Integer
;                             *
;                             Nonnegative-Integer)
;                         (-> Negative-Integer
;                             Nonnegative-Integer
;                             Nonnegative-Integer
;                             *
;                             Negative-Integer)
;                         (-> Nonpositive-Integer
;                             Nonnegative-Integer
;                             Nonnegative-Integer
;                             *
;                             Nonpositive-Integer)
;                         (-> Integer Integer * Integer)
;                         (-> Positive-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             *
;                             Positive-Exact-Rational)
;                         (-> Nonnegative-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             *
;                             Nonnegative-Exact-Rational)
;                         (-> Negative-Exact-Rational
;                             Nonnegative-Exact-Rational
;                             Nonnegative-Exact-Rational
;                             *
;                             Negative-Exact-Rational)
;                         (-> Nonpositive-Exact-Rational
;                             Nonnegative-Exact-Rational
;                             Nonnegative-Exact-Rational
;                             *
;                             Nonpositive-Exact-Rational)
;                         (-> Exact-Rational Exact-Rational * Exact-Rational)
;                         (-> Flonum Flonum * Flonum)
;                         (-> Flonum Real Real * Flonum)
;                         (-> Real Flonum Real * Flonum)
;                         (-> Real Real Flonum Real * Flonum)
;                         (-> Single-Flonum Single-Flonum * Single-Flonum)
;                         (-> Single-Flonum
;                             (U Exact-Rational Single-Flonum)
;                             (U Exact-Rational Single-Flonum)
;                             *
;                             Single-Flonum)
;                         (-> (U Exact-Rational Single-Flonum)
;                             Single-Flonum
;                             (U Exact-Rational Single-Flonum)
;                             *
;                             Single-Flonum)
;                         (-> (U Exact-Rational Single-Flonum)
;                             (U Exact-Rational Single-Flonum)
;                             Single-Flonum
;                             (U Exact-Rational Single-Flonum)
;                             *
;                             Single-Flonum)
;                         (-> Inexact-Real Inexact-Real * Inexact-Real)
;                         (-> Inexact-Real Real Real * Inexact-Real)
;                         (-> Real Inexact-Real Real * Inexact-Real)
;                         (-> Real Real Inexact-Real Real * Inexact-Real)
;                         (-> Real Real * Real)
;                         (-> Exact-Number Exact-Number * Exact-Number)
;                         (-> Float-Complex Float-Complex * Float-Complex)
;                         (-> Float-Complex Number Number * Float-Complex)
;                         (-> Number Float-Complex Number * Float-Complex)
;                         (-> Number Number Float-Complex Number * Float-Complex)
;                         (-> Single-Flonum-Complex Single-Flonum-Complex * Single-Flonum-Complex)
;                         (-> Single-Flonum-Complex
;                             (U Exact-Number Single-Flonum-Complex)
;                             (U Exact-Number Single-Flonum-Complex)
;                             *
;                             Single-Flonum-Complex)
;                         (-> (U Exact-Number Single-Flonum-Complex)
;                             Single-Flonum-Complex
;                             (U Exact-Number Single-Flonum-Complex)
;                             *
;                             Single-Flonum-Complex)
;                         (-> (U Exact-Number Single-Flonum-Complex)
;                             (U Exact-Number Single-Flonum-Complex)
;                             Single-Flonum-Complex
;                             (U Exact-Number Single-Flonum-Complex)
;                             *
;                             Single-Flonum-Complex)
;                         (-> Inexact-Complex Inexact-Complex * Inexact-Complex)
;                         (-> Inexact-Complex
;                             (U Exact-Number Inexact-Complex)
;                             (U Exact-Number Inexact-Complex)
;                             *
;                             Inexact-Complex)
;                         (-> (U Exact-Number Inexact-Complex)
;                             Inexact-Complex
;                             (U Exact-Number Inexact-Complex)
;                             *
;                             Inexact-Complex)
;                         (-> (U Exact-Number Inexact-Complex)
;                             (U Exact-Number Inexact-Complex)
;                             Inexact-Complex
;                             (U Exact-Number Inexact-Complex)
;                             *
;                             Inexact-Complex)
;                         (-> Number Number * Number)))
;         (Pair '* (case->
;                         (-> One)
;                         (-> Number Number)
;                         (-> Zero Number Number * Zero)
;                         (-> Number Zero Number * Zero)
;                         (-> Number Number Zero Number * Zero)
;                         (-> Number One Number)
;                         (-> One Number Number)
;                         (-> Positive-Byte Positive-Byte Positive-Index)
;                         (-> Byte Byte Index)
;                         (-> Positive-Byte Positive-Byte Positive-Byte Positive-Fixnum)
;                         (-> Byte Byte Byte Nonnegative-Fixnum)
;                         (-> Positive-Integer * Positive-Integer)
;                         (-> Nonnegative-Integer * Nonnegative-Integer)
;                         (-> Negative-Integer Negative-Integer)
;                         (-> Nonpositive-Integer Nonpositive-Integer)
;                         (-> Negative-Integer Negative-Integer Positive-Integer)
;                         (-> Negative-Integer Positive-Integer Negative-Integer)
;                         (-> Positive-Integer Negative-Integer Negative-Integer)
;                         (-> Nonpositive-Integer Nonpositive-Integer Nonnegative-Integer)
;                         (-> Nonpositive-Integer Nonnegative-Integer Nonpositive-Integer)
;                         (-> Nonnegative-Integer Nonpositive-Integer Nonpositive-Integer)
;                         (-> Negative-Integer Negative-Integer Negative-Integer Negative-Integer)
;                         (-> Nonpositive-Integer
;                             Nonpositive-Integer
;                             Nonpositive-Integer
;                             Nonpositive-Integer)
;                         (-> Integer * Integer)
;                         (-> Positive-Exact-Rational * Positive-Exact-Rational)
;                         (-> Nonnegative-Exact-Rational * Nonnegative-Exact-Rational)
;                         (-> Negative-Exact-Rational Negative-Exact-Rational)
;                         (-> Nonpositive-Exact-Rational Nonpositive-Exact-Rational)
;                         (-> Negative-Exact-Rational Negative-Exact-Rational Positive-Exact-Rational)
;                         (-> Negative-Exact-Rational Positive-Exact-Rational Negative-Exact-Rational)
;                         (-> Positive-Exact-Rational Negative-Exact-Rational Negative-Exact-Rational)
;                         (-> Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             Nonnegative-Exact-Rational)
;                         (-> Nonpositive-Exact-Rational
;                             Nonnegative-Exact-Rational
;                             Nonpositive-Exact-Rational)
;                         (-> Nonnegative-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational)
;                         (-> Negative-Exact-Rational
;                             Negative-Exact-Rational
;                             Negative-Exact-Rational
;                             Negative-Exact-Rational)
;                         (-> Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational)
;                         (-> Exact-Rational * Exact-Rational)
;                         (-> Flonum-Zero Flonum-Zero * Flonum-Zero)
;                         (-> Nonnegative-Flonum Nonnegative-Flonum * Nonnegative-Flonum)
;                         (-> Negative-Flonum Negative-Flonum Nonnegative-Flonum)
;                         (-> Negative-Flonum Negative-Flonum Negative-Flonum Nonpositive-Flonum)
;                         (-> Nonnegative-Flonum Positive-Real Positive-Real * Nonnegative-Flonum)
;                         (-> Positive-Real Nonnegative-Flonum Positive-Real * Nonnegative-Flonum)
;                         (-> Positive-Real
;                             Positive-Real
;                             Nonnegative-Flonum
;                             Positive-Real
;                             *
;                             Nonnegative-Flonum)
;                         (-> Flonum
;                             (U Negative-Real Positive-Real)
;                             (U Negative-Real Positive-Real)
;                             *
;                             Flonum)
;                         (-> (U Negative-Real Positive-Real)
;                             Flonum
;                             (U Negative-Real Positive-Real)
;                             *
;                             Flonum)
;                         (-> (U Negative-Real Positive-Real)
;                             (U Negative-Real Positive-Real)
;                             Flonum
;                             (U Negative-Real Positive-Real)
;                             *
;                             Flonum)
;                         (-> Flonum Flonum * Flonum)
;                         (-> Single-Flonum-Zero Single-Flonum-Zero * Single-Flonum-Zero)
;                         (-> Nonnegative-Single-Flonum
;                             Nonnegative-Single-Flonum
;                             *
;                             Nonnegative-Single-Flonum)
;                         (-> Negative-Single-Flonum Negative-Single-Flonum Nonnegative-Single-Flonum)
;                         (-> Negative-Single-Flonum
;                             Negative-Single-Flonum
;                             Negative-Single-Flonum
;                             Nonpositive-Single-Flonum)
;                         (-> Nonnegative-Single-Flonum
;                             (U Nonnegative-Single-Flonum Positive-Exact-Rational)
;                             (U Nonnegative-Single-Flonum Positive-Exact-Rational)
;                             *
;                             Nonnegative-Single-Flonum)
;                         (-> (U Nonnegative-Single-Flonum Positive-Exact-Rational)
;                             Nonnegative-Single-Flonum
;                             (U Nonnegative-Single-Flonum Positive-Exact-Rational)
;                             *
;                             Nonnegative-Single-Flonum)
;                         (-> (U Nonnegative-Single-Flonum Positive-Exact-Rational)
;                             (U Nonnegative-Single-Flonum Positive-Exact-Rational)
;                             Nonnegative-Single-Flonum
;                             (U Nonnegative-Single-Flonum Positive-Exact-Rational)
;                             *
;                             Nonnegative-Single-Flonum)
;                         (-> Single-Flonum
;                             (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             *
;                             Single-Flonum)
;                         (-> (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             Single-Flonum
;                             (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             *
;                             Single-Flonum)
;                         (-> (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             Single-Flonum
;                             (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             *
;                             Single-Flonum)
;                         (-> Single-Flonum Single-Flonum * Single-Flonum)
;                         (-> Inexact-Real-Zero Inexact-Real-Zero * Inexact-Real-Zero)
;                         (-> Nonnegative-Inexact-Real
;                             Nonnegative-Inexact-Real
;                             *
;                             Nonnegative-Inexact-Real)
;                         (-> Negative-Inexact-Real Negative-Inexact-Real Nonnegative-Inexact-Real)
;                         (-> Negative-Inexact-Real
;                             Negative-Inexact-Real
;                             Negative-Inexact-Real
;                             Nonpositive-Inexact-Real)
;                         (-> Nonnegative-Inexact-Real
;                             (U Inexact-Real-Zero Positive-Real)
;                             (U Inexact-Real-Zero Positive-Real)
;                             *
;                             Nonnegative-Inexact-Real)
;                         (-> (U Inexact-Real-Zero Positive-Real)
;                             Nonnegative-Inexact-Real
;                             (U Inexact-Real-Zero Positive-Real)
;                             *
;                             Nonnegative-Inexact-Real)
;                         (-> (U Inexact-Real-Zero Positive-Real)
;                             (U Inexact-Real-Zero Positive-Real)
;                             Nonnegative-Inexact-Real
;                             (U Inexact-Real-Zero Positive-Real)
;                             *
;                             Nonnegative-Inexact-Real)
;                         (-> Inexact-Real
;                             (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             *
;                             Inexact-Real)
;                         (-> (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             Inexact-Real
;                             (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             *
;                             Inexact-Real)
;                         (-> (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             Inexact-Real
;                             (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             *
;                             Inexact-Real)
;                         (-> Inexact-Real Inexact-Real * Inexact-Real)
;                         (-> Nonnegative-Real * Nonnegative-Real)
;                         (-> Nonpositive-Real Nonpositive-Real Nonnegative-Real)
;                         (-> Nonpositive-Real Nonnegative-Real Nonpositive-Real)
;                         (-> Nonnegative-Real Nonpositive-Real Nonpositive-Real)
;                         (-> Nonpositive-Real Nonpositive-Real Nonpositive-Real Nonpositive-Real)
;                         (-> Real * Real)
;                         (-> Float-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Float-Complex)
;                         (-> (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             Float-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Float-Complex)
;                         (-> (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             Float-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Float-Complex)
;                         (-> Single-Flonum-Complex
;                             (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             *
;                             Single-Flonum-Complex)
;                         (-> (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             Single-Flonum-Complex
;                             (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             *
;                             Single-Flonum-Complex)
;                         (-> (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             Single-Flonum-Complex
;                             (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             *
;                             Single-Flonum-Complex)
;                         (-> Inexact-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Inexact-Complex)
;                         (-> (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             Inexact-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Inexact-Complex)
;                         (-> (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             Inexact-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Inexact-Complex)
;                         (-> Number * Number)))
;         (Pair '/ (case->
;                         (-> Zero Number Number * Zero)
;                         (-> Number Zero Number * Zero)
;                         (-> Number Number Zero Number * Zero)
;                         (-> One One)
;                         (-> Number One Number)
;                         (-> Positive-Exact-Rational Positive-Exact-Rational * Positive-Exact-Rational)
;                         (-> Nonnegative-Exact-Rational
;                             Nonnegative-Exact-Rational
;                             *
;                             Nonnegative-Exact-Rational)
;                         (-> Negative-Exact-Rational Negative-Exact-Rational)
;                         (-> Nonpositive-Exact-Rational Nonpositive-Exact-Rational)
;                         (-> Negative-Exact-Rational Negative-Exact-Rational Positive-Exact-Rational)
;                         (-> Negative-Exact-Rational Positive-Exact-Rational Negative-Exact-Rational)
;                         (-> Positive-Exact-Rational Negative-Exact-Rational Negative-Exact-Rational)
;                         (-> Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             Nonnegative-Exact-Rational)
;                         (-> Nonpositive-Exact-Rational
;                             Nonnegative-Exact-Rational
;                             Nonpositive-Exact-Rational)
;                         (-> Nonnegative-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational)
;                         (-> Negative-Exact-Rational
;                             Negative-Exact-Rational
;                             Negative-Exact-Rational
;                             Negative-Exact-Rational)
;                         (-> Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational
;                             Nonpositive-Exact-Rational)
;                         (-> Exact-Rational Exact-Rational * Exact-Rational)
;                         (-> Flonum-Zero (U Negative-Float Positive-Float))
;                         (-> Negative-Flonum Negative-Flonum Nonnegative-Flonum)
;                         (-> Negative-Flonum Negative-Flonum Negative-Flonum Nonpositive-Flonum)
;                         (-> Positive-Flonum Positive-Real Positive-Real * Nonnegative-Flonum)
;                         (-> Positive-Real Positive-Flonum Positive-Real * Nonnegative-Flonum)
;                         (-> Positive-Real
;                             Positive-Real
;                             Positive-Flonum
;                             Positive-Real
;                             *
;                             Nonnegative-Flonum)
;                         (-> (U Float Negative-Real Positive-Real) Flonum Flonum * Flonum)
;                         (-> Flonum Real * Flonum)
;                         (-> Flonum Flonum * Flonum)
;                         (-> Single-Flonum-Zero (U Negative-Single-Flonum Positive-Single-Flonum))
;                         (-> Negative-Single-Flonum Negative-Single-Flonum Nonnegative-Single-Flonum)
;                         (-> Negative-Single-Flonum
;                             Negative-Single-Flonum
;                             Negative-Single-Flonum
;                             Nonpositive-Single-Flonum)
;                         (-> Positive-Single-Flonum
;                             (U Positive-Exact-Rational Positive-Single-Flonum)
;                             (U Positive-Exact-Rational Positive-Single-Flonum)
;                             *
;                             Nonnegative-Single-Flonum)
;                         (-> (U Positive-Exact-Rational Positive-Single-Flonum)
;                             Positive-Single-Flonum
;                             (U Positive-Exact-Rational Positive-Single-Flonum)
;                             *
;                             Nonnegative-Single-Flonum)
;                         (-> (U Positive-Exact-Rational Positive-Single-Flonum)
;                             (U Positive-Exact-Rational Positive-Single-Flonum)
;                             Positive-Single-Flonum
;                             (U Positive-Exact-Rational Positive-Single-Flonum)
;                             *
;                             Nonnegative-Single-Flonum)
;                         (-> Single-Flonum
;                             (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             *
;                             Single-Flonum)
;                         (-> (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             Single-Flonum
;                             (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             *
;                             Single-Flonum)
;                         (-> (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             Single-Flonum
;                             (U Negative-Exact-Rational Positive-Exact-Rational Single-Flonum)
;                             *
;                             Single-Flonum)
;                         (-> Single-Flonum Single-Flonum * Single-Flonum)
;                         (-> Inexact-Real-Zero (U Negative-Inexact-Real Positive-Inexact-Real))
;                         (-> Negative-Inexact-Real Negative-Inexact-Real Nonnegative-Inexact-Real)
;                         (-> Negative-Inexact-Real
;                             Negative-Inexact-Real
;                             Negative-Inexact-Real
;                             Nonpositive-Inexact-Real)
;                         (-> Positive-Inexact-Real
;                             Positive-Real
;                             Positive-Real
;                             *
;                             Nonnegative-Inexact-Real)
;                         (-> Positive-Real
;                             Positive-Inexact-Real
;                             Positive-Real
;                             *
;                             Nonnegative-Inexact-Real)
;                         (-> Positive-Real
;                             Positive-Real
;                             Positive-Inexact-Real
;                             Positive-Real
;                             *
;                             Nonnegative-Inexact-Real)
;                         (-> Inexact-Real
;                             (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             *
;                             Inexact-Real)
;                         (-> (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             Inexact-Real
;                             (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             *
;                             Inexact-Real)
;                         (-> (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             Inexact-Real
;                             (U Inexact-Real Negative-Exact-Rational Positive-Exact-Rational)
;                             *
;                             Inexact-Real)
;                         (-> Inexact-Real Inexact-Real * Inexact-Real)
;                         (-> Positive-Real Positive-Real * Nonnegative-Real)
;                         (-> Nonpositive-Real Nonpositive-Real)
;                         (-> Negative-Real Negative-Real Nonnegative-Real)
;                         (-> Negative-Real Positive-Real Nonpositive-Real)
;                         (-> Positive-Real Negative-Real Nonpositive-Real)
;                         (-> Negative-Real Negative-Real Negative-Real Nonpositive-Real)
;                         (-> Real Real * Real)
;                         (-> Float-Complex Float-Complex * Float-Complex)
;                         (-> Float-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Float-Complex)
;                         (-> (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             Float-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Float-Complex)
;                         (-> (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             Float-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Float-Complex)
;                         (-> Float-Complex Number * Float-Complex)
;                         (-> Single-Flonum-Complex Single-Flonum-Complex * Single-Flonum-Complex)
;                         (-> Single-Flonum-Complex
;                             (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             *
;                             Single-Flonum-Complex)
;                         (-> (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             Single-Flonum-Complex
;                             (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             *
;                             Single-Flonum-Complex)
;                         (-> (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             Single-Flonum-Complex
;                             (U Negative-Exact-Rational
;                                Positive-Exact-Rational
;                                Single-Flonum
;                                Single-Flonum-Complex)
;                             *
;                             Single-Flonum-Complex)
;                         (-> Inexact-Complex Inexact-Complex * Inexact-Complex)
;                         (-> Inexact-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Inexact-Complex)
;                         (-> (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             Inexact-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Inexact-Complex)
;                         (-> (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             Inexact-Complex
;                             (U Inexact-Complex
;                                Inexact-Real
;                                Negative-Exact-Rational
;                                Positive-Exact-Rational)
;                             *
;                             Inexact-Complex)
;                         (-> Number Number * Number)))
;         (Pair '< (case->
;                         (-> Integer One Boolean)
;                         (-> Real Zero Boolean)
;                         (-> Zero Real Boolean)
;                         (-> Real Real-Zero Boolean)
;                         (-> Real-Zero Real Boolean)
;                         (-> Byte Positive-Byte Boolean)
;                         (-> Byte Byte Boolean)
;                         (-> Positive-Integer Byte Boolean)
;                         (-> Positive-Real Byte Boolean)
;                         (-> Byte Positive-Integer Boolean)
;                         (-> Byte Positive-Exact-Rational Boolean)
;                         (-> Nonnegative-Integer Byte Boolean)
;                         (-> Nonnegative-Real Byte Boolean)
;                         (-> Byte Nonnegative-Integer Boolean)
;                         (-> Index Positive-Index Boolean)
;                         (-> Index Index Boolean)
;                         (-> Positive-Integer Index Boolean)
;                         (-> Positive-Real Index Boolean)
;                         (-> Index Positive-Integer Boolean)
;                         (-> Index Positive-Exact-Rational Boolean)
;                         (-> Nonnegative-Integer Index Boolean)
;                         (-> Nonnegative-Real Index Boolean)
;                         (-> Index Nonnegative-Integer Boolean)
;                         (-> Fixnum Positive-Integer Boolean)
;                         (-> Fixnum Positive-Exact-Rational Boolean)
;                         (-> Fixnum Nonnegative-Integer Boolean)
;                         (-> Fixnum Nonnegative-Exact-Rational Boolean)
;                         (-> Nonnegative-Integer Fixnum Boolean)
;                         (-> Nonnegative-Real Fixnum Boolean)
;                         (-> Fixnum Nonpositive-Integer Boolean)
;                         (-> Fixnum Nonpositive-Real Boolean)
;                         (-> Negative-Integer Fixnum Boolean)
;                         (-> Negative-Exact-Rational Fixnum Boolean)
;                         (-> Nonpositive-Integer Fixnum Boolean)
;                         (-> Nonpositive-Exact-Rational Fixnum Boolean)
;                         (-> Real +inf.0 Boolean)
;                         (-> -inf.0 Real Boolean)
;                         (-> +inf.0 Real Boolean)
;                         (-> Real -inf.0 Boolean)
;                         (-> Integer Zero Boolean)
;                         (-> Zero Integer Boolean)
;                         (-> Integer
;                             (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Boolean)
;                         (-> Integer
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Boolean)
;                         (-> Nonnegative-Real Integer Boolean)
;                         (-> Integer Nonpositive-Real Boolean)
;                         (-> (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Integer
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Integer
;                             Boolean)
;                         (-> Exact-Rational Zero Boolean)
;                         (-> Zero Exact-Rational Boolean)
;                         (-> Exact-Rational
;                             (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Boolean)
;                         (-> Exact-Rational
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Boolean)
;                         (-> Nonnegative-Real Exact-Rational Boolean)
;                         (-> Exact-Rational Nonpositive-Real Boolean)
;                         (-> (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Exact-Rational
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Exact-Rational
;                             Boolean)
;                         (-> Flonum
;                             (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Flonum
;                             Boolean)
;                         (-> Flonum
;                             (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Boolean)
;                         (-> Flonum
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Boolean)
;                         (-> Nonnegative-Real Flonum Boolean)
;                         (-> Flonum Nonpositive-Real Boolean)
;                         (-> (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Flonum
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Flonum
;                             Boolean)
;                         (-> Single-Flonum
;                             (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Single-Flonum
;                             Boolean)
;                         (-> Single-Flonum
;                             (U Positive-Exact-Rational
;                                Positive-Float)
;                             Boolean)
;                         (-> Single-Flonum
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float)
;                             Boolean)
;                         (-> Nonnegative-Real Single-Flonum Boolean)
;                         (-> Single-Flonum Nonpositive-Real Boolean)
;                         (-> (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Single-Flonum
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Single-Flonum
;                             Boolean)
;                         (-> Inexact-Real
;                             (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Inexact-Real
;                             Boolean)
;                         (-> Inexact-Real
;                             (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Boolean)
;                         (-> Inexact-Real
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Boolean)
;                         (-> Nonnegative-Real Inexact-Real Boolean)
;                         (-> Inexact-Real Nonpositive-Real Boolean)
;                         (-> (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Inexact-Real
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Inexact-Real
;                             Boolean)
;                         (-> Real
;                             (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Real
;                             Boolean)
;                         (-> Real
;                             (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Boolean)
;                         (-> Real
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Boolean)
;                         (-> Nonnegative-Real Real Boolean)
;                         (-> Real Nonpositive-Real Boolean)
;                         (-> (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Real
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Real
;                             Boolean)
;                         (-> Real Real Real * Boolean)))
;         (Pair '> (case->
;                         (-> One Integer Boolean)
;                         (-> Real Zero Boolean)
;                         (-> Zero Real Boolean)
;                         (-> Real Real-Zero Boolean)
;                         (-> Real-Zero Real Boolean)
;                         (-> Positive-Byte Byte Boolean)
;                         (-> Byte Byte Boolean)
;                         (-> Byte Positive-Integer Boolean)
;                         (-> Byte Positive-Real Boolean)
;                         (-> Positive-Integer Byte Boolean)
;                         (-> Positive-Exact-Rational Byte Boolean)
;                         (-> Byte Nonnegative-Integer Boolean)
;                         (-> Byte Nonnegative-Real Boolean)
;                         (-> Nonnegative-Integer Byte Boolean)
;                         (-> Positive-Index Index Boolean)
;                         (-> Index Index Boolean)
;                         (-> Index Positive-Integer Boolean)
;                         (-> Index Positive-Real Boolean)
;                         (-> Positive-Integer Index Boolean)
;                         (-> Positive-Exact-Rational Index Boolean)
;                         (-> Index Nonnegative-Integer Boolean)
;                         (-> Index Nonnegative-Real Boolean)
;                         (-> Nonnegative-Integer Index Boolean)
;                         (-> Positive-Integer Fixnum Boolean)
;                         (-> Positive-Exact-Rational Fixnum Boolean)
;                         (-> Nonnegative-Integer Fixnum Boolean)
;                         (-> Nonnegative-Exact-Rational Fixnum Boolean)
;                         (-> Fixnum Nonnegative-Integer Boolean)
;                         (-> Fixnum Nonnegative-Real Boolean)
;                         (-> Nonpositive-Integer Fixnum Boolean)
;                         (-> Nonpositive-Real Fixnum Boolean)
;                         (-> Fixnum Negative-Integer Boolean)
;                         (-> Fixnum Negative-Exact-Rational Boolean)
;                         (-> Fixnum Nonpositive-Integer Boolean)
;                         (-> Fixnum Nonpositive-Exact-Rational Boolean)
;                         (-> +inf.0 Real Boolean)
;                         (-> Real -inf.0 Boolean)
;                         (-> Real +inf.0 Boolean)
;                         (-> -inf.0 Real Boolean)
;                         (-> Integer Zero Boolean)
;                         (-> Zero Integer Boolean)
;                         (-> Integer Nonnegative-Real Boolean)
;                         (-> (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Integer
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Integer
;                             Boolean)
;                         (-> Nonpositive-Real Integer Boolean)
;                         (-> Integer
;                             (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Boolean)
;                         (-> Integer
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Boolean)
;                         (-> Exact-Rational Zero Boolean)
;                         (-> Zero Exact-Rational Boolean)
;                         (-> Exact-Rational Nonnegative-Real Boolean)
;                         (-> (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Exact-Rational
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Exact-Rational
;                             Boolean)
;                         (-> Nonpositive-Real Exact-Rational Boolean)
;                         (-> Exact-Rational
;                             (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Boolean)
;                         (-> Exact-Rational
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Boolean)
;                         (-> Flonum
;                             (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Flonum
;                             Boolean)
;                         (-> Flonum Nonnegative-Real Boolean)
;                         (-> (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Flonum
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Flonum
;                             Boolean)
;                         (-> Nonpositive-Real Flonum Boolean)
;                         (-> Flonum
;                             (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Boolean)
;                         (-> Flonum
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Boolean)
;                         (-> Single-Flonum
;                             (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Single-Flonum
;                             Boolean)
;                         (-> Single-Flonum Nonnegative-Real Boolean)
;                         (-> (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Single-Flonum
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Single-Flonum
;                             Boolean)
;                         (-> Nonpositive-Real Single-Flonum Boolean)
;                         (-> Single-Flonum
;                             (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Boolean)
;                         (-> Single-Flonum
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Boolean)
;                         (-> Inexact-Real
;                             (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Inexact-Real
;                             Boolean)
;                         (-> Inexact-Real Nonnegative-Real Boolean)
;                         (-> (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Inexact-Real
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Inexact-Real
;                             Boolean)
;                         (-> Nonpositive-Real Inexact-Real Boolean)
;                         (-> Inexact-Real
;                             (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Boolean)
;                         (-> Inexact-Real
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Boolean)
;                         (-> Real
;                             (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero Inexact-Real-Positive-Zero Zero)
;                             Real
;                             Boolean)
;                         (-> Real Nonnegative-Real Boolean)
;                         (-> (U Positive-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Real
;                             Boolean)
;                         (-> (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Nonnegative-Exact-Rational
;                                Positive-Float
;                                Positive-Single-Flonum)
;                             Real
;                             Boolean)
;                         (-> Nonpositive-Real Real Boolean)
;                         (-> Real
;                             (U Negative-Exact-Rational
;                                Negative-Float
;                                Negative-Single-Flonum)
;                             Boolean)
;                         (-> Real
;                             (U Inexact-Real-Negative-Zero
;                                Inexact-Real-Positive-Zero
;                                Negative-Float
;                                Negative-Single-Flonum
;                                Nonpositive-Exact-Rational)
;                             Boolean)
;                         (-> Real Real Real * Boolean)))))

(define primitive-procedures
  (list (cons 'car car)
        (cons 'cdr cdr)
        (cons 'cadr cadr)
        (cons 'cons cons)
        (cons 'append append)
        (cons 'list list)
        (cons 'caddr caddr)
        (cons 'ormap ormap)
        (cons 'andmap andmap)
        (cons 'eq? eq?)
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
        (cons 'remainder remainder)
        (cons 'quotient quotient)))

#| Extract all the identifiers of primitve-procedures. Thanks to dynamic type checking,
   I do not need to add f**king type annotations to map and car. |#
(define (primitive-procedure-names)
  (map car primitive-procedures))

#| Extract all the objects of primitive-procedures. RESP. |#
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cdr proc)))
       primitive-procedures))
