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
    SLL R1 R1 0x0000 ; R1 get first byte

    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00BF
    SLL R6 R6 0x0000
    LW R6 R2 0x0000 ; R2 get second byte

    ADDU R1 R2 R1
    ;OR R1 R2 ; R1 complete inst
    LI R5 0x00BF
    SLL R5 R5 0x0000
    SW R5 R1 0x0004

LOOP:
    B BEGIN
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
