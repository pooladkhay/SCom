(define char-shift 8)
(define char-tag #x0F)   ;; #b00001111
(define char-mask #xFF)  ;; #b11111111

(define fx-shift 2)
(define fx-tag #x00)     ;; #b00000000
(define fx-mask #x03)    ;; #b00000011

(define bool-f #x2F)     ;; #b00101111
(define bool-t #x6F)     ;; #b01101111
(define bool-mask #xBC)  ;; #b10111100
(define bool-bit 6)      ;; number of similar bits in bool-t and bool-f

(define empty-list #x3F) ;; #b00111111
(define wordsize 4)      ;; bytes

(define fx-bits (- (* wordsize 8) fx-shift))
(define fx-lower (- (expt 2 (- fx-bits 1))))
(define fx-upper (- (expt 2 (- fx-bits 1)) 1))

(define (fx? x)
    (and (integer? x) (exact? x) (<= fx-lower x fx-upper)))

(define (rep-fx x)
    (ash x fx-shift))

(define (rep-bool x)
    (if (boolean=? x #t)
        bool-t
        bool-f))

(define (rep-char x)
    (bitwise-ior (ash (char->integer x) char-shift) char-tag))

(define (immediate? x)
    (or (fx? x) (boolean? x) (char? x) (null? x)))

(define (rep-immediate x)
    (cond
        [(fx? x) (rep-fx x)]
        [(boolean? x) (rep-bool x)]
        [(null? x) empty-list]
        [(char? x) (rep-char x)]))

(define (emit-immediate x)
    (emit "  movl $~s, %eax" (rep-immediate x)))
