(define-syntax define-primitive
    (syntax-rules ()
        [(_ (prim-name arg* ...) b b* ...)
            (begin
                (putprop 'prim-name '*is-prim* #t)
                (putprop 'prim-name '*arg-count*
                    (length '(arg* ...)))
                (putprop 'prim-name '*emitter*
                    (lambda (arg* ...) b b* ...)))]))

(define (primitive? x)
    (and (symbol? x) (getprop x '*is-prim*)))

(define (primitive-emitter x)
    (or (getprop x '*emitter*) (error 'primitive-emitter "error getting emitter")))

(define (primcall? expr)
    (and (pair? expr) (primitive? (car expr))))

(define (emit-primcall expr)
    (let ([prim (car expr)] [args (cdr expr)])
        (check-primcall-args prim args)
        (apply (primitive-emitter prim) args)))

(define (check-primcall-args prim args)
    (or (= 1 (getprop prim '*arg-count*)) (error 'check-primcall-args "number of args should be 1")))
