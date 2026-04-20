package SPI_slave_sequencer_pkg;

import SPI_slave_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_sequencer extends uvm_sequencer #(SPI_slave_sequence_item);
	`uvm_component_utils(SPI_slave_sequencer)

	function new(string name = "SPI_slave_sequencer", uvm_component parent = null);
		super.new(name,parent);
	endfunction

endclass : SPI_slave_sequencer

endpackage : SPI_slave_sequencer_pkg