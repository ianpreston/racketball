#lang racket/gui
(require racket/class)
(require sgl)
(require sgl/gl-vectors)
(require "controls.rkt")
(require "game.rkt")


(define rb-canvas%
  (class canvas%
    (init setup)
    (init render)
    (init initial-state)
    (init update)
    (define glsetup setup)
    (define glrender render)
    (define gameupdate update)
    (define state initial-state)
    (define ctrls (controls #f #f))

    (inherit refresh with-gl-context swap-gl-buffers)
    (super-new)

    (define/public (step)
      (set! state (gameupdate state ctrls))
      (refresh)
      (sleep/yield 0.01)
      (queue-callback (lambda () (send this step)) #f))

    (define/public (startup)
      (with-gl-context
        (lambda ()
          (glsetup))))

    (define/override (on-paint)
      (with-gl-context
        (lambda ()
          (glrender state)
          (swap-gl-buffers)
          (gl-flush)
          )))
    
    (define/override (on-char e)
      (let ([kc (send e get-key-code)])
        (set! ctrls
              (cond
                [(equal? kc #\w) (struct-copy controls ctrls [w #t])]
                [(equal? kc #\s) (struct-copy controls ctrls [s #t])]
                [(equal? kc 'release) (controls #f #f)]
                [else ctrls]))))))
 
(define frame (new frame%
                   [style '(no-resize-border
                            no-caption
                            no-system-menu
                            hide-menu-bar)]
                   [label "racketball"]
                   [width 800]
                   [height 800]))

(define cvs (new rb-canvas% [setup rb-setup]
                            [render rb-render]
                            [initial-state (rb-initial-state)]
                            [update rb-update]
                            [parent frame]
                            [style '(gl)]))

(send frame show #t)
(send frame center 'both)
(send cvs startup) 
(send cvs step)
