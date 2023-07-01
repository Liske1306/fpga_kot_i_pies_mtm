# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name kot_i_pies_mtm

# Top module name                               -- EDIT
set top_module top_fpga

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/top_fpga.xdc
    constraints/clk_wiz_0.xdc
    constraints/clk_wiz_0_late.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {
    ../rtl/top.sv
    ../rtl/variable_pkg.sv
    ../rtl/choose_player.sv
    ../rtl/set_wind.sv
    ../rtl/throw.sv
    ../rtl/turn_manager.sv
    ../rtl/bufor100_60.sv
    ../rtl/draw_background.sv
    ../rtl/vga_if.sv
    ../rtl/vga_timing.sv
    rtl/top_fpga.sv
}

# Specify Verilog design files location         -- EDIT
set verilog_files {
    rtl/clk_wiz_0.v
    rtl/clk_wiz_0_clk_wiz.v
}

# Specify VHDL design files location            -- EDIT
set vhdl_files {
    rtl/Ps2Interface.vhd
    ../rtl/MouseCtl.vhd
}

# Specify files for a memory initialization     -- EDIT
# set mem_files {
#    path/to/file.data
# }
