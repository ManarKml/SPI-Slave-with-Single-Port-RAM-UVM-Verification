
interface RAM_if (clk);
  input clk;
  logic rst_n,rx_valid,tx_valid,tx_valid_ref;
  logic [9:0] din;
  logic [7:0] dout,dout_ref;
endinterface