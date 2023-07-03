 `timescale 1 ns / 1 ps

 module draw_mouse(
     input  logic clk60MHz,
     input  logic rst,
     
     input  logic [11:0] xpos,
     input  logic [11:0] ypos,
 
     vga_if.in in,
     vga_if.out out
 );
 
logic [11:0] rgb_nxt;

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
        out.vcount <= in.vcount;
        out.vsync  <= in.vsync;
        out.vblnk  <= in.vblnk;
        out.hcount <= in.hcount;
        out.hsync  <= in.hsync;
        out.hblnk  <= in.hblnk;
        out.rgb    <= rgb_nxt;
    end
end

 MouseDisplay u_MouseDisplay(
    .pixel_clk(clk60MHz),
    .xpos(xpos),
    .ypos(ypos),
    .hcount(in.hcount),
    .vcount(in.vcount),  
    .blank(in.vblnk||in.hblnk),
    .rgb_in(in.rgb), 
    .enable_mouse_display_out(),
    .rgb_out(rgb_nxt) 
);
 endmodule