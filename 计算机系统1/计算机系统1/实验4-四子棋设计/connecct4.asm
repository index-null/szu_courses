.ORIG x3000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;main function
jsr ShowChessBoard
AND R1,R1,#0
GameLoop JSR	Prompt
JSR GetColumn
JSR CheckColumn
add r2,r2,#0
brnp KeepPlaying
jsr showInvalidPrompt
br GameLoop
KeepPlaying jsr PlaceChess
add r2,r2,#0
brp KeepPlaying2
jsr showInvalidPrompt
br GameLoop
KeepPlaying2 jsr ShowChessBoard 
jsr CheckWin
add r2,r2,#0
brn KeepPlaying3
jsr ShowFinalResult
br GameOver
KeepPlaying3 jsr Swapcontrol
br GameLoop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GameOver HALT

;
;DATA SECTION
;
PromptPlayer1ChooseColumn .STRINGZ "Player 1, choose a column:"
PromptPlayer2ChooseColumn .STRINGZ "Player 2, choose a column:"
PromptWrongChoose .STRINGZ "Invalid move. Try again.\n"
NextLine .FILL x000A
BlankSpace .FILL x0020
Ascii_Negative0 .FILL xFFD0
Ascii_NegativeEnter .FILL #-10
ChessPlayer1 .FILL x004F
ChessPlayer2 .FILL x0058
ChessNull .FILL	x002d
EndOfString .FILL  x0000
MinColumn .FILL x0001
MaxColumn .FILL x0006
SaveR0 .FILL	0x0000
SaveR1 .FILL	0x0000
SaveR2 .FILL	0x0000
SaveR3 .FILL	0x0000
SaveR4 .FILL	0x0000
SaveR5 .FILL	0x0000
SaveR6 .FILL	0x0000
SaveR7 .FILL	0x0000

;
;FUNCTION SECTION
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Prompt()
Prompt ST R0,SaveR0
ST R7,SaveR7
ADD R1,R1,#0
BRZ Player1
LEA R0,PromptPlayer2ChooseColumn
PUTS
BR EndOfFunctionPrompt
Player1 LEA R0,PromptPlayer1ChooseColumn
PUTS
EndOfFunctionPrompt LD R0,SaveR0
LD R7,SaveR7
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Swapcontrol(R1)->R1
Swapcontrol NOT R1,R1
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GetColumn()->R0:lastnumber,R2:n of input
GetColumn st r3,SaveR3
st r5,SaveR5
st r7,SaveR7
ST R4,SaveR4
ld r3,Ascii_NegativeEnter
and r2,r2,#0
Input GETC
OUT
add r2,r2,#1
add r4,r0,r3
brnp SaveCurrentNumber
brz EndOfFunctionGetColumn
SaveCurrentNumber and r5,r5,#0
add r5,r5,R0
br Input
EndOfFunctionGetColumn and r0,r0,#0
add r0,r5,#0
ld r3,Ascii_Negative0
add r0,r0,r3
add r2,r2,#-1
ld r3,SaveR3
ld r5,SaveR5
ld r7,SaveR7
LD R4,SaveR4
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CheckColumn(r0:lastnumber,r2:n of input)->r2:is between 1-6    r2=1->yes r2=0->no
CheckColumn st r3,SaveR3
add r2,r2,#-1
brz CheckNumber1
and r2,r2,#0
br EndOfFunctionCheckColumn
CheckNumber1 and r3,r3,#0
add r3,r3,#-1
add r3,r0,r3
brzp CheckNumber2
and r2,r2,#0
add r2,r2,#1
br EndOfFunctionCheckColumn
CheckNumber2 and r3,r3,#0
add r3,r3,#-6
add r3,r0,r3
brp LetR2equals0
and r2,r2,#0
add r2,r2,#1
br EndOfFunctionCheckColumn
LetR2equals0 and r2,r2,#0
EndOfFunctionCheckColumn ld r3,SaveR3
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;showInvalidPrompt()
showInvalidPrompt st r7,SaveR7
st r0,SaveR0 
lea r0,PromptWrongChoose
PUTS
ld r0,SaveR0
ld r7,SaveR7
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ShowChessBoard()
ShowChessBoard st r0,SaveR0
st r1,SaveR1
st r2,SaveR2
st r3,SaveR3
st r4,SaveR4
st r5,SaveR5
st r7,SaveR7
and r4,r4,#0
add r4,r4,#-6
and r3,r3,#0
and r2,r2,#0
lea r1,ChessBoardLine1
CurShow ldr r0,r1,#0
jsr ShowChess
ld r0,BlankSpace
OUT
add r1,r1,#1
add r2,r2,#1
add r5,r4,r2
brn CurShow
ld r0,NextLine
OUT 
and r2,r2,#0
add r3,r3,#1
add r5,r3,r4
brnp CurShow
ld r0,SaveR0
ld r1,SaveR1
ld r2,SaveR2
ld r3,SaveR3
ld r4,SaveR4
ld r5,SaveR5
ld r7,SaveR7
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ShowChess(r0)-> - / O / X
ShowChess st r0,SaveR0_sr
st r7,SaveR7_sr
add r0,r0,#0
brz ShowChess_null
brn ShowChess_X
brp ShowChess_O
ShowChess_null ld r0,ChessNull
OUT
br EndOfFunctionShowChess
ShowChess_X ld r0,ChessPlayer1
OUT
br EndOfFunctionShowChess
ShowChess_O ld r0,ChessPlayer2
OUT
EndOfFunctionShowChess ld r0,SaveR0_sr
ld r7,SaveR7_sr
RET
SaveR0_sr .BLKW 1
SaveR7_sr .BLKW 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PlaceChess(r0:column,r1:player)-> r2:is the place valid r2=1->yes r2=0->no r5:row
PlaceChess st r7,SaveR7
st r3,SaveR3
st r4,SaveR4
and r2,r2,#0
add r2,r2,#1
lea r3,ChessBoardLine6
jsr PlaceChessInLine
and r5,r5,#0
add r5,r5,#6
add r4,r4,#0
brp EndOfFunctionPlaceChess
lea r3,ChessBoardLine5
jsr PlaceChessInLine
and r5,r5,#0
add r5,r5,#5
add r4,r4,#0
brp EndOfFunctionPlaceChess
lea r3,ChessBoardLine4
jsr PlaceChessInLine
and r5,r5,#0
add r5,r5,#4
add r4,r4,#0
brp EndOfFunctionPlaceChess
lea r3,ChessBoardLine3
jsr PlaceChessInLine
and r5,r5,#0
add r5,r5,#3
add r4,r4,#0
brp EndOfFunctionPlaceChess
lea r3,ChessBoardLine2
jsr PlaceChessInLine
and r5,r5,#0
add r5,r5,#2
add r4,r4,#0
brp EndOfFunctionPlaceChess
lea r3,ChessBoardLine1
jsr PlaceChessInLine
and r5,r5,#0
add r5,r5,#1
add r4,r4,#0
brp EndOfFunctionPlaceChess
and r2,r2,#0
EndOfFunctionPlaceChess ld r3,SaveR3
ld r4,SaveR4
ld r7,SaveR7
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ChessBoardLine1 .BLKW 6 #0
ChessBoardLine2 .BLKW 6 #0
ChessBoardLine3 .BLKW 6 #0
ChessBoardLine4 .BLKW 6 #0
ChessBoardLine5 .BLKW 6 #0
ChessBoardLine6 .BLKW 6 #0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PlaceChessInLine(r3:ptr,r0:column,r1:player)-> r4:is the place valid r4=1->yes r4=0->no
PlaceChessInLine st r0,SaveR0_pcil
st r1,SaveR1_pcil
st r2,SaveR2_pcil
st r3,SaveR3_pcil
add r0,r0,#-1
brz CheckPlace
LoopFindPlace add r3,r3,#1
add r0,r0,#-1
brz CheckPlace
br LoopFindPlace
CheckPlace ldr r2,r3,#0
brz EnfillChess
and r4,r4,#0
br EndOfFunctionPlaceChessInLine
EnfillChess add r1,r1,#0
brn EnfillOne
and r1,r1,#0
add r1,r1,#-1
str r1,r3,#0
and r4,r4,#0
add r4,r4,#1
br EndOfFunctionPlaceChessInLine
EnfillOne and r1,r1,#0
add R1,r1,#1
str r1,r3,#0
and r4,r4,#0
add r4,r4,#1
EndOfFunctionPlaceChessInLine ld r0,SaveR0_pcil
ld r1,SaveR1_pcil
ld r2,SaveR2_pcil
ld r3,SaveR3_pcil
RET
SaveR0_pcil .BLKW 1
SaveR1_pcil .BLKW 1
SaveR2_pcil .BLKW 1
SaveR3_pcil .BLKW 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CheckWin(r5:row,r0:col,r1:player)->r2: -1:keep 0:tie 1:p1Win 2:p2Win
CheckWin st r4,SaveR4_cw
st r6,SaveR6_cw
st r7,SaveR7_cw
and r2,r2,#0
jsr CheckTie
add r6,r6,#0
brz CheckDifferentPath
and r2,r2,#0
br EndOfFunctionCheckWin
CheckDifferentPath jsr CheckHorizontalWin
add r4,r4,#0
brz NextCheck1
jsr SetR2ByPlayer
br EndOfFunctionCheckWin
NextCheck1 jsr CheckVerticalWin
add r4,r4,#0
brz NextCheck2
jsr SetR2ByPlayer
br EndOfFunctionCheckWin
NextCheck2 jsr CheckDiagonalWin
add r4,r4,#0
brz NextCheck3
jsr SetR2ByPlayer
br EndOfFunctionCheckWin
NextCheck3 jsr CheckAntiDiagonalWin
add r4,r4,#0
brz NotWin
jsr SetR2ByPlayer
br EndOfFunctionCheckWin
NotWin and r2,r2,#0
add r2,r2,#-1
EndOfFunctionCheckWin ld r4,SaveR4_cw
ld r6,SaveR6_cw
ld r7,SaveR7_cw
RET
SaveR4_cw .FILL	0x0000
SaveR6_cw .FILL	0x0000
SaveR7_cw .FILL	0x0000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ShowFinalResult(r2)->result_prompt
ShowFinalResult st r2,SaveR2_sfr
st r0,SaveR0_sfr
st r7,SaveR7_sfr
add r2,r2,#-1
brn ShowFinalResult_Tie
brz ShowFinalResult_P1Win
brp ShowFinalResult_P2Win

ShowFinalResult_P1Win
lea r0,PromptP1Win
PUTS
br EndOfFunctionShowFinalResult

ShowFinalResult_Tie
lea r0,PromptTie
PUTS
br EndOfFunctionShowFinalResult

ShowFinalResult_P2Win
lea r0,PromptP2Win
PUTS
br EndOfFunctionShowFinalResult

EndOfFunctionShowFinalResult ld r2,SaveR2_sfr
ld r0,SaveR0_sfr
ld r7,SaveR7_sfr
RET
SaveR0_sfr .BLKW #1
SaveR2_sfr .BLKW #1
SaveR7_sfr .BLKW #1
PromptP1Win .STRINGZ "Player 1 Wins.\n"
PromptP2Win .STRINGZ "Player 2 Wins.\n"
PromptTie .STRINGZ "Tie game.\n"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SetR2ByPlayer(r1)->r2 0/1 -1/2
SetR2ByPlayer st r1,SaveR1_sr2bp
and r2,r2,#0
add r1,r1,#0
brz SetToOne
add r2,r2,#2
br EndOfFunctionSetR2ByPlayer
SetToOne add r2,r2,#1
EndOfFunctionSetR2ByPlayer ld r1,SaveR1_sr2bp;restore
RET
SaveR1_sr2bp .BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CheckTie()->r6 1:tie 0:not tie
CheckTie st r1,SaveR1_ct
st r2,SaveR2_ct
st r3,SaveR3_ct
and r6,r6,#0
add r6,r6,#1
and r3,r3,#0
add r3,r3,#6
lea r1,ChessBoardLine1
WhileLoopCheckTie add r3,r3,#0
brnz EndOfFunctionCheckTie
add r3,r3,#-1
ldr r2,r1,#0
brnp NextCheck4
and r6,r6,#0
brnzp EndOfFunctionCheckTie
NextCheck4 add r1,r1,#1
br WhileLoopCheckTie
EndOfFunctionCheckTie ld r1,SaveR1_ct
ld r2,SaveR2_ct
ld r3,SaveR3_ct
RET
SaveR1_ct .BLKW #1
SaveR2_ct .BLKW	#1
SaveR3_ct .BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GetValue(r5,r0)->r6:value of matrix[r5行][r0列]
GetValue st r0,SaveR0_gv
st r1,SaveR1_gv
st r2,SaveR2_gv
st r7,SaveR7_gv
lea r6,ChessBoardLine1
add r6,r6,r0
add r6,r6,#-1
and r0,r0,#0
add r0,r5,#-1
and r1,r1,#0
add r1,r1,#6
jsr SimpleMultiply
add r6,r6,r2
ldr r6,r6,#0
ld r0,SaveR0_gv
ld r2,SaveR2_gv
ld r1,SaveR1_gv
ld r7,SaveR7_gv
RET
SaveR0_gv .BLKW	#1
SaveR2_gv .blkw #1
SaveR1_gv .BLKW	#1
SaveR7_gv .BLKW	#1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SimpleMultiply(r0,r1)->r2=r0*r1
SimpleMultiply st r0,SaveR0_sm
st r1,SaveR1_sm
and r2,r2,#0
add r1,r1,#0
brz FinishMultiply
LoopAddAsMulti add r2,r2,r0
add r1,r1,#-1
brnz FinishMultiply
br LoopAddAsMulti
FinishMultiply ld r0,SaveR0_sm
ld r1,SaveR1_sm 
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SaveR0_sm .blkw #1
SaveR1_sm .BLKW	#1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CheckHorizontalWin(r5,r0,r1)->r4 1:win 0:keep playing
CheckHorizontalWin st r0,SaveR0_chw
st R1,SaveR1_chw
st R2,SaveR2_chw
st r3,SaveR3_chw
st r5,SaveR5_chw
st r6,SaveR6_chw
st R7,SaveR7_chw
and r3,r3,#0;connectted num but itself
jsr GetValue
and r2,r2,#0
add r2,r2,r6;r2:value of self
st r0,RawPositon
TurnLeft add r0,r0,#-1;turn left
brz RestoreR0
jsr GetValue
not r6,r6
add r6,r6,#1
add r6,r2,r6
brnp RestoreR0
add r3,r3,#1
br TurnLeft
RestoreR0 ld r0,RawPositon

TurnRight add r0,r0,#1;turn right
st r3,ConnectSaver
and r3,r3,#0
add r3,r3,r0
jsr IsLegal
ld r3,ConnectSaver
add r4,r4,#0
brz EndOfFunctionCheckHorizontalWin
jsr GetValue
not r6,r6
add r6,r6,#1
add r6,r2,r6
brnp EndOfFunctionCheckHorizontalWin
add r3,r3,#1
br TurnRight
EndOfFunctionCheckHorizontalWin add r3,r3,#-3
brzp HorizontalWin
and r4,r4,#0
br FinishHorizontal
HorizontalWin and r4,r4,#0
add r4,r4,#1
FinishHorizontal ld r0,SaveR0_chw
ld R1,SaveR1_chw
ld R2,SaveR2_chw
ld r3,SaveR3_chw
ld r5,SaveR5_chw
ld r6,SaveR6_chw
ld R7,SaveR7_chw
RET 
RawPositon .BLKW	#1
ConnectSaver .BLKW	#1
SaveR0_chw .BLKW	#1
SaveR1_chw .BLKW	#1
SaveR2_chw .BLKW	#1
SaveR3_chw .BLKW	#1
SaveR5_chw .BLKW	#1
SaveR6_chw .BLKW	#1
SaveR7_chw .BLKW	#1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CheckVerticalWin(r5,r0,r1)->r4 1:win 0:keep playing
CheckVerticalWin
st r0,SaveR0_cvw
st R1,SaveR1_cvw
st R2,SaveR2_cvw
st r3,SaveR3_cvw
st r5,SaveR5_cvw
st r6,SaveR6_cvw
st R7,SaveR7_cvw
and r3,r3,#0;connectted num but itself
jsr GetValue
and r2,r2,#0
add r2,r2,r6;r2:value of self
st r5,RawPositon_r5
TurnUp add r5,r5,#-1;turn up
brz RestoreR5
jsr GetValue
not r6,r6
add r6,r6,#1
add r6,r2,r6
brnp RestoreR5
add r3,r3,#1
br TurnUp
RestoreR5 ld r5,RawPositon_r5

TurnDown add r5,r5,#1;turn down
st r3,ConnectSaver_v1
and r3,r3,#0
add r3,r3,r5
jsr IsLegal
ld r3,ConnectSaver_v1
add r4,r4,#0
brz EndOfFunctionCheckVerticalWin
jsr GetValue
not r6,r6
add r6,r6,#1
add r6,r2,r6
brnp EndOfFunctionCheckVerticalWin
add r3,r3,#1
br TurnDown
EndOfFunctionCheckVerticalWin add r3,r3,#-3
brzp VerticalWin
and r4,r4,#0
br FinishVertical
VerticalWin and r4,r4,#0
add r4,r4,#1
FinishVertical ld r0,SaveR0_cvw
ld R1,SaveR1_cvw
ld R2,SaveR2_cvw
ld r3,SaveR3_cvw
ld r5,SaveR5_cvw
ld r6,SaveR6_cvw
ld R7,SaveR7_cvw
RET 
RawPositon_r5 .BLKW	#1
ConnectSaver_v1 .BLKW	#1
SaveR0_cvw .BLKW	#1
SaveR1_cvw .BLKW	#1
SaveR2_cvw .BLKW	#1
SaveR3_cvw .BLKW	#1
SaveR5_cvw .BLKW	#1
SaveR6_cvw .BLKW	#1
SaveR7_cvw .BLKW	#1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CheckDiagonalWin(r5,r0,r1)->r4 1:win 0:keep playing
CheckDiagonalWin
st r0,SaveR0_cdw
st R1,SaveR1_cdw
st R2,SaveR2_cdw
st r3,SaveR3_cdw
st r5,SaveR5_cdw
st r6,SaveR6_cdw
st R7,SaveR7_cdw
and r3,r3,#0;connectted num but itself
jsr GetValue
and r2,r2,#0
add r2,r2,r6;r2:value of self
st r5,RawPositon_r5_cdw
st r0,RawPositon_r0_cdw
TurnLeftUp add r5,r5,#-1;turn up
brz RestoreR5_R0
add r0,r0,#-1;turn left
brz RestoreR5_R0
jsr GetValue
not r6,r6
add r6,r6,#1
add r6,r2,r6
brnp RestoreR5_R0
add r3,r3,#1
br TurnLeftUp
RestoreR5_R0 ld r5,RawPositon_r5_cdw
ld r0,RawPositon_r0_cdw

TurnRightDown add r5,r5,#1;turn down
st r3,ConnectSaver_cdw
and r3,r3,#0
add r3,r3,r5
jsr IsLegal
ld r3,ConnectSaver_cdw
add r4,r4,#0
brz EndOfFunctionCheckDiagonalWin
add r0,r0,#1;turn right
and r3,r3,#0
add r3,r3,r5
jsr IsLegal
ld r3,ConnectSaver_cdw
add r4,r4,#0
brz EndOfFunctionCheckDiagonalWin
jsr GetValue
not r6,r6
add r6,r6,#1
add r6,r2,r6
brnp EndOfFunctionCheckDiagonalWin
add r3,r3,#1
br TurnRightDown
EndOfFunctionCheckDiagonalWin add r3,r3,#-3
brzp DiagonalWin
and r4,r4,#0
br FinishDiagonal
DiagonalWin and r4,r4,#0
add r4,r4,#1
FinishDiagonal ld r0,SaveR0_cdw
ld R1,SaveR1_cdw
ld R2,SaveR2_cdw
ld r3,SaveR3_cdw
ld r5,SaveR5_cdw
ld r6,SaveR6_cdw
ld R7,SaveR7_cdw
RET 
RawPositon_r0_cdw .BLKW	#1
RawPositon_r5_cdw .BLKW	#1
ConnectSaver_cdw .BLKW	#1
SaveR0_cdw .BLKW	#1
SaveR1_cdw .BLKW	#1
SaveR2_cdw .BLKW	#1
SaveR3_cdw .BLKW	#1
SaveR5_cdw .BLKW	#1
SaveR6_cdw .BLKW	#1
SaveR7_cdw .BLKW	#1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CheckAntiDiagonalWin(r5,r0,r1)->r4 1:win 0:keep playing
CheckAntiDiagonalWin
st r0,SaveR0_cadw
st R1,SaveR1_cadw
st R2,SaveR2_cadw
st r3,SaveR3_cadw
st r5,SaveR5_cadw
st r6,SaveR6_cadw
st R7,SaveR7_cadw
and r3,r3,#0;connectted num but itself
jsr GetValue
and r2,r2,#0
add r2,r2,r6;r2:value of self
st r5,RawPositon_r5_cadw
st r0,RawPositon_r0_cadw
TurnLeftDown add r5,r5,#1;turn Down
st r3,ConnectSaver_cadw
and r3,r3,#0
add r3,r3,r5
jsr IsLegal
ld r3,ConnectSaver_cadw
add r4,r4,#0
brz RestoreR5_R0_cadw
add r0,r0,#-1;turn left
brz RestoreR5_R0_cadw
jsr GetValue
not r6,r6
add r6,r6,#1
add r6,r2,r6
brnp RestoreR5_R0_cadw
add r3,r3,#1
br TurnLeftDown
RestoreR5_R0_cadw ld r5,RawPositon_r5_cadw
ld r0,RawPositon_r0_cadw

TurnRightUp add r5,r5,#-1;turn UP
brz EndOfFunctionCheckAntiDiagonalWin
add r0,r0,#1;turn right
and r3,r3,#0
add r3,r3,r5
jsr IsLegal
ld r3,ConnectSaver_cadw
add r4,r4,#0
brz EndOfFunctionCheckAntiDiagonalWin
jsr GetValue
not r6,r6
add r6,r6,#1
add r6,r2,r6
brnp EndOfFunctionCheckAntiDiagonalWin
add r3,r3,#1
br TurnRightUp
EndOfFunctionCheckAntiDiagonalWin add r3,r3,#-3
brzp AntiDiagonalWin
and r4,r4,#0
br FinishAntiDiagonal
AntiDiagonalWin and r4,r4,#0
add r4,r4,#1
FinishAntiDiagonal ld r0,SaveR0_cadw
ld R1,SaveR1_cadw
ld R2,SaveR2_cadw
ld r3,SaveR3_cadw
ld r5,SaveR5_cadw
ld r6,SaveR6_cadw
ld R7,SaveR7_cadw
RET 
RawPositon_r0_cadw .BLKW	#1
RawPositon_r5_cadw .BLKW	#1
ConnectSaver_cadw .BLKW	#1
SaveR0_cadw .BLKW	#1
SaveR1_cadw .BLKW	#1
SaveR2_cadw .BLKW	#1
SaveR3_cadw .BLKW	#1
SaveR5_cadw .BLKW	#1
SaveR6_cadw .BLKW	#1
SaveR7_cadw .BLKW	#1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;IsLegal(r3)->r4 1:legal 0:notlegal(<1/>6)
IsLegal st r3,SaveR3_isl
st r5,SaveR5_isl
and r5,r5,#0
add r5,r5,r3
add r5,r5,#-1
brn LessThan1
and r5,r5,#0
add r5,r5,r3
add r5,r5,#-6
brp BiggerThan6
and r4,r4,#0
add r4,r4,#1
br EndOfFunctionIslegal
LessThan1 and r4,r4,#0
br EndOfFunctionIslegal
BiggerThan6 and r4,r4,#0
br EndOfFunctionIslegal
EndOfFunctionIslegal ld r3,SaveR3_isl
ld r5, SaveR5_isl
RET
SaveR3_isl .BLKW	#1
SaveR5_isl .BLKW	#1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.END