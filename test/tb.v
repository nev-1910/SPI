`timescale 1ns / 1ps

module tb;

    reg [7:0] ui_in;
    wire [7:0] uo_out;

    reg [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    reg ena;
    reg clk;
    reg rst_n;

    tt_um_spi_master dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        ena = 1;
        rst_n = 0;

        ui_in = 8'b10110011;
        uio_in = 8'b00000000;

        #20;

        rst_n = 1;

        #20;

        uio_in[0] = 1'b1;

        #20;

        uio_in[0] = 1'b0;

        #500;

        $finish;

    end

endmodule
