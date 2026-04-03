module uart_tx #(
    parameter CLKS_PER_BIT = 5208   // 50MHz / 9600
)(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_done
);
reg [12:0] clk_count = 0;
reg [3:0] bit_index = 0;
reg [9:0] tx_shift = 10'b1111111111;
reg sending = 0;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx <= 1;
        sending <= 0;
        tx_done <= 0;
    end
    else begin
        tx_done <= 0;
        if (tx_start && !sending) begin
            tx_shift <= {1'b1, tx_data, 1'b0}; // stop + data + start
            sending <= 1;
            clk_count <= 0;
            bit_index <= 0;
        end
        else if (sending) begin
            if (clk_count < CLKS_PER_BIT - 1)
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;
                tx <= tx_shift[bit_index];
                bit_index <= bit_index + 1;
                if (bit_index == 9) begin
                    sending <= 0;
                    tx_done <= 1;
                    tx <= 1; // idle
                end
            end
        end
    end
end
endmodule
