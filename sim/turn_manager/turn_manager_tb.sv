`timescale 1 ns / 1 ps

module turn_manager_tb;

localparam CLK_PERIOD_60 = 17;     // 60 MHz

logic clk60MHz, rst, in_throw_flag, throw_flag;
logic [2:0] turn;

initial begin
    clk60MHz = 1'b0;
    forever #(CLK_PERIOD_60/2) clk60MHz = ~clk60MHz;
end

turn_manager dut (
    .clk60MHz,
    .rst,
    .throw_flag,
    .in_throw_flag,
    .turn
);

initial begin
    rst = 1'b0;
    throw_flag = 1'b0;
    in_throw_flag = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;
    $display(turn);
    # 60 throw_flag = 1'b1;
    # 60 throw_flag = 1'b0;
    # 60 $display(turn);
    # 60 in_throw_flag = 1'b1;
    # 60 in_throw_flag = 1'b0;
    # 60 $display(turn);
    $finish;
end

endmodule
