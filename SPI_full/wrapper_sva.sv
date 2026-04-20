module wrapper_sva (
	input clk,   
	input rst_n, 
	input MOSI, 
	input MISO,
	input SS_n,
	input rx_valid,
	input [9:0] rx_data
);

assert property (@(posedge clk) (!rst_n) |=> (MISO == 0 && rx_valid == 0 && rx_data == 0));
cover  property (@(posedge clk) (!rst_n) |=> (MISO == 0 && rx_valid == 0 && rx_data == 0));

assert property (@(posedge clk) disable iff(!rst_n) ($fell(SS_n) ##1 MOSI [*3]) |=> $stable(MISO) throughout (!SS_n)[->1]);
cover  property (@(posedge clk) disable iff(!rst_n) ($fell(SS_n) ##1 MOSI [*3]) |=> $stable(MISO) throughout (!SS_n)[->1]);

endmodule : wrapper_sva