module cat_rom (
    input  logic clk60MHz,
    input  logic [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    input  logic [11:0] address1,  // address = {addry[5:0], addrx[5:0]}
    input  logic [11:0] address2,  // address = {addry[5:0], addrx[5:0]}
    input  logic [11:0] address3,  // address = {addry[5:0], addrx[5:0]}
    output logic [11:0] rgb,
    output logic [11:0] rgb1,
    output logic [11:0] rgb2,
    output logic [11:0] rgb3
);


/**
 * Local variables and signals
 */

reg [11:0] rom [0:4095];
reg [11:0] rom1 [0:4095];
reg [11:0] rom2 [0:4095];
reg [11:0] rom3 [0:4095];


/**
 * Memory initialization from a file
 */

/* Relative path from the simulation or synthesis working directory */
initial begin
    $readmemh("../rtl/cat.dat", rom);
    $readmemh("../rtl/cat1.dat", rom1);
    $readmemh("../rtl/cat2.dat", rom2);
    $readmemh("../rtl/cat3.dat", rom3);
end


/**
 * Internal logic
 */

always @(posedge clk60MHz) begin
    rgb <= rom[address];
    rgb1 <= rom1[address1];
    rgb2 <= rom2[address2];
    rgb3 <= rom3[address3];
end

endmodule
