#lang racket
(provide rb-setup rb-render rb-update rb-initial-state)
(require sgl)
(require "entity.rkt")
(require "mechanics.rkt")


(define (rb-initial-state)
  (list
    ; Ball
    (entity (vec2 0 0) (vec2 1 1) 2 2)
    ; Player
    (entity (vec2 7 40) (vec2 0 0) 2 10)
    ; Enemy
    (entity (vec2 92 90) (vec2 0 0) 2 10)))

(define (rb-setup)
  (gl-matrix-mode 'projection)
  (gl-load-identity)
  (gl-ortho 0 100 0 100 -1 1))

(define (rb-render state)
  (gl-clear-color 0.0 0.0 0.0 0.0)
  (gl-clear 'color-buffer-bit 'depth-buffer-bit)
  (for-each render-entity state))

(define (rb-update state ctrls)
  (match-define (list ball player enemy) state)

  (define ball-mechanics
    (compose inertia
             bounce
             (curryr ricochet player)
             (curryr ricochet enemy)))
  (define player-mechanics
    (compose inertia
             (curryr kbcontrol ctrls)))
  (define enemy-mechanics
    (compose inertia
             (curryr follow ball)))

  (list (ball-mechanics ball) (player-mechanics player) (enemy-mechanics enemy)))
