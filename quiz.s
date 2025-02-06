.include "macros.s"  ! Include the macros file
.global end_loop
.global calcular_posicion
! ============================
! Vector Addition: u + v = result
! Parameters:
! o0 = size of vectors
! o1 = address of vector u
! o2 = address of vector v
! o3 = address of result

    lista_vels:
        .word 4, 2
        .word 4, 6
        .word 8, 2
        .word 3, 7
        .word 4, 8
        .word 5, 9
        .word 0, 2
    lista_pos: .skip 48

.global _start
_start:
    define (t, 10)      ! Time Step (dt) = 100 (scaled)
    mov 8, %o0            ! Size of vector (2 elements*4)    
    set lista_vels, %o1            ! Address
    set lista_pos, %o2            ! Address 
    ld [%o1], %o3       ! Cargar primer valor de lista_vels
    MOV t, %l4        ! Time Step (dt) = 10
    call calcular_posicion
    nop

calcular_posicion:
    sub %sp, -96, %sp
    clr %l0
    MOV 57, %l6


loop:
    cmp %l0, %l6         ! Comparar índice con tamaño
    bge end_loop         ! Si es mayor o igual, terminar
    nop


    ld [%o1 + %l0], %l1  ! Cargar vx
    add %l0, 4, %l0
    ld [%o1 + %l0], %l2  ! Cargar vy
    add %l0, 4, %l0      ! Incrementar índice
    add %l1, %l2, %l3  ! vc = (vx + vy) / 2
    sra %l3, 1, %l3
    mulscc %l3, %l4, %l5  ! D = vc * t
    sub %l2, %l1, %l3     ! vr - vl
    mulscc %l5, 2, %l6       ! 2 * D
    sdiv %l3, %l6, %l3    ! A = (vr - vl) / (2 * D)
    mulscc %l3, %l3, %l1   
    !sen(A)=A-((A*A*A)/(1*2*3))+((A*A*A*A*A)/(1*2*3*4*5))         aproximacion de seno
    mulscc %l1, %l3, %l1   !A*A*A
    sdiv %l1, 6, %l2       !((A*A*A)/(1*2*3))
    mulscc %l3, %l3, %l1
    mulscc %l1, %l3, %l1
    mulscc %l1, %l3, %l1
    mulscc %l1, %l3, %l1   !a*a*a*a*a
    sdiv %l1, 120, %l1     !((A*A*A*A*A)/(1*2*3*4*5))
    sub %l3, %l2, %l2      !A-((A*A*A)/(1*2*3))
    add %l2, %l1, %l2      !sen(A)
    mulscc %l2, %l5, %l2   !dy = D * sin(A)
    sub %l0, 4, %l0
    st %l2, [%o2 + %l0]   !dy guardado
    !cos(A)=1-((A*A)/(1*2))+((A*A*A*A)/(1*2*3*4))     aproximacion de coseno
    mulscc %l3, %l3, %l1   !A*A
    sdiv %l1, 2, %l2       !((A*A)/(1*2))
    mulscc %l3, %l3, %l1
    mulscc %l1, %l3, %l1
    mulscc %l1, %l3, %l1   !a*a*a*a
    sdiv %l1, 24, %l1     !((A*A*A*A)/(1*2*3*4))
    sub %l2, 1, %l2      !1-((A*A)/(1*2))
    add %l2, %l1, %l2      !cos(A)
    mulscc %l2, %l5, %l2   !dx = D * cos(A)
    sub %l0, 4, %l0
    st %l2, [%o2 + %l0]   !dx guardado
    add %l0, 8, %l0 
    MOV 57, %l6
    cmp %l0, 56          ! Comparar de nuevo
    bl loop               ! Branch if less (mientras sea menor)
    nop

end_loop:
    ret
    nop