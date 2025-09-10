`timescale 1ns / 1ps
`default_nettype none

module tb;

    localparam ADDR_WIDTH = 2;
    localparam DATA_WIDTH = 8;

    reg clk;
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uio_oe;
    wire [7:0] uio_out;
    wire [7:0] uo_out;

    tt_um_axi4lite_top #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .ena    (ena),
        .ui_in  (ui_in),
        .uio_in (uio_in),
        .uio_oe (uio_oe),
        .uio_out(uio_out),
        .uo_out (uo_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz
    end

    initial begin
        rst_n  = 0;
        ena    = 1;
        ui_in  = 0;
        uio_in = 0;

        #20 rst_n = 1;

        // ---------------- WRITE ----------------
        #20;
        ui_in[0]   = 1;        // start_write
        ui_in[2:1] = 2'h2;     // write_addr
        uio_in     = 8'h4;     // write data
        #10 ui_in[0] = 0;      // deassert start_write
        wait(uo_out[0] == 1);  // wait for done
        $display("WRITE: Addr=0x%h Data=0x%h", 2, uio_in);

        // ---------------- READ ----------------
        #20;
        ui_in[4]   = 1;        // start_read
        ui_in[5:4] = 2'h2;     // read_addr (updated to new bits)
        #10 ui_in[4] = 0;      // deassert start_read
        wait(uo_out[0] == 1);  // wait for done
        $display("READ:  Addr=0x%h Data=0x%h", 2, uio_out);

        // ---------------- CHECK ----------------
        if (uio_out == 8'h4)
            $display("TEST PASSED ✅");
        else
            $display("TEST FAILED ❌ (Expected 0x04, Got 0x%h)", uio_out);

        #100 $finish;
    end

endmodule
