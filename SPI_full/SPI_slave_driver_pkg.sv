package SPI_slave_driver_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import SPI_slave_sequence_item_pkg::*;
	import SPI_slave_main_sequence_pkg::*;
	import SPI_slave_reset_sequence_pkg::*;
	
	class SPI_slave_driver extends uvm_driver #(SPI_slave_sequence_item);
		`uvm_component_utils(SPI_slave_driver)

		virtual SPI_slave_interface SPI_slave_vif;
		SPI_slave_sequence_item stim_seq_item;

		function new(string name ="SPI_slave_driver", uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				stim_seq_item=SPI_slave_sequence_item::type_id::create("stim_seq_item");
				seq_item_port.get_next_item(stim_seq_item);
				SPI_slave_vif.mosi=stim_seq_item.mosi;
				SPI_slave_vif.SS_n=stim_seq_item.SS_n;
				SPI_slave_vif.rst_n=stim_seq_item.rst_n;
				SPI_slave_vif.tx_valid=stim_seq_item.tx_valid;
				SPI_slave_vif.tx_data=stim_seq_item.tx_data;
				@(negedge SPI_slave_vif.clk);
				seq_item_port.item_done();
				`uvm_info("run_phase",stim_seq_item.convert2string_stimulus(), UVM_HIGH)
			end
		endtask : run_phase

	endclass : SPI_slave_driver
endpackage : SPI_slave_driver_pkg