module UART_controller (
    input clk,
    input rst,
    input send_btn,
    input signed [15:0] y,
    input signed [15:0] e,
    output tx
);
wire tx_done;
reg tx_start;
reg [7:0] tx_data;
reg [3:0] index;
reg sending;
reg [7:0] message [0:14];  // 15 chars
// UART TX instance
uart_tx uart (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_done(tx_done)
);
// Convert hex to ASCII
wire [7:0] y3,y2,y1,y0,e3,e2,e1,e0;
hex_to_ascii h0(y[15:12], y3);
hex_to_ascii h1(y[11:8],  y2);
hex_to_ascii h2(y[7:4],   y1);
hex_to_ascii h3(y[3:0],   y0);
hex_to_ascii h4(e[15:12], e3);
hex_to_ascii h5(e[11:8],  e2);
hex_to_ascii h6(e[7:4],   e1);
hex_to_ascii h7(e[3:0],   e0);
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sending <= 0;
        index <= 0;
        tx_start <= 0;
    end
    else begin
        tx_start <= 0;
        if (send_btn && !sending) begin
            // Build message: Y=XXXX E=XXXX\n
            message[0]  <= "Y";
            message[1]  <= "=";
            message[2]  <= y3;
            message[3]  <= y2;
            message[4]  <= y1;
            message[5]  <= y0;
            message[6]  <= " ";
            message[7]  <= "E";
            message[8]  <= "=";
            message[9]  <= e3;
            message[10] <= e2;
            message[11] <= e1;
            message[12] <= e0;
            message[13] <= "\r";
            message[14] <= "\n";
            sending <= 1;
            index <= 0;
        end
        else if (sending) begin
            if (!tx_start && !tx_done) begin
                tx_data <= message[index];
                tx_start <= 1;
            end
            else if (tx_done) begin
                if (index < 14)
                    index <= index + 1;
                else
                    sending <= 0;
            end
        end
    end
end
endmodule
