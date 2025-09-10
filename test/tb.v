`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.09.2025 15:03:13
// Design Name: 
// Module Name: axi4lite_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

`timescale 1ns/1ps
`default_nettype none

module tb();

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Dump VCD
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // Clock
  initial clk = 0;
  always #5 clk = ~clk;

  // DUT
  tt_um_axi4lite_top dut (
    .clk    (clk),
    .rst_n  (rst_n),
    .ena    (ena),
    .ui_in  (ui_in),
    .uo_out (uo_out),
    .uio_in (uio_in),
    .uio_out(uio_out),
    .uio_oe (uio_oe)
  `ifdef GL_TEST
    ,.VPWR(VPWR),
    ,.VGND(VGND)
  `endif
  );

  // Stimulus
  initial begin
    rst_n = 0; ena = 0; ui_in = 0; uio_in = 0;
    #20;
    rst_n = 1; ena = 1;
    #10;

    // Example write
    ui_in[0]   = 1;       // start_write
    ui_in[2:1] = 2'b01;   // write addr
    uio_in     = 8'hAA;   // write data
    #40;
    ui_in[0]   = 0;

    // Example read
    ui_in[4]   = 1;       // start_read
    ui_in[3:2] = 2'b01;   // read addr
    #40;
    ui_in[4]   = 0;

    #100 $finish;
  end

  // Monitor
  initial begin
    $monitor("T=%0t clk=%b rst_n=%b ena=%b ui_in=%b uo_out=%h uio_out=%h",
              $time, clk, rst_n, ena, ui_in, uo_out, uio_out);
  end

endmodule
