
(define (domain simpleOrdered)
    (:requirements :strips :typing :adl)

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
        (occupied ?l - location) ;hi ha un robot
        (dispensed ?p - package) ;el paquet es troba al dispensador
        (next-to-dispense ?p - package) ;el seguent paquet a dispensar
        (dispense-order ?p1 - package ?p2 - package) ;ordre de paquets a dispensar
    )

    (:action move
        :parameters (?r - robot ?from - location ?to - location)
        :precondition (and (location-accessible ?from ?to) (at ?r ?from) (not (is-dispenser ?to)) 
         (not (is-shelf ?to))(not (occupied ?to))
         )
        :effect (and (occupied ?to) (not (occupied ?from)) (at ?r ?to) (not (at ?r ?from)) 
        )
    )

    (:action pick-up
        :parameters (?r - robot ?p - package ?below - stackable ?rtop - stackable ?rlocation - location ?s - shelf ?slocation - location)
        :precondition (and  (at ?r ?rlocation) (shelf-at ?s ?slocation) (location-accessible ?rlocation ?slocation) 
        (clear ?p) (on ?p ?below) (or (= ?rtop ?r) (on ?rtop ?r)) (clear ?rtop) (on-shelf ?p ?s))
        :effect (and (on ?p ?rtop) (not (clear ?rtop)) (not (on ?p ?below)) (clear ?below) (not (on-shelf ?p ?s))
         )
    )

    (:action put-down
        :parameters (?r - robot ?p - package ?rlocation - location ?s - shelf ?slocation - location ?top - stackable ?below - stackable)
        :precondition (and (at ?r ?rlocation) (shelf-at ?s ?slocation) (location-accessible ?rlocation ?slocation) 
        (clear ?top) (on ?p ?below) (clear ?p) (or (= ?below ?r) (on ?below ?r)) (or (= ?top ?s) (on-shelf ?top ?s)) 
        )
        :effect (and (not (on ?p ?below)) (on ?p ?top) (not (clear ?top)) (clear ?below) (on-shelf ?p ?s)  )
    )
    
    (:action dispense
        :parameters (?r - robot ?p - package ?rlocation - location ?d - location ?below - stackable)
        :precondition (and (at ?r ?rlocation) (is-dispenser ?d) (location-accessible ?rlocation ?d) (clear ?p) (on ?p ?below) (or (= ?below ?r) (on ?below ?r)) (next-to-dispense ?p) )
        :effect (and (dispensed ?p) (clear ?below) (not (on ?p ?below)) (not (next-to-dispense ?p)) (forall (?pNext - package) (when (dispense-order ?p ?pNext) (next-to-dispense ?pNext)) )
        )
    )
)