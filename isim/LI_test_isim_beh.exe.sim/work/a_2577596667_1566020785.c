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
static const char *ng0 = "D:/THINPAD-MIPS16/src/ex.vhd";
extern char *WORK_P_2332286434;



static void work_a_2577596667_1566020785_p_0(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    int t12;

LAB0:    xsi_set_current_line(45, ng0);
    t1 = (t0 + 1032U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = ((WORK_P_2332286434) + 1168U);
    t4 = *((char **)t1);
    t5 = *((unsigned char *)t4);
    t6 = (t3 == t5);
    if (t6 != 0)
        goto LAB2;

LAB4:    xsi_set_current_line(48, ng0);
    t1 = (t0 + 1192U);
    t2 = *((char **)t1);
    t1 = ((WORK_P_2332286434) + 2128U);
    t4 = *((char **)t1);
    t12 = xsi_mem_cmp(t4, t2, 8U);
    if (t12 == 1)
        goto LAB6;

LAB8:
LAB7:    xsi_set_current_line(52, ng0);
    t1 = ((WORK_P_2332286434) + 1408U);
    t2 = *((char **)t1);
    t1 = (t0 + 5256);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t2, 16U);
    xsi_driver_first_trans_fast(t1);

LAB5:
LAB3:    t1 = (t0 + 5160);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(46, ng0);
    t1 = ((WORK_P_2332286434) + 1408U);
    t7 = *((char **)t1);
    t1 = (t0 + 5256);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t7, 16U);
    xsi_driver_first_trans_fast(t1);
    goto LAB3;

LAB6:    xsi_set_current_line(50, ng0);
    t1 = (t0 + 1512U);
    t7 = *((char **)t1);
    t1 = (t0 + 5256);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t7, 16U);
    xsi_driver_first_trans_fast(t1);
    goto LAB5;

LAB9:;
}

static void work_a_2577596667_1566020785_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    unsigned char t7;
    int t8;
    char *t9;
    char *t10;

LAB0:    xsi_set_current_line(59, ng0);
    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    t1 = (t0 + 5320);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 4U);
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(60, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t7 = *((unsigned char *)t2);
    t1 = (t0 + 5384);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = t7;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(61, ng0);
    t1 = (t0 + 1352U);
    t2 = *((char **)t1);
    t1 = ((WORK_P_2332286434) + 1888U);
    t3 = *((char **)t1);
    t8 = xsi_mem_cmp(t3, t2, 3U);
    if (t8 == 1)
        goto LAB3;

LAB5:
LAB4:    xsi_set_current_line(65, ng0);
    t1 = ((WORK_P_2332286434) + 1408U);
    t2 = *((char **)t1);
    t1 = (t0 + 5448);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 16U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t1 = (t0 + 5176);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(63, ng0);
    t1 = (t0 + 3432U);
    t4 = *((char **)t1);
    t1 = (t0 + 5448);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t9 = (t6 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t4, 16U);
    xsi_driver_first_trans_fast_port(t1);
    goto LAB2;

LAB6:;
}


extern void work_a_2577596667_1566020785_init()
{
	static char *pe[] = {(void *)work_a_2577596667_1566020785_p_0,(void *)work_a_2577596667_1566020785_p_1};
	xsi_register_didat("work_a_2577596667_1566020785", "isim/LI_test_isim_beh.exe.sim/work/a_2577596667_1566020785.didat");
	xsi_register_executes(pe);
}
