
(define (domain simple)
    (:requirements :strips :typing :adl)

    (:types 
        location - object
        stackable - object
        robot package shelf - stackable
    )

    (:predicates
       
        (on ?p - package ?s - stackable) #un paquet esta sobre d'algun objecte stackable
        (clear ?s - stackable) #la pila esta buida
        (at ?r - robot ?l - location) #on es troba el robot
        (shelf-at ?s - shelf ?l - location) #on es troba l'estanteria
        (location-accessible ?l1 - location ?l2 - location) #si pot arribar
        (is-dispenser ?l - location) #es un dispensador
        (is-shelf ?l - location) #es una estanteria
        (occupied ?l - location) #hi ha un robot
        (dispensed ?p - package) #el paquet es troba al dispensador
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
        (clear ?p) (on ?p ?below) (clear ?rtop))
        :effect (and (on ?p ?rtop) (not (clear ?rtop)) (not (on ?p ?below)) (clear ?below)
         )
    )

    (:action put-down
        :parameters (?r - robot ?p - package ?rlocation - location ?s - shelf ?slocation - location ?top - stackable ?below - stackable)
        :precondition (and (at ?r ?rlocation) (shelf-at ?s ?slocation) (location-accessible ?rlocation ?slocation) 
        (clear ?top) (on ?p ?below) (clear ?p)
        )
        :effect (and (not (on ?p ?below)) (on ?p ?top) (not (clear ?top)) (clear ?below) )
    )
    
    (:action dispense
        :parameters ()
        :precondition (and )
        :effect (and )
    )
    
    


)