(define (problem pb_simplea) 
    (:domain simple)
    (:objects pkg1 pkg2 pkg3 - package
              E1 E2 - shelf
              c11 c12 c13 c14 c15 - location
              c21 c22 c25 - location
              c31 c33 c35 - location
              c41 c43 c44 c45 - location
              c51 c52 c53 c54 c55 c56 - location
              c61 c63 c66 - location
              R1 R2 - robot
    )

    (:init
    ;posicio inicial robots
        (at R1 c61) 
        (at R2 c55)
    ;associacio estanteria - casella
        (shelf-at E1 c22)
        (shelf-at E2 c25)
    ;a sobre de que esta cada paquet
        (on pkg2 E1)
        (on pkg1 pkg2)
        (on pkg3 E2)
    ;associacio paquet - estanteria
        (on-shelf pkg1 E1)
        (on-shelf pkg2 E1)
        (on-shelf pkg3 E2)
    ;cims lliures
        (clear pkg1)
        (clear pkg3)
        (clear R1)
        (clear R2)
    ;caselles ocupades per robots
        (occupied c61)
        (occupied c55)
    ; estanteries i dispensador
        (is-shelf c22)
        (is-shelf c25)
        (is-dispenser c44)
    ;accessibilitat entre caselles
        (location-accessible c11 c12)
        (location-accessible c11 c21)
        (location-accessible c12 c11)
        (location-accessible c12 c13)
        (location-accessible c12 c22)
        (location-accessible c13 c12)
        (location-accessible c13 c14)
        (location-accessible c14 c13)
        (location-accessible c14 c15)
        (location-accessible c15 c14)
        (location-accessible c15 c25)
        (location-accessible c21 c22)
        (location-accessible c21 c11)
        (location-accessible c21 c31)
        (location-accessible c31 c21)
        (location-accessible c31 c41)
        (location-accessible c33 c43)
        (location-accessible c35 c45)
        (location-accessible c35 c25)
        (location-accessible c41 c31)
        (location-accessible c41 c51)
        (location-accessible c43 c33)
        (location-accessible c43 c53)
        (location-accessible c43 c44)
        (location-accessible c45 c44)
        (location-accessible c45 c55)
        (location-accessible c45 c35)
        (location-accessible c51 c41)
        (location-accessible c51 c52)
        (location-accessible c51 c61)
        (location-accessible c52 c51)
        (location-accessible c52 c53)
        (location-accessible c53 c43)
        (location-accessible c53 c54)
        (location-accessible c53 c63)
        (location-accessible c54 c53)
        (location-accessible c54 c55)
        (location-accessible c54 c44)
        (location-accessible c55 c45)
        (location-accessible c55 c56)
        (location-accessible c55 c54)
        (location-accessible c56 c55)
        (location-accessible c56 c66)
        (location-accessible c61 c51)
        (location-accessible c63 c53)
        (location-accessible c66 c56)

    )

    (:goal (and
        (dispensed pkg1)
        (dispensed pkg2)
        (dispensed pkg3)
    ))


)
