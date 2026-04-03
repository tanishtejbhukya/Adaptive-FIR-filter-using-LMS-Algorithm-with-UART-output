module LMS_tb;
  reg Clk, Rst;
  reg signed [15:0] x_in;
  wire signed [15:0] y_out;
  wire signed [15:0] d, err, w0, w1, w2, w3;
  reg [15:0] input_data [0:99];
  integer i;
  localparam real SF = 2.0**-12.0;
  LMS dut (
    .Clk(Clk),
    .Rst(Rst),
    .x_in(x_in),
    .w0(w0),
    .w1(w1),
    .w2(w2),
    .w3(w3),
    .y_out(y_out),
    .err(err)
  );
  FIR_Filter F1 (
    .Clk(Clk),
    .Rst(Rst),
    .x(x_in),
    .d(d)
  );
  always begin
    #5 Clk = ~Clk;
  end
  initial begin
    drive_reset();
    $readmemb("D:/Vivado_Projects/LMS_project/LMS_inputs.txt",input_data);
    $display("First sample = %b",input_data[0]);
    $display("Second sample = %b",input_data[1]);
    for (i = 0; i < 100; i = i + 1) begin
      drive_input(input_data[i]);
      @(posedge Clk);
      check_output();
    end
    repeat (10) @(posedge Clk);
    $finish;
  end
  task drive_reset;
    begin
      $display("Driving reset");
      Clk = 1'b0;
      Rst = 1'b1;
      x_in = 16'sd0;
      @(posedge Clk);
      @(posedge Clk);
      Rst = 1'b0;
    end
  endtask
  task drive_input(input [15:0] sample_in);
    begin
      @(negedge Clk);
      x_in = sample_in;
      $display("Input = %f", $itor($signed(x_in)) * SF);
    end
  endtask
  task check_output;
    begin
      $display("Time=%0t Iter=%0d Input=%f Output=%f Error=%f w0=%f w1=%f w2=%f w3=%f",
               $time, i,
               $itor($signed(x_in)) * SF,
               $itor($signed(y_out)) * SF,
               $itor($signed(err)) * SF,
               $itor($signed(w0)) * SF,
               $itor($signed(w1)) * SF,
               $itor($signed(w2)) * SF,
               $itor($signed(w3)) * SF);
    end
  endtask
endmodule
