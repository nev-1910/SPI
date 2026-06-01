module spi_slave(

    input sclk,
    input cs,

    input mosi,

    input [7:0] tx_data,

    output reg miso,

    output reg [7:0] rx_data

);

reg [7:0] tx_shift;
reg [7:0] rx_shift;
reg [2:0] bit_count;

always @(posedge sclk or posedge cs)
begin

    if(cs)
    begin

        tx_shift <= tx_data;
        rx_shift <= 8'b0;

        bit_count <= 3'b0;

        miso <= 1'b0;
        rx_data <= 8'b0;

    end

    else
    begin

        miso <= tx_shift[7];

        tx_shift <= tx_shift << 1;

        rx_shift <= {rx_shift[6:0], mosi};

        if(bit_count == 3'd7)
        begin

            rx_data <= {rx_shift[6:0], mosi};

        end

        else
        begin

            bit_count <= bit_count + 1'b1;

        end

    end

end

endmodule
