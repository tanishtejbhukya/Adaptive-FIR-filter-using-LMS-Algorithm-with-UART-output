module LMS(
    input Clk, Rst,
    input signed [15:0] x_in,
    output signed [15:0] y_out,
    output signed [15:0] w0, w1, w2, w3,
    output signed [15:0] err
);
parameter signed [15:0] gamma = 16'b0000001100110011; // gamma = 0.2
reg signed [15:0] wn[0:3], x[0:3];
wire signed [15:0] wn_u[0:3];
wire signed [15:0] fir_out, m1, m2, m3, m4, m12, m22, m32, m42;
wire signed [31:0] m11, m21, m31, m41, m13, m23, m33, m43, y_out1;
reg signed [15:0] d_in;
FIR_Filter fir (
    .Clk(Clk),
    .Rst(Rst),
    .x(x_in),
    .d(fir_out)
);
always @(*) begin
    if (Rst)
        d_in = 16'b0;
    else
        d_in = fir_out;
end
always @(posedge Clk or posedge Rst) begin
    if (Rst) begin
        x[3] <= 16'b0;
        x[2] <= 16'b0;
        x[1] <= 16'b0;
        x[0] <= 16'b0;
    end
    else begin
        x[3] <= x[2];
        x[2] <= x[1];
        x[1] <= x[0];
        x[0] <= x_in;
    end
end
assign y_out1 = $signed(wn[0]) * $signed(x[0]) +
                $signed(wn[1]) * $signed(x[1]) +
                $signed(wn[2]) * $signed(x[2]) +
                $signed(wn[3]) * $signed(x[3]);
assign y_out = y_out1[27:12];
assign m11 = $signed(err) * $signed(x[0]);
assign m12 = m11[27:12];
assign m13 = $signed(gamma) * $signed(m12);
assign m1  = m13[27:12];
assign m21 = $signed(err) * $signed(x[1]);
assign m22 = m21[27:12];
assign m23 = $signed(gamma) * $signed(m22);
assign m2  = m23[27:12];
assign m31 = $signed(err) * $signed(x[2]);
assign m32 = m31[27:12];
assign m33 = $signed(gamma) * $signed(m32);
assign m3  = m33[27:12];
assign m41 = $signed(err) * $signed(x[3]);
assign m42 = m41[27:12];
assign m43 = $signed(gamma) * $signed(m42);
assign m4  = m43[27:12];
assign wn_u[0] = wn[0] + m1;
assign wn_u[1] = wn[1] + m2;
assign wn_u[2] = wn[2] + m3;
assign wn_u[3] = wn[3] + m4;
always @(posedge Clk or posedge Rst) begin
    if (Rst) begin
        wn[0] <= 16'b0;
        wn[1] <= 16'b0;
        wn[2] <= 16'b0;
        wn[3] <= 16'b0;
    end
    else begin
        wn[0] <= wn_u[0];
        wn[1] <= wn_u[1];
        wn[2] <= wn_u[2];
        wn[3] <= wn_u[3];
    end
end
assign w0 = wn[0];
assign w1 = wn[1];
assign w2 = wn[2];
assign w3 = wn[3];
assign err = d_in - y_out;
endmodule
