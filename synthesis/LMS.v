module LMS(
    input Clk, 
    input Rst,
    input signed [15:0] x_in,
    output signed [15:0] y_out,
    output signed [15:0] err
);
parameter signed [15:0] gamma = 16'b0000001100110011;
reg signed [15:0] wn[0:3];
reg signed [15:0] x[0:3];
wire signed [15:0] fir_out;
reg signed [15:0] d_in;
// FIR block
FIR_filter fir (
    .Clk(Clk),
    .Rst(Rst),
    .x(x_in),
    .d(fir_out)
);
// Delay line
always @(posedge Clk or posedge Rst) begin
    if (Rst) begin
        x[0] <= 0; x[1] <= 0; x[2] <= 0; x[3] <= 0;
    end else begin
        x[3] <= x[2];
        x[2] <= x[1];
        x[1] <= x[0];
        x[0] <= x_in;
    end
end
// Desired signal register (IMPORTANT FIX)
always @(posedge Clk or posedge Rst) begin
    if (Rst)
        d_in <= 0;
    else
        d_in <= fir_out;
end
// Output calculation
wire signed [31:0] y_temp;
assign y_temp =
    wn[0]*x[0] +
    wn[1]*x[1] +
    wn[2]*x[2] +
    wn[3]*x[3];
assign y_out = y_temp[27:12];
// Error
assign err = d_in - y_out;
// LMS weight update
wire signed [15:0] m1, m2, m3, m4;
assign m1 = ((err * x[0]) >>> 12) * gamma >>> 12;
assign m2 = ((err * x[1]) >>> 12) * gamma >>> 12;
assign m3 = ((err * x[2]) >>> 12) * gamma >>> 12;
assign m4 = ((err * x[3]) >>> 12) * gamma >>> 12;
// Weight update
always @(posedge Clk or posedge Rst) begin
    if (Rst) begin
        wn[0] <= 0;
        wn[1] <= 0;
        wn[2] <= 0;
        wn[3] <= 0;
    end else begin
        wn[0] <= wn[0] + m1;
        wn[1] <= wn[1] + m2;
        wn[2] <= wn[2] + m3;
        wn[3] <= wn[3] + m4;
    end
end
endmodule
