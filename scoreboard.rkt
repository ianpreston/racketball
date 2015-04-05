#lang racket
(provide render-score-for)
(require racket/draw)
(require sgl)
(require sgl/bitmap)
(require "entity.rkt")


; Maps score values (integers) to OpenGL display lists
(define list-cache (hash))

; render-score-for
;
; Display a score counter for `entity` at the given X-axis offset
(define (render-score-for ent x-offset)
  (let ([val (entity-score ent)])
    (set! list-cache (ensure-cached val))
    (render-score (hash-ref list-cache val) x-offset)))

(define (ensure-cached val)
  (if (hash-has-key? list-cache val)
      list-cache
      (hash-set list-cache val (make-score val))))

(define (make-score val)
 (let* ([target (make-bitmap 64 64)]
        [dc (new bitmap-dc% (bitmap target))])
    (send dc set-background "black")
    (send dc clear)
    (send dc set-text-foreground "white")
    (send dc set-scale 4 4)
    (send dc draw-text (number->string val) 0 0)
    (bitmap->gl-list target)))

(define (render-score score-list x-offset)
    (gl-push-matrix)
    (gl-translate x-offset 95.0 0.1)
    (gl-rotate 180.0 1.0 0.0 0.0)
    (gl-scale 8.0 8.0 0.0)
    (gl-call-list score-list)
    (gl-pop-matrix))
