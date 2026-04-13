(define (domain avancat_ordered)
    (:requirements :strips :typing :adl :numeric-fluents)

    (:types 
        location - object
        stackable - object
        robot package shelf - stackable
    )

    (:predicates
        (on ?p - package ?s - stackable)
        (clear ?s - stackable)
        (at ?r - robot ?l - location)
        (on-shelf ?p - package ?s - shelf)
        (shelf-at ?s - shelf ?l - location)
        (location-accessible ?l1 - location ?l2 - location)
        (is-dispenser ?l - location)
        (is-shelf ?l - location)
        (is-charger ?l - location)
        (occupied ?l - location)
        (dispensed ?p - package)
        ;; Predicats d'ordre
        (next-to-dispense ?p - package)
        (dispense-order ?p1 - package ?p2 - package)
    )

    (:functions
        (battery ?r - robot)
        (max-battery ?r - robot)
        (weight ?p - package)
        (current-load ?r - robot)
        (max-load ?r - robot)
        (total-energy-used)
    )

    (:action move
        :parameters (?r - robot ?from - location ?to - location)
        :precondition (and (at ?r ?from) (location-accessible ?from ?to) (not (occupied ?to))
                           (not (is-shelf ?to)) (not (is-dispenser ?to))
                           (or (and (< (current-load ?r) 5) (>= (battery ?r) 2))
                               (and (>= (current-load ?r) 5) (>= (battery ?r) 3))))
        :effect (and (not (at ?r ?from)) (at ?r ?to) (not (occupied ?from)) (occupied ?to)
                     (when (< (current-load ?r) 5) 
                           (and (decrease (battery ?r) 2) (increase (total-energy-used) 2)))
                     (when (>= (current-load ?r) 5) 
                           (and (decrease (battery ?r) 3) (increase (total-energy-used) 3))))
    )

    ;; Acció de dispensar amb control d'ordre
    (:action dispense
        :parameters (?r - robot ?p - package ?rloc - location ?dloc - location ?below - stackable)
        :precondition (and (at ?r ?rloc) (is-dispenser ?dloc) (location-accessible ?rloc ?dloc)
                           (on ?p ?below) (clear ?p) (next-to-dispense ?p)
                           (or (= ?below ?r) (on ?below ?r)))
        :effect (and (dispensed ?p) (not (on ?p ?below)) (clear ?below)
                     (decrease (current-load ?r) (weight ?p))
                     (not (next-to-dispense ?p))
                     (forall (?pNext - package) 
                         (when (dispense-order ?p ?pNext) (next-to-dispense ?pNext))))
    )

    (:action pick-up
        :parameters (?r - robot ?p - package ?below - stackable ?rtop - stackable ?rlocation - location ?s - shelf ?slocation - location)
        :precondition (and  (at ?r ?rlocation) (shelf-at ?s ?slocation) (location-accessible ?rlocation ?slocation) 
        (clear ?p) (on ?p ?below) (or (= ?rtop ?r) (on ?rtop ?r)) (clear ?rtop) (on-shelf ?p ?s) (<= (+ (current-load ?r) (weight ?p)) (max-load ?r))) 
        :effect (and (on ?p ?rtop) (not (clear ?rtop)) (not (on ?p ?below)) (clear ?below) (not (on-shelf ?p ?s)) 
            (increase (current-load ?r) (weight ?p))
        )
    )

    (:action put-down
        :parameters (?r - robot ?p - package ?rlocation - location ?s - shelf ?slocation - location ?top - stackable ?below - stackable)
        :precondition (and (at ?r ?rlocation) (shelf-at ?s ?slocation) (location-accessible ?rlocation ?slocation) 
        (clear ?top) (on ?p ?below) (clear ?p) (or (= ?below ?r) (on ?below ?r)) (or (= ?top ?s) (on-shelf ?top ?s)) 
        )
        :effect (and (not (on ?p ?below)) (on ?p ?top) (not (clear ?top)) (clear ?below) (on-shelf ?p ?s) 
            (decrease (current-load ?r) (weight ?p))
          )
    )

    (:action recharge
        :parameters (?r - robot ?rlocation - location ?c - location)
        :precondition (and (at ?r ?rlocation) (is-charger ?c) (location-accessible ?rlocation ?c) (< (battery ?r) (max-battery ?r)))
        :effect (and (when (<= (+ (battery ?r) 20 ) (max-battery ?r)) (increase (battery ?r) 20)) 
            (when (> (+ (battery ?r) 20 ) (max-battery ?r)) (assign (battery ?r) (max-battery ?r)))
        )
    )
)