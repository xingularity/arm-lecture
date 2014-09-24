	.syntax unified
	.arch armv7-a
	.text

	.equ locked, 1
	.equ unlocked, 0

	.global lock_mutex
	.type lock_mutex, function
lock_mutex:
        @ INSERT CODE BELOW
    LDR     r1, =locked
.F1:
    LDREX   r2, [r0]
    CMP     r2, r1
    BEQ     .F2
    STREXNE r2, r1, [r0] 
    CMPNE   r2, #1
    BEQ     .F1  
    DMB  
    BX      lr

        @ END CODE INSERT
    @WAIT_FOR_UPDATE
.F2:
    B       .F1    
	.size lock_mutex, .-lock_mutex

	.global unlock_mutex
	.type unlock_mutex, function
unlock_mutex:
	@ INSERT CODE BELOW
    LDR     r1, =unlocked
    DMB           
    STR     r1, [r0]
    @SIGNAL_UPDATE   
    BX      lr    
        @ END CODE INSERT
	.size unlock_mutex, .-unlock_mutex

	.end
