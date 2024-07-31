.ORIG	x3000
            LEA	R6,	#-1 ; initialize the stack pointer

            LD R0,VECTOR_ADDRESS; set up the keyboard interrupt vector table entry
            LD R1,ENTRANCE_ADDRESS
            STR R1,R0,#0

            LD R0,INTERRUPT_MASK; enable keyboard interrupts
            LDI R1,KBSR
            NOT R0,R0
            NOT R1,R1
            AND R0,R0,R1
            NOT R0,R0
            STI	R0, KBSR

PRINT_LOOP; start of actual user program to print ICS checkerboard
            LEA	R0,	PROMPT1
            PUTS
            JSR	DELAY
            LEA R0,PROMPT2
            PUTS
BRNZP PRINT_LOOP
HALT
;
;DATA
;
PROMPT1 .STRINGZ	"ICS     ICS     ICS     ICS     ICS     ICS\n"
PROMPT2 .STRINGZ	"    ICS     ICS     ICS     ICS     ICS     \n"
VECTOR_ADDRESS .FILL    x0180
ENTRANCE_ADDRESS .FILL	x2000
KBSR .FILL  xFE00
KBDR .FILL  xFE02
DSR .FILL  xFE04
DDR .FILL  xFE06
INTERRUPT_MASK .FILL	x4000;0100 0000 0000 0000

;
;SUBROUTINE
;
DELAY   ST  R1, SaveR1
        LD  R1, COUNT
REP     ADD R1,R1,#-1
        BRp REP
        LD  R1, SaveR1
        RET
COUNT   .FILL #2500
SaveR1  .BLKW 1  
.END












