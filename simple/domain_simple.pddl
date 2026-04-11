
(define (domain simple)
    (:requirements :strips :typing)

    (:types 
        robot package location - object
    )

    (:predicates
        (at ?r - robot ?l - location) #on es troba el robot
        (package-at ?p - package ?l - location) #on es troba el paquet
        (package-top ?p1 - package ?p2 - package) #si el paquet p1 està sobre el paquet p2
        (location-accessible ?l1 - location ?l2 - location) #si es pot anar de l1 a l2
        (is-shelf ?l - location) #si és una estanteria
        (is-dispenser ?l - location) #si es un dispensador
        (package-top-shelf ?l - location ?p - package) #quin paquet es troba al cim de l'estanteria
        (package-top-robot ?r - robot ?p - package) #quin paquet es troba al cim del robot
        (dispensed ?p - package) #si el paquet es troba al dispensador
        (package-clear ?p - package) #si el paquet no te res a sobre
        (robot-clear ?r - robot) #si el robot no te res a sobre
        (occupied ?l - location) #si la casella està ocupada per un robot
    )

    (:action move
        :parameters (?r - robot ?from - location ?to - location)
        :precondition (and (location-accessible ?from ?to) (not (is-shelf ?to)) (not (is-dispenser ?to)) 
         (not (occupied ?to))
         )
        :effect (and (occupied ?to) (not (occupied ?from)) (at ?r ?to) (not (at ?r ?from)) 
        )
    )
    


)