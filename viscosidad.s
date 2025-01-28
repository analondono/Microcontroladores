! C�digo en ensamblador SPARC
! Funciones auxiliares y principales

.section ".text"
.globl suma_vect, escala_vect, Vector_sobre_escalar, acumula_pasos

suma_vect: ! w = u + v
    ! %i0 - N�mero de elementos del vector
    ! %i1 - Direcci�n de memoria del vector u
    ! %i2 - Direcci�n de memoria del vector v
    ! %i3 - Direcci�n de memoria del vector w
    ret
    nop

escala_vect: ! w = k * u
    ! %i0 - N�mero de elementos del vector
    ! %i1 - Direcci�n de memoria del vector u
    ! %i2 - Escalar k
    ! %i3 - Direcci�n de memoria del vector w
    ret
    nop

Vector_sobre_escalar: ! w = u / k
    ! %i0 - N�mero de elementos del vector
    ! %i1 - Direcci�n de memoria del vector u
    ! %i2 - Escalar k
    ! %i3 - Direcci�n de memoria del vector w
    ret
    nop

acumula_pasos:
    ! Funci�n principal
    ! Entradas: 
    !   %i0 - N�mero de pasos
    !   %i1 - Direcci�n de memoria del vector de posici�n inicial (Pos_i)
    !   %i2 - Direcci�n de memoria del vector de velocidad inicial (v_i)
    !   %i3 - Escalar Kv
    !   %i4 - Tama�o del paso (paso)
    !   %i5 - Intervalo de tiempo (t)
    ! Salidas:
    !   %o0 - N�mero de elementos en el vector (valor de retorno)
    !   %o1 - N�mero de vectores retornados
    !   %o2 - Direcci�n de memoria de la lista de resultados (lista_pasos)

    sub %g0, %i3, %l3       ! %l3 = -Kv
    mov %i1, %l1            ! %l1 = Pos (posici�n inicial)
    mov %i2, %l2            ! %l2 = v (velocidad inicial)
    mov %i4, %l0            ! %l0 = contador de pasos

Ciclo:
    subcc %l0, 1, %l0       ! Decrementar contador de pasos
    be fin                  ! Si el contador llega a 0, salir del bucle
    nop

    mov %l2, %i1            ! %i1 = v (velocidad actual)
    mov %l3, %i2            ! %i2 = -Kv (c�lculo de fuerza actual)
    mov 0, %i3              ! Inicializar fuerza en 0

    call escala_vect        ! Llamar a funci�n para calcular fuerza escalada
    nop

    mov %i1, %o0            ! Pasar v como argumento
    mov %i2, %o1            ! Pasar f como argumento
    mov %i5, %o2            ! Pasar t como argumento
    call un_paso
    nop

    ld [%o0], %l2           ! Actualizar v (nueva velocidad)
    ld [%o1], %l1           ! Actualizar Pos (nueva posici�n)

    st %l1, [%o2 + %l0 * 4] ! Almacenar Pos en la lista de resultados

    ba Ciclo                ! Repetir bucle
    nop

fin:
    ret
    nop