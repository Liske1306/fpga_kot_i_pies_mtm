/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Robert Szczygiel
 * Modified: Piotr Kaczmarczyk, Karolina Sawosz
 *
 */

module crate_rom (
    input  logic clk60MHz,
    input  logic [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    input  logic [11:0] address1,  // address1 = {addry[5:0], addrx[5:0]}
    output logic [11:0] rgb,
    output logic [11:0] rgb1
);


/**
 * Local variables and signals
 */

reg [11:0] rom [0:4095];


/**
 * Memory initialization from a file
 */

/* Relative path from the simulation or synthesis working directory */
initial $readmemh("../rtl/crate.dat", rom);


/**
 * Internal logic
 */

always @(posedge clk60MHz) begin
    rgb <= rom[address];
    rgb1 <= rom[address1];
end

endmodule
