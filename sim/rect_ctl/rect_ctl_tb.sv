/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for top_vga.
 * Thanks to the tiff_writer module, an expected image
 * produced by the project is exported to a tif file.
 * Since the vs signal is connected to the go input of
 * the tiff_writer, the first (top-left) pixel of the tif
 * will not correspond to the vga project (0,0) pixel.
 * The active image (not blanked space) in the tif file
 * will be shifted down by the number of lines equal to
 * the difference between VER_SYNC_START and VER_TOTAL_TIME.
 */

`timescale 1 ns / 1 ps

module rect_ctl_tb;


/**
 *  Local parameters
 */

localparam CLK_PERIOD_40 = 25;     // 40 MHz

/**
 * Local variables and signals
 */

logic clk;
logic rst;
logic left;
logic [11:0]xpos = '0;
logic [11:0]ypos = '0;
logic [11:0]rect_xpos;
logic [11:0]rect_ypos;

/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD_40/2) clk = ~clk;
end

/**
 * Submodules instances
 */

draw_rect_ctl dut(
    .clk(clk),
    .rst,
    .mouse_left(left),
    .mouse_xpos(xpos),
    .mouse_ypos(ypos),
    .xpos(rect_xpos),
    .ypos(rect_ypos)
);


/**
 * Main test
 */

initial begin
    rst = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;
    # 30 left = 1'b0;
    # 30 left = 1'b1;
    # 30 left = 1'b0;
    #1000000 rst = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;
    # 30 left = 1'b0;
    # 30 left = 1'b1;
    # 30 left = 1'b0;
    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $finish;
end

endmodule
