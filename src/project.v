/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
    dino_rom rom (clk, ~rst_n, ui_in[5:0], uo_out[0]);
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

module dino_rom (
  input  wire       clk,      // clock
  input  wire       rst, 
  input wire [5:0] i_rom_counter,
  output reg  o_sprite_color
);

reg [2:0] rom_x;
reg [2:0] rom_y;
always @(*) begin
  {rom_y, rom_x} = i_rom_counter;
end
reg [7:0] icon [7:0];

always @(posedge clk or posedge rst) begin
  if (rst) begin
    icon[0] <= 8'b01110000;
    icon[1] <= 8'b11110000;
    icon[2] <= 8'b00110000;
    icon[3] <= 8'b00111001;
    icon[4] <= 8'b00111111;
    icon[5] <= 8'b00011110;
    icon[6] <= 8'b00010100;
    icon[7] <= 8'b00010100;
  end
end

always @(*) begin
  o_sprite_color = icon[rom_y][rom_x];
end

endmodule
