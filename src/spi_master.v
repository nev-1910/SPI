module spi_master(

    input clk,
    input rst_n,
    input start,

    input [7:0] tx_data,
    input miso,

    output reg mosi,
    output reg sclk,
    output reg cs,

    output reg [7:0] rx_data,
    output reg done

);

reg [7:0] tx_shift;
reg [7:0] rx_shift;

reg [2:0] bit_count;

localparam IDLE     = 2'b00;
localparam TRANSFER = 2'b01;
localparam DONE     = 2'b10;

reg [1:0] state;

always @(posedge clk or negedge rst_n)
begin

    if(!rst_n)
    begin

        state <= IDLE;

        tx_shift <= 8'b0;
        rx_shift <= 8'b0;

        bit_count <= 3'b0;

        mosi <= 1'b0;
        sclk <= 1'b0;
        cs   <= 1'b1;

        rx_data <= 8'b0;
        done <= 1'b0;

    end

    else
    begin

        case(state)

            IDLE:
            begin

                cs <= 1'b1;
                sclk <= 1'b0;
                done <= 1'b0;

                if(start)
                begin
                    tx_shift <= tx_data;
                    rx_shift <= 8'b0;
                    bit_count <= 3'b0;

                    cs <= 1'b0;

                    state <= TRANSFER;
                end

            end

            TRANSFER:
            begin

                sclk <= ~sclk;

                if(sclk == 1'b0)
                begin

                    mosi <= tx_shift[7];

                    tx_shift <= tx_shift << 1;

                    rx_shift <= {rx_shift[6:0], miso};

                    if(bit_count == 3'd7)
                    begin
                        rx_data <= {rx_shift[6:0], miso};
                        state <= DONE;
                    end

                    else
                    begin
                        bit_count <= bit_count + 1'b1;
                    end

                end

            end

            DONE:
            begin

                cs <= 1'b1;
                sclk <= 1'b0;

                done <= 1'b1;

                state <= IDLE;

            end

            default:
            begin
                state <= IDLE;
            end

        endcase

    end

end

wire _unused_master_rxshift;
assign _unused_master_rxshift = rx_shift[7];

endmodule
