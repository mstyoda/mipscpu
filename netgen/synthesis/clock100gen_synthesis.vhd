--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.20131013
--  \   \         Application: netgen
--  /   /         Filename: clock100gen_synthesis.vhd
-- /___/   /\     Timestamp: Sun Nov 19 14:01:57 2017
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -ar Structure -tm clock100gen -w -dir netgen/synthesis -ofmt vhdl -sim clock100gen.ngc clock100gen_synthesis.vhd 
-- Device	: xc3s1200e-4-fg320
-- Input file	: clock100gen.ngc
-- Output file	: E:\ShuDianShiYan\mipscpu\netgen\synthesis\clock100gen_synthesis.vhd
-- # of Entities	: 1
-- Design Name	: clock100gen
-- Xilinx	: D:\Xilinx\14.7\ISE_DS\ISE\
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity clock100gen is
  port (
    clk100 : out STD_LOGIC; 
    clk50 : in STD_LOGIC := 'X' 
  );
end clock100gen;

architecture Structure of clock100gen is
  signal N0 : STD_LOGIC; 
  signal clk100_OBUF_2 : STD_LOGIC; 
  signal clk100out : STD_LOGIC; 
  signal dfs_CLK0_BUF : STD_LOGIC; 
  signal dfs_CLK2X_BUF : STD_LOGIC; 
  signal dfs_CLKFB_IN : STD_LOGIC; 
  signal dfs_CLKIN_IBUFG : STD_LOGIC; 
  signal locked : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_CLK90_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_CLK180_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_CLK270_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_CLK2X180_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_CLKDV_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_CLKFX_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_CLKFX180_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_PSDONE_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_STATUS_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_STATUS_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_STATUS_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_STATUS_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_STATUS_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_STATUS_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_STATUS_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_dfs_DCM_SP_INST_STATUS_0_UNCONNECTED : STD_LOGIC; 
begin
  XST_GND : GND
    port map (
      G => N0
    );
  dfs_DCM_SP_INST : DCM_SP
    generic map(
      CLKDV_DIVIDE => 2.000000,
      CLKFX_DIVIDE => 1,
      CLKFX_MULTIPLY => 4,
      CLKIN_DIVIDE_BY_2 => FALSE,
      CLKIN_PERIOD => 20.000000,
      CLKOUT_PHASE_SHIFT => "NONE",
      CLK_FEEDBACK => "1X",
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
      DFS_FREQUENCY_MODE => "LOW",
      DLL_FREQUENCY_MODE => "LOW",
      DSS_MODE => "NONE",
      DUTY_CYCLE_CORRECTION => TRUE,
      PHASE_SHIFT => 0,
      STARTUP_WAIT => FALSE,
      FACTORY_JF => X"C080"
    )
    port map (
      CLKIN => dfs_CLKIN_IBUFG,
      CLKFB => dfs_CLKFB_IN,
      RST => N0,
      DSSEN => N0,
      PSINCDEC => N0,
      PSEN => N0,
      PSCLK => N0,
      CLK0 => dfs_CLK0_BUF,
      CLK90 => NLW_dfs_DCM_SP_INST_CLK90_UNCONNECTED,
      CLK180 => NLW_dfs_DCM_SP_INST_CLK180_UNCONNECTED,
      CLK270 => NLW_dfs_DCM_SP_INST_CLK270_UNCONNECTED,
      CLK2X => dfs_CLK2X_BUF,
      CLK2X180 => NLW_dfs_DCM_SP_INST_CLK2X180_UNCONNECTED,
      CLKDV => NLW_dfs_DCM_SP_INST_CLKDV_UNCONNECTED,
      CLKFX => NLW_dfs_DCM_SP_INST_CLKFX_UNCONNECTED,
      CLKFX180 => NLW_dfs_DCM_SP_INST_CLKFX180_UNCONNECTED,
      LOCKED => locked,
      PSDONE => NLW_dfs_DCM_SP_INST_PSDONE_UNCONNECTED,
      STATUS(7) => NLW_dfs_DCM_SP_INST_STATUS_7_UNCONNECTED,
      STATUS(6) => NLW_dfs_DCM_SP_INST_STATUS_6_UNCONNECTED,
      STATUS(5) => NLW_dfs_DCM_SP_INST_STATUS_5_UNCONNECTED,
      STATUS(4) => NLW_dfs_DCM_SP_INST_STATUS_4_UNCONNECTED,
      STATUS(3) => NLW_dfs_DCM_SP_INST_STATUS_3_UNCONNECTED,
      STATUS(2) => NLW_dfs_DCM_SP_INST_STATUS_2_UNCONNECTED,
      STATUS(1) => NLW_dfs_DCM_SP_INST_STATUS_1_UNCONNECTED,
      STATUS(0) => NLW_dfs_DCM_SP_INST_STATUS_0_UNCONNECTED
    );
  dfs_CLK2X_BUFG_INST : BUFG
    port map (
      I => dfs_CLK2X_BUF,
      O => clk100out
    );
  dfs_CLK0_BUFG_INST : BUFG
    port map (
      I => dfs_CLK0_BUF,
      O => dfs_CLKFB_IN
    );
  dfs_CLKIN_IBUFG_INST : IBUFG
    generic map(
      CAPACITANCE => "DONT_CARE",
      IBUF_DELAY_VALUE => "0",
      IBUF_LOW_PWR => TRUE,
      IOSTANDARD => "DEFAULT"
    )
    port map (
      I => clk50,
      O => dfs_CLKIN_IBUFG
    );
  clk1001 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => locked,
      I1 => clk100out,
      O => clk100_OBUF_2
    );
  clk100_OBUF : OBUF
    port map (
      I => clk100_OBUF_2,
      O => clk100
    );

end Structure;

