module dog_rom (
    input  logic clk60MHz,
    input  logic [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    output logic [11:0] rgb
);


/**
 * Local variables and signals
 */

reg [11:0] rom [0:4095];


/**
 * Memory initialization from a file
 */

/* Relative path from the simulation or synthesis working directory */
initial $readmemh("../rtl/image_rom.data", rom);


/**
 * Internal logic
 */

always @(posedge clk60MHz)
    rgb <= rom[address];

endmodule
