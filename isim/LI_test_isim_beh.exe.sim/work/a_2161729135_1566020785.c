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
static const char *ng0 = "D:/THINPAD-MIPS16/src/id_ex.vhd";
extern char *WORK_P_2332286434;



static void work_a_2161729135_1566020785_p_0(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    char *t7;
    unsigned char t8;
    unsigned char t9;
    char *t10;
    unsigned char t11;
    char *t12;
    unsigned char t13;
    unsigned char t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    xsi_set_current_line(49, ng0);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 5232);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(50, ng0);
    t4 = (t0 + 1192U);
    t10 = *((char **)t4);
    t11 = *((unsigned char *)t10);
    t4 = ((WORK_P_2332286434) + 1168U);
    t12 = *((char **)t4);
    t13 = *((unsigned char *)t12);
    t14 = (t11 == t13);
    if (t14 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(59, ng0);
    t2 = (t0 + 1672U);
    t4 = *((char **)t2);
    t2 = (t0 + 5376);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 8U);
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(60, ng0);
    t2 = (t0 + 1832U);
    t4 = *((char **)t2);
    t2 = (t0 + 5312);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 3U);
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(61, ng0);
    t2 = (t0 + 1992U);
    t4 = *((char **)t2);
    t2 = (t0 + 5440);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 16U);
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(62, ng0);
    t2 = (t0 + 2152U);
    t4 = *((char **)t2);
    t2 = (t0 + 5504);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 16U);
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(63, ng0);
    t2 = (t0 + 2312U);
    t4 = *((char **)t2);
    t2 = (t0 + 5568);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 4U);
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(64, ng0);
    t2 = (t0 + 2472U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 5632);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    *((unsigned char *)t12) = t1;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(65, ng0);
    t2 = (t0 + 2632U);
    t4 = *((char **)t2);
    t2 = (t0 + 5696);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 16U);
    xsi_driver_first_trans_fast_port(t2);

LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t4 = ((WORK_P_2332286434) + 1168U);
    t7 = *((char **)t4);
    t8 = *((unsigned char *)t7);
    t9 = (t6 == t8);
    t1 = t9;
    goto LAB7;

LAB8:    xsi_set_current_line(51, ng0);
    t4 = ((WORK_P_2332286434) + 1768U);
    t15 = *((char **)t4);
    t4 = (t0 + 5312);
    t16 = (t4 + 56U);
    t17 = *((char **)t16);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    memcpy(t19, t15, 3U);
    xsi_driver_first_trans_fast_port(t4);
    xsi_set_current_line(52, ng0);
    t2 = ((WORK_P_2332286434) + 2248U);
    t4 = *((char **)t2);
    t2 = (t0 + 5376);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 8U);
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(53, ng0);
    t2 = ((WORK_P_2332286434) + 1408U);
    t4 = *((char **)t2);
    t2 = (t0 + 5440);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 16U);
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(54, ng0);
    t2 = ((WORK_P_2332286434) + 1408U);
    t4 = *((char **)t2);
    t2 = (t0 + 5504);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 16U);
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(55, ng0);
    t2 = ((WORK_P_2332286434) + 1528U);
    t4 = *((char **)t2);
    t2 = (t0 + 5568);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 4U);
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(56, ng0);
    t2 = ((WORK_P_2332286434) + 1288U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 5632);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    *((unsigned char *)t12) = t1;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(57, ng0);
    t2 = ((WORK_P_2332286434) + 1648U);
    t4 = *((char **)t2);
    t2 = (t0 + 5696);
    t5 = (t2 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t4, 16U);
    xsi_driver_first_trans_fast_port(t2);
    goto LAB9;

}


extern void work_a_2161729135_1566020785_init()
{
	static char *pe[] = {(void *)work_a_2161729135_1566020785_p_0};
	xsi_register_didat("work_a_2161729135_1566020785", "isim/LI_test_isim_beh.exe.sim/work/a_2161729135_1566020785.didat");
	xsi_register_executes(pe);
}
