package wrapper_write_only_seq_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import wrapper_seq_item_pkg::*;
	//import wrapper_shared_pkg::*;
	
	class wrapper_write_only_seq extends uvm_sequence #(wrapper_seq_item);
		`uvm_object_utils(wrapper_write_only_seq)

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
					// Current operation must be write-related
					MOSI_array[10:8] inside {3'b000, 3'b001};
					
					// If previous was Write Address, can go to Write Address or Write Data
					if (prev_op == 3'b000) {
						MOSI_array[10:8] inside {3'b000, 3'b001};
					}
					// If previous was Write Data, can go to Write Address or Write Data
					else if (prev_op == 3'b001) {
						MOSI_array[10:8] inside {3'b000, 3'b001};
					}
				});
				seq_item.MOSI_array_prev = seq_item.MOSI_array;
				if (seq_item.cycle_count == 0)
					seq_item.prev_op = seq_item.MOSI_array[10:8];
				finish_item(seq_item);
			end
		endtask : body
	endclass : wrapper_write_only_seq
endpackage : wrapper_write_only_seq_pkg