(load "./immediate.scm")
(load "./primitive.scm")
(load "./primitive-defs.scm")

; Tests
(load "./tests/tests-driver.scm")
(load "./tests/tests-1.1-req.scm")
(load "./tests/tests-1.2-req.scm")
(load "./tests/tests-1.3-req.scm")

(define (emit-expr expr)
    (cond
        [(immediate? expr) (emit-immediate expr)]
        [(primcall? expr) (emit-primcall expr)]
        [else (error 'emit-expr "not immediate nor primitive")]))

(define (emit-assembly expr)
    (emit "  .text")
    (emit "  .globl scheme_entry")
    (emit "  .type scheme_entry, @function")
    (emit "scheme_entry:")
    (emit-expr expr)
    (emit "  ret")
    ;; Fixes linker error: missing .note.GNU-stack section implies executable stack
    (emit "  .section	.note.GNU-stack,\"\",@progbits"))
