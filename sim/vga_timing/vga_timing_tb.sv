/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module.
 */

`timescale 1 ns / 1 ps

module vga_timing_tb;

import vga_pkg::*;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 25;     // 40 MHz


/**
 * Local variables and signals
 */

logic clk;
logic rst;
vga_if tim_out_if();

/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Reset generation
 */

initial begin
                       rst = 1'b0;
    #(1.25*CLK_PERIOD) rst = 1'b1;
                       rst = 1'b1;
    #(2.00*CLK_PERIOD) rst = 1'b0;
end


/**
 * Dut placement
 */

vga_timing dut(
    .clk,
    .rst,
    .out(tim_out_if)
);

/**
 * Tasks and functions
 */

 // Here you can declare tasks with immediate assertions (assert).


/**
 * Assertions
 */

// Here you can declare concurrent assertions (assert property).
assert property (@(posedge clk)(tim_out_if.hcount>=HOR_SYNC_START && tim_out_if.hcount <= HOR_SYNC_END) |-> tim_out_if.hsync==1)
else
begin
    $error("hsync dont work");
    $stop;
end

assert property (@(posedge clk)(tim_out_if.hcount>=HOR_BLANK_START && tim_out_if.hcount <= HOR_BLANK_END) |-> tim_out_if.hblnk==1)
else
begin
    $error("hblnk dont work");
    $stop;
end

assert property (@(posedge clk)(tim_out_if.vcount >= VER_SYNC_START && tim_out_if.vcount<=VER_SYNC_END) |-> tim_out_if.vsync==1)
else
begin
    $error("vsync dont work");
    $stop;
end

assert property (@(posedge clk)(tim_out_if.vcount >= VER_BLANK_START && tim_out_if.vcount<=VER_BLANK_END) |-> tim_out_if.vblnk==1)
else
begin
    $error("vblnk dont work");
    $stop;
end

/**
 * Main test
 */

initial begin
    @(posedge rst);
    @(negedge rst);

    wait (tim_out_if.vsync == 1'b0);
    @(negedge tim_out_if.vsync)
    @(negedge tim_out_if.vsync)
    $display("No errors detected!");
    $finish;
end

endmodule
