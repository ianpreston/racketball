#lang racket
(provide bounce
         ricochet
         follow
         kbcontrol
         inertia
         respawn-if
         score-if)
(require "entity.rkt")
(require "controls.rkt")


; bounce
;
; Entity bounces off the walls on the Y-axis
(define (bounce ent)
  (if (or (> (entity-y ent) 100)
          (< (entity-y ent) 0))
    (new-vel ent
             (entity-velx ent)
             (* -1 (entity-vely ent)))
    ent))

; ricochet
;
; Entity bounces off of `target` on the X-axis
(define (ricochet ent target)
  (if (collides-aabb ent target)
    (new-vel ent
             (* -1 (entity-velx ent))
             (entity-vely ent))
    ent))

; follow
;
; Entity's `vel` is updated to move towards `target` on the Y-axis
(define (follow ent target)
  (new-vel
   ent
   0
   (cond [(> (entity-y target) (entity-y ent)) 1]
         [(< (entity-y target) (entity-y ent)) -1]
         [else 0])))

; kbcontrol
;
; Entity's `vel` is updated to move along the Y-axis according to
; keyboard input specified as `ctrls`
(define (kbcontrol ent ctrls)
  (new-vel
   ent
   (entity-velx ent)
   (cond [(controls-w ctrls) 2]
         [(controls-s ctrls) -2]
         [else 0])))

; respawn-if
; 
; Entity respawns (is replaced by the result of `new-ent`) if
; (`cnd` `ent`) evaluates true
(define (respawn-if ent cnd new-ent)
  (if (cnd ent) (new-ent) ent))

; score-if
;
; Entity's score is incremented if `cnd` is true
(define (score-if ent cnd)
  (if cnd (new-score ent (+ (entity-score ent) 1))
          ent))

; inertia
;
; Entity's `pos` is updated according to its `vel`
(define (inertia ent)
  (new-pos ent
           (+ (entity-x ent) (entity-velx ent))
           (+ (entity-y ent) (entity-vely ent))))
