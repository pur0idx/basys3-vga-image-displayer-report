module image_pixel_controller (
    input sw,
    input wire clk,
    input wire reset,
    input wire [9:0] curr_x,
    input wire [9:0] curr_y,
    input wire video_on,
    output wire [7:0] pixel_rgb
);

    wire [7:0] rom_data;
    reg [17:0] rom_addr;

    blk_mem_gen_0 (
        .addra(rom_addr),
        .clka(clk),
        .douta(rom_data),
        .rsta(reset)
    );

    always @(*) begin
        if (video_on && curr_x < 640 && curr_y < 480) begin
            // Scale 640x480 down to 320x240
            rom_addr = (curr_y >> 1) * 320 + (curr_x >> 1);
        end else begin
            rom_addr = 0;
        end
        rom_addr = (sw) ? rom_addr + 76800: rom_addr;
    end

    assign pixel_rgb = rom_data;

endmodule
