module top (
    input wire clk,
    input wire [15:0] sw,
    input wire [4:0] pb,
    output wire tx
);
// --------------------------------------------------
// RESET
// --------------------------------------------------
wire rst = pb[0];
// --------------------------------------------------
// BUTTON EDGE DETECTION (pb[1])
// --------------------------------------------------
reg pb1_d;
always @(posedge clk)
    pb1_d <= pb[1];
wire send_pulse;
assign send_pulse = pb[1] & ~pb1_d;
// --------------------------------------------------
// LATCH SWITCH INPUT
// --------------------------------------------------
reg [15:0] x_sample;
always @(posedge clk) begin
    if (send_pulse)
        x_sample <= sw;
end
// --------------------------------------------------
// LMS OUTPUTS
// --------------------------------------------------
wire signed [15:0] y_out;
wire signed [15:0] err;
// --------------------------------------------------
// LMS INSTANCE
// --------------------------------------------------
LMS lms_inst (
    .Clk(clk),
    .Rst(rst),
    .x_in(x_sample),
    .y_out(y_out),
    .err(err)
);
// --------------------------------------------------
// UART CONTROLLER
// --------------------------------------------------
UART_controller uart_ctrl (
    .clk(clk),
    .rst(rst),
    .send_btn(send_pulse),
    .y(y_out),
    .e(err),
    .tx(tx)
);
endmodule
