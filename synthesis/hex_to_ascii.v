module hex_to_ascii (
    input [3:0] hex,
    output reg [7:0] ascii
);
always @(*) begin
    if (hex < 10)
        ascii = hex + 8'd48;
    else
        ascii = hex + 8'd55;
end
endmodule
