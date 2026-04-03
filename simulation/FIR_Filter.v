module FIR_Filter(
    input Clk,
    input Rst,
    input signed [15:0] x,
    output signed [15:0] d
);
reg signed [15:0] w0, w1, w2, w3;
reg signed [15:0] xn_0, xn_1, xn_2, xn_3;
reg signed [31:0] d1;
always @(posedge Clk or posedge Rst) begin
    if (Rst) begin
        xn_0 <= 0;
        xn_1 <= 0;
        xn_2 <= 0;
        xn_3 <= 0;
        d1   <= 0;
        w0   <= 16'b0000100000000000;
        w1   <= 16'b0000100000000000;
        w2   <= 16'b0000100000000000;
        w3   <= 16'b0000100000000000;
    end
    else begin
        xn_3 <= xn_2;
        xn_2 <= xn_1;
        xn_1 <= xn_0;
        xn_0 <= x;
        d1   <= w0*xn_0 + w1*xn_1 + w2*xn_2 + w3*xn_3;
    end
end
assign d = d1[27:12];
endmodule
