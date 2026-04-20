import uvm_pkg::*;
`include "uvm_macros.svh"
import wrapper_test_pkg::*;

module SPI_top();
  bit clk;

  initial begin
    forever #1 clk = ~clk;
  end

  wrapper_if wrapperif (clk);

  WRAPPER dut (
    .MOSI(wrapperif.MOSI),
    .MISO(wrapperif.MISO),
    .SS_n(wrapperif.SS_n),
    .clk(wrapperif.clk),
    .rst_n(wrapperif.rst_n)
  );

  wrapper_gm ref_model (
    .MOSI(wrapperif.MOSI),
    .MISO(wrapperif.MISO_ref),
    .SS_n(wrapperif.SS_n),
    .clk(wrapperif.clk),
    .rst_n(wrapperif.rst_n)
  );

  bind WRAPPER wrapper_sva sva_inst (
    .clk(dut.clk),
    .rst_n(dut.rst_n),
    .MOSI(dut.MOSI),
    .MISO(dut.MISO),
    .SS_n(dut.SS_n),
    .rx_valid(dut.rx_valid), // internal signal
    .rx_data(dut.rx_data_din)    // internal signal
  );

  SPI_slave_interface slave_if (clk);
  assign slave_if.SS_n = dut.SS_n;
  assign slave_if.rst_n = dut.rst_n;
  assign slave_if.mosi = dut.MOSI;
  assign slave_if.rx_valid = dut.rx_valid;
  assign slave_if.rx_data = dut.rx_data_din;
  assign slave_if.tx_valid = dut.tx_valid;
  assign slave_if.tx_data = dut.tx_data_dout;
  assign slave_if.miso = dut.MISO;
  assign slave_if.MISO_ref = ref_model.MISO;
  assign slave_if.rx_valid_ref = ref_model.rx_valid;
  assign slave_if.rx_data_ref = ref_model.rx_data;

  bind SLAVE SPI_slave_SVA SVasser (slave_if.mosi,slave_if.miso,slave_if.SS_n,clk,slave_if.rst_n,slave_if.rx_data,slave_if.rx_valid,slave_if.tx_data,slave_if.tx_valid);

  RAM_if ram_if (clk);
  assign ram_if.rst_n = dut.rst_n;
  assign ram_if.din = dut.rx_data_din;
  assign ram_if.rx_valid = dut.rx_valid;
  assign ram_if.tx_valid = dut.tx_valid;
  assign ram_if.dout = dut.tx_data_dout;
  assign ram_if.dout_ref = ref_model.tx_data;
  assign ram_if.tx_valid_ref = ref_model.tx_valid;

  bind RAM RAM_sva RAM_sva_inst (ram_if.din,clk,ram_if.rst_n,ram_if.rx_valid,ram_if.dout,ram_if.tx_valid);
  
  initial begin
    uvm_config_db #(virtual wrapper_if)::set(null, "uvm_test_top", "WRAPPER_IF", wrapperif);
    uvm_config_db #(virtual SPI_slave_interface)::set(null, "uvm_test_top", "SLAVE_IF", slave_if);
    uvm_config_db #(virtual RAM_if)::set(null, "uvm_test_top", "RAM_IF", ram_if);
    run_test("wrapper_test");
  end
  
endmodule