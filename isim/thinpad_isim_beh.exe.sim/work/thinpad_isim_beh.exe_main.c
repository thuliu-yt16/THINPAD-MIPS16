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

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_3620187407;
char *IEEE_P_2592010699;
char *STD_STANDARD;
char *IEEE_P_1242562249;
char *WORK_P_2332286434;
char *IEEE_P_3499444699;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    work_p_2332286434_init();
    ieee_p_1242562249_init();
    work_a_1991350011_1566020785_init();
    work_a_1009422619_1566020785_init();
    work_a_3379253520_1566020785_init();
    work_a_2161729135_1566020785_init();
    work_a_2577596667_1566020785_init();
    work_a_2657849955_1566020785_init();
    work_a_3501706103_1566020785_init();
    work_a_0720342707_1566020785_init();
    work_a_2934098902_1566020785_init();
    work_a_2023191012_1566020785_init();
    work_a_1415465652_1566020785_init();
    work_a_3594930519_1566020785_init();
    work_a_3830602496_1566020785_init();
    work_a_0338969978_1566020785_init();


    xsi_register_tops("work_a_0338969978_1566020785");

    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    WORK_P_2332286434 = xsi_get_engine_memory("work_p_2332286434");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");

    return xsi_run_simulation(argc, argv);

}
