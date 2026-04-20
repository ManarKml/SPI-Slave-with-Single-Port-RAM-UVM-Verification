import uvm_pkg::*;
import SPI_slave_test_pkg::*;

`include "uvm_macros.svh"

module SPI_slave_top ();

 bit clk;

 initial begin
 	clk=0;
 	forever 
 		#1 clk=~clk;
 end

SPI_slave_interface SPI_slave_if (clk);

SLAVE DUT (SPI_slave_if.mosi,SPI_slave_if.miso,SPI_slave_if.SS_n,clk,SPI_slave_if.rst_n,SPI_slave_if.rx_data,SPI_slave_if.rx_valid,SPI_slave_if.tx_data,SPI_slave_if.tx_valid);
slave_gm golden (SPI_slave_if.tx_data,SPI_slave_if.tx_valid,SPI_slave_if.SS_n,SPI_slave_if.mosi,SPI_slave_if.MISO_ref,SPI_slave_if.rx_data_ref,SPI_slave_if.rx_valid_ref,clk,SPI_slave_if.rst_n);
bind SLAVE SPI_slave_SVA SVasser (SPI_slave_if.mosi,SPI_slave_if.miso,SPI_slave_if.SS_n,clk,SPI_slave_if.rst_n,SPI_slave_if.rx_data,SPI_slave_if.rx_valid,SPI_slave_if.tx_data,SPI_slave_if.tx_valid);
initial begin
	uvm_config_db#(virtual SPI_slave_interface)::set(null, "uvm_test_top", "SPI_slave_IF", SPI_slave_if);
	run_test("SPI_slave_test");
end
endmodule : SPI_slave_top

