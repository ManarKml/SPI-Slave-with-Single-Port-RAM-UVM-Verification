package wrapper_write_read_seq_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import wrapper_seq_item_pkg::*;
	//import wrapper_shared_pkg::*;
	
	class wrapper_write_read_seq extends uvm_sequence #(wrapper_seq_item);
		`uvm_object_utils(wrapper_write_read_seq)

		wrapper_seq_item seq_item;

		function new(string name = "wrapper_reset_seq");
			super.new(name);
		endfunction : new

		task body();
			seq_item = wrapper_seq_item::type_id::create("seq_item");
			seq_item.prev_op = 0;
			repeat (10000) begin
				start_item(seq_item);
				assert(seq_item.randomize() with {
					if (~seq_item.rst_n) {
						prev_op == 3'b111; //to avoid reading data right after reset we need to read or write address first
					} 
					// After Write Address -> Write Address OR Write Data
					if (prev_op == 3'b000) {
						MOSI_array[10:8] inside {3'b000, 3'b001};
					}
					// After Write Data -> Read Address (60%) OR Write Address (40%)
					else if (prev_op == 3'b001) {
						MOSI_array[10:8] dist {3'b110 := 60, 3'b000 := 40}; // 0=Read Address, 1=Write Address
					}
					// After Read Address -> Read Data
					else if (prev_op == 3'b110) {
						MOSI_array[10:8] == 3'b111;
					}
					// After Read Data -> Write Address (60%) OR Read Address (40%)
					else if (prev_op == 3'b111) {
						MOSI_array[10:8] dist {3'b000 := 60, 3'b110 := 40}; // 0=Write Address, 1=Read Address
					}
				});
				seq_item.MOSI_array_prev = seq_item.MOSI_array;
				if (seq_item.cycle_count == 0 & seq_item.rst_n )
					seq_item.prev_op = seq_item.MOSI_array[10:8];
				finish_item(seq_item);
			end
		endtask : body
	endclass : wrapper_write_read_seq
endpackage : wrapper_write_read_seq_pkg