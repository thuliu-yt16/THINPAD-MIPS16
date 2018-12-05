; BEGIN:
;     NOP
;     LI R6 0x00BF
;     SLL R6 R6 0x0000
;     LI R1 0x0090
;     SLL R1 R1 0x0000
;     ADDIU R1 0x0040
;     SW R6 R1 0x0004
;
;     LI R1 0x0080
;     SLL R1 R1 0x0000
;     SW R6 R1 0x0004
;     NOP

INIT:
    NOP
    LI R3 0x0050 ; 80
    LI R4 0x003b ; 59

WRITE:
    ADDIU R6 0x00ff

    LI R2 0x00c0
    SLL R2 R2 0x0000
    ADD R2 R3 ; load x
    SLL R4 R4 0x0007
    ADD R2 R4 ; load y
    SRA R4 R4 0x0007
    LW R1 R2 0x0000

    SLL R1 R1 0x0000
    SLL R1 R1 0x0007
    OR R1 R3 ; load x
    SLL R4 R4 0x0007
    OR R1 R4 ; load y
    SRA R4 R4 0x0007

    LI R5 0x00BF
    SLL R5 R5 0x0000
    SW R5 R1 0x0004

    MFPC R7
    ADDIU R7 0x0003
    NOP
    BEQZ R3 PRE_LL ; 0x0005 ; PRE_L
    NOP

    B WRITE
    NOP

START:
    LI R3 0x0050 ; 80
    LI R4 0x003b ; 59

BEGIN:
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00BF
    SLL R6 R6 0x0000
    LW R6 R1 0x0000
    LI R6 0x00FF
    AND R1 R6 ; R1 get first byte

    LI R6 0x0008 ; 8 bits

BYTE:
    NOP
    BEQZ R6 BEGIN ; 0x00f2 ; BEGIN
    NOP

    ADDIU R6 0x00ff
    ADDIU R3 0x00ff ; w - 1

    LI R2 0x0001
    AND R2 R1
    SRA R1 R1 0x0001

    LI R5 0x00c0
    SLL R5 R5 0x0000
    ADD R5 R3 ; load x
    SLL R4 R4 0x0007
    ADD R5 R4 ; load y
    SRA R4 R4 0x0007

    SW R5 R2 0x0000

    MFPC R7
    ADDIU R7 0x0003
    NOP
    BEQZ R3 PRE_L ; 0x0005 ; PRE_L
    NOP

    B BYTE
    NOP

LOOP:
    B BEGIN
    NOP

PRE_L:
    NOP
    BEQZ R4 INIT; 0x00d5 ; INIT ; end of one frame
    NOP
    LI R3 0x0050
    ADDIU R4 0x00ff
    JR R7
    NOP

PRE_LL:
    NOP
    BEQZ R4 START
    NOP
    LI R3 0x004f
    ADDIU R4 0x00ff
    JR R7
    NOP

TESTR:
    NOP
    LI R6 0x00BF
    SLL R6 R6 0x0000
    ADDIU R6 0x0001
    LW R6 R0 0x0000
    LI R6 0x0002
    AND R0 R6
    BEQZ R0 TESTR
    NOP
    JR R7
    NOP
