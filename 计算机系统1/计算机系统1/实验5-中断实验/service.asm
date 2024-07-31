
;
;SERVICE ROUTINE
;
.ORIG	x2000
            ST R0,	SaveR0
            ST R1,	SaveR1
            ST R2,	SaveR2
            ST R3,	SaveR3
            ST R4,	SaveR4
            LEA R0,INPUT_PROMPT
LOAD_NEXT;show the prompt 
            LDR R1,R0,#0
            BRz GET_INPUT
CHECK_SCREEN1 
            LDI R2,DSR
            BRzp CHECK_SCREEN1
            STI R1,DDR
            ADD R0,R0,#1
            BRnzp LOAD_NEXT


GET_INPUT;SAVE USER'S INPUT
            LEA	R0,INPUT_STRING
LOOP1       
            LDI R1,KBSR
            BRzp LOOP1
            LDI R1,KBDR
            ADD R1,R1,#-10;CHECK END
            BRz  OUTPUTS
CHECK_SCREEN2 
            LDI R2,DSR
            BRzp CHECK_SCREEN2
            ADD R1,R1,#10
            STI R1,DDR         
            STR R1,R0,#0
            ADD R0,R0,#1
            BRnzp LOOP1

OUTPUTS     
            AND R1,R1,#0;APPEND '\n'
            ADD R1,R1,#10
            STR R1,R0,#0
            ADD R0,R0,#1
            AND R1,R1,#0
            STR R1,R0,#0;APPEND '\0'
            LD R3,OUTPUT_TIMES;SET THE OUTPUT_TIMES
         
OUTPUT_IT   LD R4,DELAY_COUNT
            LEA R0,INPUT_STRING
LOAD_NEXT1;show the INPUT_STRING
            LDR R1,R0,#0
            BRz RESTORE
CHECK_SCREEN3 
            LDI R2,DSR
            BRzp CHECK_SCREEN3
            STI R1,DDR

            ADD R0,R0,#1
            BRnzp LOAD_NEXT1        
RESTORE     
            ADD R4,R4,#-1
            BRp RESTORE
            ADD R3,R3,#-1
            BRzp OUTPUT_IT

            LD R0,	SaveR0
            LD R1,	SaveR1
            LD R2,	SaveR2
            LD R3,	SaveR3
            LD R4,	SaveR4
            RTI

;
;DATA
;
OUTPUT_TIMES .FILL #10
DELAY_COUNT .FILL #2500
KBSR .FILL  xFE00
KBDR .FILL  xFE02
DSR .FILL  xFE04
DDR .FILL  xFE06
INPUT_PROMPT .STRINGZ	"Enter a character: "   
SaveR0 .BLKW 1
SaveR1 .BLKW 1
SaveR2 .BLKW 1
SaveR3 .BLKW 1
SaveR4 .BLKW 1
INPUT_STRING .BLKW 30 #0
.END



