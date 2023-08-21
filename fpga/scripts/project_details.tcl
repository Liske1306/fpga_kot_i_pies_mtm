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
    ../rtl/mechanics/variable_pkg.sv
    ../rtl/mechanics/choose_player.sv
    ../rtl/mechanics/set_wind.sv
    ../rtl/mechanics/throw.sv
    ../rtl/mechanics/simulate.sv
    ../rtl/mechanics/set_speed.sv
    ../rtl/mechanics/set_ypos.sv
    ../rtl/mechanics/turn_manager.sv
    ../rtl/mechanics/win_loose.sv
    ../rtl/mechanics/vga/vga_if.sv
    ../rtl/mechanics/vga/vga_timing.sv
    ../rtl/graphic_interface/draw_background.sv
    ../rtl/graphic_interface/cat/cat_rom.sv
    ../rtl/graphic_interface/cat/draw_cat.sv
    ../rtl/graphic_interface/crate_doghouse/crate_rom.sv
    ../rtl/graphic_interface/crate_doghouse/draw_crate.sv
    ../rtl/graphic_interface/crate_doghouse/draw_doghouse.sv
    ../rtl/graphic_interface/dog/dog_rom.sv
    ../rtl/graphic_interface/dog/draw_dog.sv
    ../rtl/graphic_interface/interface/draw_mouse.sv
    ../rtl/graphic_interface/interface/draw_hp_wind.sv
    ../rtl/graphic_interface/interface/draw_power.sv
    ../rtl/graphic_interface/particle/particle_rom.sv
    ../rtl/graphic_interface/particle/draw_particle.sv
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
    ../rtl/mechanics/vga/MouseCtl.vhd
    ../rtl/mechanics/vga/MouseDisplay.vhd
}

# Specify files for a memory initialization     -- EDIT
 set mem_files {
    ../rtl/img/crate.dat
    ../rtl/img/cat.dat
    ../rtl/img/cat1.dat
    ../rtl/img/cat2.dat
    ../rtl/img/cat3.dat
    ../rtl/img/dog.dat
    ../rtl/img/dog1.dat
    ../rtl/img/dog2.dat
    ../rtl/img/dog3.dat
    ../rtl/img/particle.dat
 }
