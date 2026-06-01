`default_nettype none

module tt_um_spi_master_slave (

    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,

    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,

    input  wire ena,
    input  wire clk,
    input  wire rst_n

);

    //--------------------------------------------------
    // SPI Signals
    //--------------------------------------------------

    wire mosi;
    wire miso;
    wire sclk;
    wire cs;

    wire done;

    wire [7:0] master_rx;
    wire [7:0] slave_rx;
    wire _unused_master = &master_rx[7:1];
    wire _unused_slave  = &slave_rx[7:1];

    //--------------------------------------------------
    // Master
    //--------------------------------------------------

    spi_master MASTER (

        .clk(clk),
        .rst_n(rst_n),

        .start(ui_in[0]),

        .tx_data(8'hB3),

        .miso(miso),

        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),

        .rx_data(master_rx),
        .done(done)

    );

    //--------------------------------------------------
    // Slave
    //--------------------------------------------------

    spi_slave SLAVE (

        .sclk(sclk),
        .cs(cs),

        .mosi(mosi),

        .tx_data(8'hCC),

        .miso(miso),

        .rx_data(slave_rx)

    );

    //--------------------------------------------------
    // Output Mapping
    //--------------------------------------------------

    assign uo_out[0] = mosi;
    assign uo_out[1] = miso;
    assign uo_out[2] = sclk;
    assign uo_out[3] = cs;
    assign uo_out[4] = done;

    assign uo_out[5] = master_rx[0];
    assign uo_out[6] = slave_rx[0];
    assign uo_out[7] = 1'b0;

    //--------------------------------------------------
    // Unused IO
    //--------------------------------------------------

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire _unused = &{
        ena,
        uio_in,
        ui_in[7:1],
        1'b0
    };

endmodule
