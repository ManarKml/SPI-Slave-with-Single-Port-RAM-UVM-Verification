module RAM_sva(din,clk,rst_n,rx_valid,dout,tx_valid);
input bit clk, rst_n,rx_valid,tx_valid;
input [9:0] din;
input [7:0] dout;


// Reset assertion
 RST_OP : assert property (@(posedge clk) 
 (rst_n==0) |-> ##1 (dout==0 && tx_valid ==0));
 RST_OP_c : cover property (@(posedge clk) 
 (rst_n==0) |-> ##1 (dout==0 && tx_valid ==0));

tx_valid_0 : assert property (@(posedge clk) disable iff (~rst_n)
  ((din[9:8] == 2'b00 || din[9:8] == 2'b01 || din[9:8] == 2'b10) && rx_valid) |-> ##1 (tx_valid==0));
tx_valid_0_c : cover property (@(posedge clk) disable iff (~rst_n)
  ((din[9:8] == 2'b00 || din[9:8] == 2'b01 || din[9:8] == 2'b10) && rx_valid) |-> ##1 (tx_valid==0));

tx_valid_1 : assert property (@(posedge clk) disable iff (~rst_n)
  (din[9:8] == 2'b11 && rx_valid) |=> ($rose(tx_valid)) |=> ($fell(tx_valid))[->1]);
tx_valid_1_c : cover property (@(posedge clk) disable iff (~rst_n)
 (din[9:8] == 2'b11 && rx_valid) |=> ($rose(tx_valid)) |=> ($fell(tx_valid))[->1]);

 w_add_data: assert property (@(posedge clk) disable iff (~rst_n)
 (din[9:8] == 2'b00 && rx_valid) |-> ##1((din[9:8] ==2'b01 )[->1]));
w_add_data_c : cover property (@(posedge clk) disable iff (~rst_n)
 (din[9:8] == 2'b00 && rx_valid) |-> ##1((din[9:8] ==2'b01 )[->1]));

  r_add_data: assert property (@(posedge clk) disable iff (~rst_n)
 (din[9:8] == 2'b10 && rx_valid) |-> ##1((din[9:8] ==2'b11 )[->1]));
 r_add_data_c : cover property (@(posedge clk) disable iff (~rst_n)
 (din[9:8] == 2'b10 && rx_valid) |-> ##1((din[9:8] ==2'b11 )[->1]));

endmodule