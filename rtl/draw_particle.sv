 `timescale 1 ns / 1 ps

module draw_particle(
    input  logic clk60MHz,
    input  logic rst,
    input  logic turn,
     
    input  logic [11:0] xpos_particle,
    input  logic [11:0] ypos_particle,
    input  logic [11:0] rgb_pixel1,
    input  logic [11:0] rgb_pixel2,
    output logic [11:0] pixel_addr,
 
    vga_if.in in,
    vga_if.out out
);

import variable_pkg::*;

logic [11:0] rgb_nxt;
wire [9:0] addrx, addry;

logic [11:0] rgb_temp;
logic [10:0] vcount_temp, hcount_temp;
logic vsync_temp, vblnk_temp, hsync_temp, hblnk_temp;

always_ff @(posedge clk60MHz) begin
    if (rst) begin
        vcount_temp <= '0;
        vsync_temp  <= '0;
        vblnk_temp  <= '0;
        hcount_temp <= '0;
        hsync_temp  <= '0;
        hblnk_temp  <= '0;
        rgb_temp    <= '0;
    end 
    else begin
        vcount_temp <= in.vcount;
        vsync_temp  <= in.vsync;
        vblnk_temp  <= in.vblnk;
        hcount_temp <= in.hcount;
        hsync_temp  <= in.hsync;
        hblnk_temp  <= in.hblnk;
        rgb_temp    <= in.rgb;
    end
end

always_ff @(posedge clk60MHz) begin
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
    end 
    else begin
        out.vcount <= vcount_temp;
        out.vsync  <= vsync_temp;
        out.vblnk  <= vblnk_temp;
        out.hcount <= hcount_temp;
        out.hsync  <= hsync_temp;
        out.hblnk  <= hblnk_temp;
        out.rgb    <= rgb_nxt;
    end
end

always_comb begin
    if(!vblnk_temp && !hblnk_temp) begin
        if((hcount_temp >= xpos_particle)&&(hcount_temp < xpos_particle + PARTICLE_WIDTH)&&(vcount_temp >= ypos_particle)&&(vcount_temp < ypos_particle + PARTICLE_HEIGHT)) begin
            if(turn == PLAYER_1) begin
                rgb_nxt = rgb_pixel1;
            end
            else begin
                rgb_nxt = rgb_pixel2;
            end
        end
        else begin
            rgb_nxt = rgb_temp;  
        end
    end
    else begin
        rgb_nxt = rgb_temp;
    end
end

assign addry = in.vcount - ypos_particle;
assign addrx = in.hcount - xpos_particle;
assign pixel_addr = {addry[5:0], addrx[5:0]};

endmodule
