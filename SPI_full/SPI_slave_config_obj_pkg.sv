package SPI_slave_config_obj_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	class SPI_slave_config_obj extends uvm_object;
		`uvm_object_utils(SPI_slave_config_obj)

		virtual SPI_slave_interface SPI_slave_config_vif;
		uvm_active_passive_enum is_active;
		
		function new(string name ="SPI_slave_config_obj");
			super.new(name);
		endfunction : new

	endclass : SPI_slave_config_obj
endpackage : SPI_slave_config_obj_pkg