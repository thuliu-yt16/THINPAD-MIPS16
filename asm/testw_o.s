SW_SP R7 0
ADDSP 1
LI R6 00
SLL R6 R6 0
ADDIU R6 10
ADDIU R6 05
MFPC R7
ADDIU R7 3
JR R6
NOP
ADDSP FF
LW_SP R7 0
NOP
LI R6 0X00BF
SLL R6 R6 0X000
ADDIU R6 0X0001
LW R6 R0 0X0000
LI R6 0X0001
AND R0 R6
BEQZ R0 F8
NOP
SW_SP R0 0
SW_SP R1 1
SW_SP R2 2
SW_SP R3 3
SW_SP R4 4
SW_SP R5 5
SW_SP R6 6
SW_SP R7 7
ADDSP 8
ADDSP F8
LW_SP R0 0
LW_SP R1 1
LW_SP R2 2
LW_SP R3 3
LW_SP R4 4
LW_SP R5 5
LW_SP R6 6
LW_SP R7 7
JR R7
NOP