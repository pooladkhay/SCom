(define all-tests '())

(define-syntax add-tests-with-string-output
  (syntax-rules (=>)
    [(_ test-name [expr => output-string] ...)
     (set! all-tests
        (cons 
           '(test-name [expr string  output-string] ...)
            all-tests))]))

(define (get-string)
  (with-output-to-string
    (lambda ()
      (with-input-from-file "program.out"
        (lambda ()
          (let f ()
            (let ([c (read-char)])
              (cond
               [(eof-object? c) (void)]
               [else (display c) (f)]))))))))

(define (test-with-string-output test-id expr expected-output)
   (run-compile expr)
   (build)
   (execute)
   (unless (string=? expected-output (get-string))
     (error 'test "output mismatch for test ~s, expected ~s, got ~s"
        test-id expected-output (get-string))))

(define (test-one test-id test)
  (let ([expr (car test)]
        [type (cadr test)]
        [out  (caddr test)])
    (printf "test ~s:~s ..." test-id expr)
    (flush-output-port)
    (case type
     [(string) (test-with-string-output test-id expr out)]
     [else (error 'test "invalid test type ~s" type)])
    (printf " ok\n")))
 
(define (test-all)
  (let f ([i 0] [ls (reverse all-tests)])
    (if (null? ls)
        (printf "passed all ~s tests\n" i)
        (let ([x (car ls)] [ls (cdr ls)])
          (let* ([test-name (car x)] 
                 [tests (cdr x)]
                 [n (length tests)])
            (printf "Performing ~a tests ...\n" test-name)
            (let g ([i i] [tests tests])
              (cond
                [(null? tests) (f i ls)]
                [else
                 (test-one i (car tests))
                 (g (add1 i) (cdr tests))])))))))

(define compile-port
  (make-parameter
    (current-output-port)
    (lambda (p)
       (unless (output-port? p) 
         (error 'compile-port "not an output port ~s" p))
       p)))

(define (run-compile expr)
  (let ((p (open-output-file "code.s" 'replace)))
    (parameterize ([compile-port p])
       (emit-assembly expr)) ; implemented by compiler.scm
    (close-output-port p)))

(define (build)
  (unless (fxzero? (system "gcc -o program runtime.c code.s"))
    (error 'make "could not build target")))

(define (execute)
  (unless (fxzero? (system "./program > program.out"))
    (error 'execute "produced program exited abnormally")))

(define (emit . args)
  (apply fprintf (compile-port) args)
  (newline (compile-port)))
