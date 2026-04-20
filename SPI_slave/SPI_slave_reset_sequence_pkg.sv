package SPI_slave_reset_sequence_pkg;
	import uvm_pkg::*;
	import SPI_slave_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class SPI_slave_reset_sequence extends uvm_sequence #(SPI_slave_sequence_item);
		`uvm_object_utils(SPI_slave_reset_sequence)

		SPI_slave_sequence_item seq_item;

		function new(string name = "SPI_slave_reset_sequence");
			super.new(name);
		endfunction

		task body;
			seq_item=SPI_slave_sequence_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst_n=0;
			seq_item.mosi = 0;
			seq_item.SS_n=1;
			seq_item.tx_valid=0;
			seq_item.tx_data=0;
			finish_item(seq_item);
		endtask : body
	endclass : SPI_slave_reset_sequence
endpackage : SPI_slave_reset_sequence_pkg