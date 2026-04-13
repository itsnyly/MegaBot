
(define (domain avancat)
    (:requirements :strips :typing :adl :numeric-fluents)

    (:types 
        location - object
        stackable - object
        robot package shelf - stackable
    )

    (:predicates
       
        (on ?p - package ?s - stackable) ;un paquet esta sobre d'algun objecte stackable
        (clear ?s - stackable) ;la pila esta buida
        (at ?r - robot ?l - location) ;on es troba el robot
        (on-shelf ?p - package ?s - shelf) ;un paquet esta sobre una estanteria
        (shelf-at ?s - shelf ?l - location) ;on es troba l'estanteria
        (location-accessible ?l1 - location ?l2 - location) ;si pot arribar
        (is-dispenser ?l - location) ;es un dispensador
        (is-shelf ?l - location) ;es una estanteria
        (is-charger ?l - location) ;es un cargador
        (occupied ?l - location) ;hi ha un robot
        (dispensed ?p - package) ;el paquet es troba al dispensador
    )

    (:functions
        (battery ?r - robot) ;nivell de bateria del robot
        (max-battery ?r - robot) ;capacitat maxima de bateria del robot
        (weight ?p - package) ;pes del paquet
        (current-load ?r - robot) ;pes total que porta el robot
        (max-load ?r - robot) ;capacitat maxima de càrrega
        (total-energy-used) ;metrica a minimitzar
    )

    (:action move
        :parameters (?r - robot ?from - location ?to - location)
        :precondition (and (location-accessible ?from ?to) (at ?r ?from) (not (is-dispenser ?to)) 
         (not (is-shelf ?to))(not (occupied ?to)) (or (and (< (current-load ?r) 5) (>= (battery ?r) 2)) (and (>= (current-load ?r) 5) (>= (battery ?r) 3))
         ))
        :effect (and (occupied ?to) (not (occupied ?from)) (at ?r ?to) (not (at ?r ?from)) 
            (when (< (current-load ?r) 5) (and (decrease (battery ?r) 2) (increase (total-energy-used) 2)))
            (when (>= (current-load ?r) 5) (and (decrease (battery ?r) 3) (increase (total-energy-used) 3)))
        )
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
    
    (:action dispense
        :parameters (?r - robot ?p - package ?rlocation - location ?d - location ?below - stackable)
        :precondition (and (at ?r ?rlocation) (is-dispenser ?d) (location-accessible ?rlocation ?d) (clear ?p) (on ?p ?below) (or (= ?below ?r) (on ?below ?r)) )
        :effect (and (dispensed ?p) (clear ?below) (not (on ?p ?below)) )
    )
)