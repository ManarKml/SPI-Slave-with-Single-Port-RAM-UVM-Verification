module SPI_slave_SVA (mosi,miso,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

input clk,mosi, SS_n, rst_n, tx_valid,miso, rx_valid;
input [7:0] tx_data;
input [9:0] rx_data;

property reset_outputs_low;
  @(posedge  clk)
    (~  rst_n) |=> ( ! miso &&  ! rx_valid &&  ( rx_data =='0));
endproperty

assert_reset_outputs_low : assert property (reset_outputs_low);
cover_reset_outputs_low : cover property (reset_outputs_low);

  a_read_data: assert property (@(posedge clk) disable iff(!rst_n) ($fell(SS_n) ##1 mosi [*3]) |=> ##10 (rx_valid && !SS_n)[->1]);
  c_read_data: cover  property (@(posedge clk) disable iff(!rst_n) ($fell(SS_n) ##1 mosi [*3]) |=> ##10 (rx_valid && !SS_n)[->1]);

  a_read_addr: assert property (@(posedge clk) disable iff(!rst_n) ($fell(SS_n) ##1 mosi [*2] ##1 !mosi) |=> ##10 (rx_valid && !SS_n)[->1]);
  c_read_addr: cover  property (@(posedge clk) disable iff(!rst_n) ($fell(SS_n) ##1 mosi [*2] ##1 !mosi) |=> ##10 (rx_valid && !SS_n)[->1]);

  a_write_data: assert property (@(posedge clk) disable iff(!rst_n) ($fell(SS_n) ##1 !mosi [*2] ##1 mosi) |=> ##10 (rx_valid && !SS_n)[->1]);
  c_write_data: cover  property (@(posedge clk) disable iff(!rst_n) ($fell(SS_n) ##1 !mosi [*2] ##1 mosi) |=> ##10 (rx_valid && !SS_n)[->1]);

  a_write_addr: assert property (@(posedge clk) disable iff(!rst_n) ($fell(SS_n) ##1 !mosi [*2] ##1 !mosi) |=> ##10 (rx_valid && !SS_n)[->1]);
  c_write_addr: cover  property (@(posedge clk) disable iff(!rst_n) ($fell(SS_n) ##1 !mosi [*2] ##1 !mosi) |=> ##10 (rx_valid && !SS_n)[->1]);

endmodule : SPI_slave_SVA