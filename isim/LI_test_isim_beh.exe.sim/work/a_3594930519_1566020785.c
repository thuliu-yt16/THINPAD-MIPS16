/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/THINPAD-MIPS16/src/inst_rom.vhd";
extern char *WORK_P_2332286434;
extern char *IEEE_P_3620187407;

int ieee_p_3620187407_sub_514432868_3965413181(char *, char *, char *);


static void work_a_3594930519_1566020785_p_0(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    int t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    xsi_set_current_line(27, ng0);
    t1 = (t0 + 1192U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = ((WORK_P_2332286434) + 1168U);
    t4 = *((char **)t1);
    t5 = *((unsigned char *)t4);
    t6 = (t3 == t5);
    if (t6 != 0)
        goto LAB2;

LAB4:    xsi_set_current_line(30, ng0);
    t1 = ((WORK_P_2332286434) + 1648U);
    t2 = *((char **)t1);
    t1 = (t0 + 3072);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t14 = *((char **)t8);
    memcpy(t14, t2, 16U);
    xsi_driver_first_trans_fast_port(t1);

LAB3:    t1 = (t0 + 2992);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(28, ng0);
    t1 = (t0 + 1512U);
    t7 = *((char **)t1);
    t1 = (t0 + 1032U);
    t8 = *((char **)t1);
    t1 = (t0 + 5072U);
    t9 = ieee_p_3620187407_sub_514432868_3965413181(IEEE_P_3620187407, t8, t1);
    t10 = (t9 - 0);
    t11 = (t10 * 1);
    xsi_vhdl_check_range_of_index(0, 1000, 1, t9);
    t12 = (16U * t11);
    t13 = (0 + t12);
    t14 = (t7 + t13);
    t15 = (t0 + 3072);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    memcpy(t19, t14, 16U);
    xsi_driver_first_trans_fast_port(t15);
    goto LAB3;

}


extern void work_a_3594930519_1566020785_init()
{
	static char *pe[] = {(void *)work_a_3594930519_1566020785_p_0};
	xsi_register_didat("work_a_3594930519_1566020785", "isim/LI_test_isim_beh.exe.sim/work/a_3594930519_1566020785.didat");
	xsi_register_executes(pe);
}
