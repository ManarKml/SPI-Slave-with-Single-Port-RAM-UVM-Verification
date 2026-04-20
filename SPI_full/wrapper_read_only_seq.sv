package wrapper_read_only_seq_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import wrapper_seq_item_pkg::*;
	//import wrapper_shared_pkg::*;
	
	class wrapper_read_only_seq extends uvm_sequence #(wrapper_seq_item);
		`uvm_object_utils(wrapper_read_only_seq)

		wrapper_seq_item seq_item;

		function new(string name = "wrapper_reset_seq");
			super.new(name);
		endfunction : new

		task body();
			seq_item = wrapper_seq_item::type_id::create("seq_item");
			seq_item.prev_op = 3'b111; // Initialized to read data
			repeat (520) begin
				start_item(seq_item);
				assert(seq_item.randomize() with {
				    if (~seq_item.rst_n) {
					prev_op == 3'b111; } // to go read address first
				    // If previous was Read Address go to Read Data
				    if (prev_op == 3'b110) {
						MOSI_array[10:8] == 3'b111;
					}
					// If previous was Read Data go to Read Address
					else if (prev_op == 3'b111) {
						MOSI_array[10:8] == 3'b110;
					}
				});
				seq_item.MOSI_array_prev = seq_item.MOSI_array;
				if (seq_item.cycle_count == 0 & seq_item.rst_n)
					seq_item.prev_op = seq_item.MOSI_array[10:8];
				finish_item(seq_item);
			end
		endtask : body
	endclass : wrapper_read_only_seq
endpackage : wrapper_read_only_seq_pkg