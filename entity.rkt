#lang racket
(provide (struct-out vec2)
         (struct-out entity)
         entity-x
         entity-y
         entity-velx
         entity-vely
         render-entity
         new-pos
         new-vel
         new-score
         collides-aabb)
(require sgl)


(struct vec2 (x y))
(struct entity (pos vel width height score))

(define (entity-x ent) (vec2-x (entity-pos ent)))
(define (entity-y ent) (vec2-y (entity-pos ent)))
(define (entity-velx ent) (vec2-x (entity-vel ent)))
(define (entity-vely ent) (vec2-y (entity-vel ent)))


; render-entity
;
;
(define (render-entity ent)
  (let ([x (entity-x ent)]
        [y (entity-y ent)]
        [w (entity-width ent)]
        [h (entity-height ent)])
    (gl-begin 'quads)
    (gl-vertex x y)
    (gl-vertex (+ x w) y)
    (gl-vertex (+ x w) (+ y h))
    (gl-vertex x (+ y h))
    (gl-end)))

; new-pos/new-vel
;
; Transform the entity by returning a struct-copy of `ent`
; with vector property pos or el set to (vec2 `x` `y`)
(define (new-pos ent x y)
  (struct-copy entity ent [pos (vec2 x y)]))
(define (new-vel ent x y)
  (struct-copy entity ent [vel (vec2 x y)]))
(define (new-score ent ns)
  (struct-copy entity ent [score ns]))

; collides-aabb
;
;
(define (collides-aabb p v)
  (and [> (+ (entity-x v) (entity-width v)) (entity-x p)]
       [> (+ (entity-y v) (entity-height v)) (entity-y p)]
       [> (+ (entity-x p) (entity-width p)) (entity-x v)]
       [> (+ (entity-y p) (entity-height p)) (entity-y v)]))
