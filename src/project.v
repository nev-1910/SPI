`default_nettype none

module tt_um_spi_master (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,

    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,

    input  wire ena,
    input  wire clk,
    input  wire rst_n
);

    // FSM States
    localparam IDLE     = 2'b00;
    localparam LOAD     = 2'b01;
    localparam TRANSFER = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    reg mosi_reg;
    reg sclk_reg;
    reg cs_reg;
    reg busy_reg;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            state     <= IDLE;
            shift_reg <= 8'b0;
            bit_count <= 3'b0;

            mosi_reg  <= 1'b0;
            sclk_reg  <= 1'b0;
            cs_reg    <= 1'b1;
            busy_reg  <= 1'b0;

        end

        else begin

            case(state)

                //--------------------------------------------------
                IDLE:
                //--------------------------------------------------
                begin

                    cs_reg   <= 1'b1;
                    busy_reg <= 1'b0;
                    sclk_reg <= 1'b0;

                    if(uio_in[0]) begin
                        state <= LOAD;
                    end

                end

                //--------------------------------------------------
                LOAD:
                //--------------------------------------------------
                begin

                    shift_reg <= ui_in;
                    bit_count <= 3'b0;

                    cs_reg    <= 1'b0;
                    busy_reg  <= 1'b1;

                    state <= TRANSFER;

                end

                //--------------------------------------------------
                TRANSFER:
                //--------------------------------------------------
                begin

                    sclk_reg <= ~sclk_reg;

                    if(sclk_reg == 1'b0) begin

                        mosi_reg <= shift_reg[7];

                        shift_reg <= shift_reg << 1;

                        if(bit_count == 3'd7)
                            state <= DONE;
                        else
                            bit_count <= bit_count + 1;

                    end

                end

                //--------------------------------------------------
                DONE:
                //--------------------------------------------------
                begin

                    cs_reg   <= 1'b1;
                    busy_reg <= 1'b0;
                    sclk_reg <= 1'b0;

                    state <= IDLE;

                end

            endcase

        end

    end

    // Output Mapping
    assign uo_out[0] = mosi_reg;
    assign uo_out[1] = sclk_reg;
    assign uo_out[2] = cs_reg;
    assign uo_out[3] = busy_reg;

    assign uo_out[7:4] = 4'b0000;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire _unused = &{ena, uio_in[7:1], 1'b0};

endmodule
