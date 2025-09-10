/*
 * Copyright (c) 2024 geethikavijayarangan
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.09.2025 15:01:55
// Design Name: 
// Module Name: axi4lite_top
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

`default_nettype none
`timescale 1ns / 1ps

module tt_um_axi4lite_top #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 32
) (
    input  wire clk,
    input  wire rst_n,
    input  wire ena,

    input  wire [7:0] ui_in,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_oe,
    output wire [7:0] uio_out,
    output wire [7:0] uo_out

`ifdef GL_TEST
    ,input wire VPWR,
    input wire VGND
`endif
);

    // ------------------------
    // Internal wires
    // ------------------------
    wire [ADDR_WIDTH-1:0] awaddr;
    wire awvalid;
    wire awready;
    wire [DATA_WIDTH-1:0] wdata;
    wire wvalid;
    wire wready;
    wire [1:0] bresp;
    wire bvalid;
    wire bready;
    wire [ADDR_WIDTH-1:0] araddr;
    wire arvalid;
    wire arready;
    wire [DATA_WIDTH-1:0] rdata;
    wire [1:0] rresp;
    wire rvalid;
    wire rready;

    // ------------------------
    // Master instance
    // ------------------------
    axi4lite_master #(
        .C_M_AXI_ADDR_WIDTH(ADDR_WIDTH),
        .C_M_AXI_DATA_WIDTH(DATA_WIDTH)
    ) master_inst (
        .m_axi_aclk   (clk),
        .m_axi_aresetn(rst_n),

        .m_axi_awaddr (awaddr),
        .m_axi_awvalid(awvalid),
        .m_axi_awready(awready),
        .m_axi_wdata  (wdata),
        .m_axi_wvalid (wvalid),
        .m_axi_wready (wready),
        .m_axi_bresp  (bresp),
        .m_axi_bvalid (bvalid),
        .m_axi_bready (bready),
        .m_axi_araddr (araddr),
        .m_axi_arvalid(arvalid),
        .m_axi_arready(arready),
        .m_axi_rdata  (rdata),
        .m_axi_rresp  (rresp),
        .m_axi_rvalid (rvalid),
        .m_axi_rready (rready),

        // Control signals
        .start_write  (ui_in[0]),
        .write_data   (uio_in),
        .write_addr   (ui_in[2:1]),
        .start_read   (ui_in[4]),
        .read_addr    (ui_in[3:2]),
        .read_data    (uo_out)
    );

    // ------------------------
    // Slave instance
    // ------------------------
    axi4lite_slave #(
        .C_S_AXI_ADDR_WIDTH(ADDR_WIDTH),
        .C_S_AXI_DATA_WIDTH(DATA_WIDTH)
    ) slave_inst (
        .s_axi_aclk   (clk),
        .s_axi_aresetn(rst_n),

        .s_axi_awaddr (awaddr),
        .s_axi_awvalid(awvalid),
        .s_axi_awready(awready),
        .s_axi_wdata  (wdata),
        .s_axi_wvalid (wvalid),
        .s_axi_wready (wready),
        .s_axi_bresp  (bresp),
        .s_axi_bvalid (bvalid),
        .s_axi_bready (bready),
        .s_axi_araddr (araddr),
        .s_axi_arvalid(arvalid),
        .s_axi_arready(arready),
        .s_axi_rdata  (rdata),
        .s_axi_rresp  (rresp),
        .s_axi_rvalid (rvalid),
        .s_axi_rready (rready)
    );

    // ------------------------
    // Tie off unused signals
    // ------------------------
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule


