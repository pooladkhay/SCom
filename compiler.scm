(load "./tests/tests-driver.scm")
(load "./tests/tests-1.1-req.scm")

(define (emit-assembly x)
  (unless (integer? x) (error 'emit-program "not an integer"))
  (emit "  .text")
  (emit "  .globl scheme_entry")
  (emit "  .type scheme_entry, @function")
  (emit "scheme_entry:")
  (emit "  movl $~s, %eax" x)
  (emit "  ret")
  ;; Fixes linker error: missing .note.GNU-stack section implies executable stack
  (emit "  .section	.note.GNU-stack,\"\",@progbits"))
