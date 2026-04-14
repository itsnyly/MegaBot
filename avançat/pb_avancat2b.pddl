(define (problem pb_avancat2b) 
    (:domain avancat_ordered)
    (:objects pkg1 pkg2 pkg3 pkg4 pkg5 pkg6 - package
              E1 E2 - shelf
              c11 c12 c13 c14 c15 c16 - location
              c21 c24 c25 c26 - location
              c31 c32 c36 - location
              c42 c44 c45 c46 - location
              c51 c52 c53 c54 c55 c56 - location
              R1 R2 - robot
    )

    (:init
    ; posicio inicial robots
        (at R1 c13) 
        (at R2 c44)
        
    ; associacio estanteria - casella
        (shelf-at E1 c24)
        (shelf-at E2 c46)
        
    ; a sobre de que esta cada paquet (Pila E1)
        (on pkg1 E1)
        (on pkg2 pkg1)
        (on pkg3 pkg2)
        (on pkg4 pkg3)
        
    ; a sobre de que esta cada paquet (Pila E2)
        (on pkg5 E2)
        (on pkg6 pkg5)
        
    ; associacio paquet - estanteria
        (on-shelf pkg1 E1)
        (on-shelf pkg2 E1)
        (on-shelf pkg3 E1)
        (on-shelf pkg4 E1)
        (on-shelf pkg5 E2)
        (on-shelf pkg6 E2)
        
    ; cims lliures
        (clear pkg4)
        (clear pkg6)
        (clear R1)
        (clear R2)
        
    ; caselles ocupades per robots
        (occupied c13)
        (occupied c44)
        (occupied c55)
        
    ; definicio de tipus de caselles especials
        (is-shelf c24)
        (is-shelf c46)
        (is-shelf c56)
        (is-dispenser c51)
        (is-charger c55)
        
    ; valors numerics de pes i bateria (Restriccions de la missió 2b)
        (= (weight pkg1) 4)
        (= (weight pkg2) 3)
        (= (weight pkg3) 2)
        (= (weight pkg4) 1)
        (= (weight pkg5) 3)
        (= (weight pkg6) 2)
        
        (= (battery R1) 30)
        (= (battery R2) 30)
        (= (max-battery R1) 50)
        (= (max-battery R2) 50)
        
        (= (current-load R1) 0)
        (= (current-load R2) 0)
        (= (max-load R1) 12)
        (= (max-load R2) 12)
        
        (= (total-energy-used) 0)
        
    ;accessibilitat entre caselles
        (location-accessible c11 c12)
        (location-accessible c12 c11)
        (location-accessible c12 c13) 
        (location-accessible c13 c12)
        (location-accessible c13 c14) 
        (location-accessible c14 c13)
        (location-accessible c14 c15) 
        (location-accessible c15 c14)
        (location-accessible c15 c16) 
        (location-accessible c16 c15)
        (location-accessible c11 c21) 
        (location-accessible c21 c11)
        (location-accessible c15 c25) 
        (location-accessible c25 c15)
        (location-accessible c16 c26) 
        (location-accessible c26 c16)
        (location-accessible c14 c24) 
        (location-accessible c24 c14)
        (location-accessible c25 c24) 
        (location-accessible c24 c25)
        (location-accessible c25 c26) 
        (location-accessible c26 c25)
        (location-accessible c21 c31) 
        (location-accessible c31 c21)
        (location-accessible c26 c36)
        (location-accessible c36 c26)
        (location-accessible c31 c32) 
        (location-accessible c32 c31)
        (location-accessible c32 c42) 
        (location-accessible c42 c32)
        (location-accessible c36 c46) 
        (location-accessible c46 c36)
        (location-accessible c44 c45) 
        (location-accessible c45 c44)
        (location-accessible c45 c46) 
        (location-accessible c46 c45)
        (location-accessible c42 c52) 
        (location-accessible c52 c42)
        (location-accessible c44 c54) 
        (location-accessible c54 c44)
        (location-accessible c45 c55) 
        (location-accessible c55 c45)
        (location-accessible c51 c52) 
        (location-accessible c52 c51)
        (location-accessible c52 c53) 
        (location-accessible c53 c52)
        (location-accessible c53 c54) 
        (location-accessible c54 c53)
        (location-accessible c54 c55) 
        (location-accessible c55 c54)
        
    ; ordre de dispensacio(pkg1(4) -> pkg2(3) -> pkg5(3) -> pkg3(2) -> pkg6(2) -> pkg4(1))
        (next-to-dispense pkg1)
        (dispense-order pkg1 pkg2)
        (dispense-order pkg2 pkg5)
        (dispense-order pkg5 pkg3)
        (dispense-order pkg3 pkg6)
        (dispense-order pkg6 pkg4)
    )

    (:goal (and
        (dispensed pkg1)
        (dispensed pkg2)
        (dispensed pkg3)
        (dispensed pkg4)
        (dispensed pkg5)
        (dispensed pkg6)
    ))

    (:metric minimize (total-energy-used))
)