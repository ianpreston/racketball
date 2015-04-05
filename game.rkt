#lang racket
(provide rb-setup rb-render rb-update rb-initial-state)
(require sgl)
(require "entity.rkt")
(require "mechanics.rkt")


(define (create-ball)
  (entity (vec2 50 50) (vec2 1 1) 2 2 0))

(define (create-player)
  (entity (vec2 7 40) (vec2 0 0) 2 10 0))

(define (create-enemy)
 (entity (vec2 92 90) (vec2 0 0) 2 10 0))

(define (rb-initial-state)
  (list (create-ball)
        (create-player)
        (create-enemy)))

(define (rb-update state ctrls)
  (match-define (list ball player enemy) state)

  (define (off-left ent) (< (entity-x ent) 0))
  (define (off-right ent) (> (entity-x ent) 100))

  (define ball-mechanics
    (compose inertia
             bounce
             (curryr ricochet player)
             (curryr ricochet enemy)
             (curryr respawn-if
                     (lambda (e) (or (off-left e) (off-right e)))
                     create-ball)))

  (define player-mechanics
    (compose inertia
             (curryr kbcontrol ctrls)
             (curryr score-if (curry off-right ball))))

  (define enemy-mechanics
    (compose inertia
             (curryr follow ball)
             (curryr score-if (curry off-left ball))))

  (list (ball-mechanics ball) (player-mechanics player) (enemy-mechanics enemy)))

(define (rb-setup)
  (gl-matrix-mode 'projection)
  (gl-load-identity)
  (gl-ortho 0 100 0 100 -1.0 0.0)
  (gl-matrix-mode 'modelview)
  (gl-load-identity)
  (gl-enable 'depth-test))

(define (rb-render state)
  (gl-clear-color 0.0 0.0 0.0 0.0)
  (gl-clear 'color-buffer-bit 'depth-buffer-bit)
  (for-each render-entity state))
