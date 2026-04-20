import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_test_pkg::*;

module top();
  // Clock generation
   bit clk;
    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end
  // Instantiate the interface and DUT
  RAM_if RAMif (clk);
  RAM dut(RAMif.din,clk,RAMif.rst_n,RAMif.rx_valid,RAMif.dout,RAMif.tx_valid);
  RAM_GM dut_ref(RAMif.din,clk,RAMif.rst_n,RAMif.rx_valid,RAMif.dout_ref,RAMif.tx_valid_ref);
   bind RAM RAM_sva RAM_sva_inst (RAMif.din,clk,RAMif.rst_n,RAMif.rx_valid,RAMif.dout,RAMif.tx_valid);
  // run test using run_test task
initial begin 
  uvm_config_db #(virtual RAM_if ) :: set(null , "uvm_test_top", "RAM_IF", RAMif);
  run_test ("RAM_test");
end
endmodule