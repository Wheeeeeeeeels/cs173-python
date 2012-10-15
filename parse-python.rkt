#lang racket

(require "autogrammar/examples/python-grammar.rkt"
         "python-tokenizer/main.rkt"
         racket/generator
         parser-tools/lex
         racket/match)

(define (tokenize/1 ip)
  (default-lex/1 ip))

(define (adapt-python-tokenizer ip)
  (define tokens (sequence->generator (generate-tokens ip)))
  (lambda ()
    (let loop ()
      (define next-token (tokens))
      (match next-token
        [(list type text (list start-line start-col) (list end-line end-col) rest-string)
         ;; FIXME: improve the Python tokenizer to hold offsets too.
         (define start-pos (position #f start-line start-col))
         (define end-pos (position #f end-line end-col))
         (position-token (case type
                           [(NAME) 
                            (cond [(hash-has-key? all-tokens-hash (string->symbol text))
                                   ((hash-ref all-tokens-hash (string->symbol text)) text)]
                                  [else
                                   (token-NAME text)])]
                           [(OP)
                            ((hash-ref all-tokens-hash (string->symbol text)) text)]
                           [(NUMBER) 
                            (token-NUMBER text)]
                           [(STRING) 
                            (token-STRING text)]
                           [(COMMENT) 
                            (loop)]
                           [(NL NEWLINE)
                            (token-NEWLINE text)]
                           [(DEDENT) 
                            (token-DEDENT text)]
                           [(INDENT)
                            (token-INDENT text)]
                           [(ERRORTOKEN)
                            (error 'uh-oh)]
                           [(ENDMARKER) 
                            (token-ENDMARKER text)])
                         start-pos
                         end-pos)]
        [(? void)
         (token-EOF eof)]))))
  


(define (parse-python/string name s)
  (parse-python/port name (open-input-string s)))

(define (parse-python/port name port)
  (syntax->datum (parse name (adapt-python-tokenizer port))))

(provide parse-python/port parse-python/string)
