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

    LI R5 0x00c0
    SLL R5 R5 0x0000

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
    SLL R2 R2 0x0000
    SLL R2 R2 0x0007 ; get color bit and store in r2

    OR R2 R3 ; load x
    SLL R4 R4 0x0007
    OR R2 R4 ; load y
    SRA R4 R4 0x0007

    SW R5 R2 0x0000
    ADDIU R5 0x0001

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
    BEQZ R4 DISPLAY; 0x00d5 ; INIT ; end of one frame
    NOP
    LI R3 0x0050
    ADDIU R4 0x00ff
    JR R7
    NOP

DISPLAY:
    LI R1 0x00c0
    SLL R1 R1 0x0000

DISPLAYLOOP:
    ADDIU R5 0x00ff

    LW R5 R3 0x0000
    LI R2 0x00BF
    SLL R2 R2 0x0000
    SW R2 R3 0x0004

    ; CMP R5 R1
    SUBU R5 R1 R0
    BNEZ R0 DISPLAYLOOP
    ; BTEQZ DISPLAY
    NOP

    B INIT
    NOP

TESTR:
    NOP
    ; LI R6 0x00BF
    ; SLL R6 R6 0x0000
    ; ADDIU R6 0x0006
    ; LW R6 R0 0x0000
    ; BNEZ R0 KEYBOARD
    ; NOP

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

KEYBOARD:
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP

    LI R1 0x00FF
    LI R6 0x00BF
    SLL R6 R6 0x0000
    SW R6 R1 0x0000

    B INIT
    NOP

TESTW:
    NOP
    LI R6 0x00BF
    SLL R6 R6 0x000
    ADDIU R6 0x0001
    LW R6 R0 0x0000
    LI R6 0x0001
    AND R0 R6
    BEQZ R0 TESTW
    NOP
    JR R7
    NOP
