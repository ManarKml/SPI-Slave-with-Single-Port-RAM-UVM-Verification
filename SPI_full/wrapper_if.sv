interface wrapper_if (clk);
  input clk;
  logic MOSI, SS_n, rst_n;
  logic MISO, MISO_ref;
endinterface : wrapper_if