package wrapper_seq_item_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	//import wrapper_shared_pkg::*;
	
	class wrapper_seq_item extends uvm_sequence_item;
		`uvm_object_utils(wrapper_seq_item)

		rand bit MOSI, SS_n, rst_n;
		bit MISO, MISO_ref;

		// Operation tracking
		bit [2:0] prev_op;          // Previous operation (set in driver)


		int cycle_count;

		rand logic [10:0] MOSI_array;
		logic [10:0] MOSI_array_prev;

		function new(string name = "wrapper_seq_item");
			super.new(name);
			prev_op = 3'b000; // Initialize to Write Address
			MOSI_array_prev = 0;
		endfunction : new

		function string convert2string();
			return $sformatf("%s rst_n = %b, MOSI = %b, SS_n = %b, MISO = %d", super.convert2string(), rst_n, MOSI, SS_n, MISO);
		endfunction : convert2string

		function string convert2string_stimulus();
			return $sformatf("rst_n = %b, MOSI = %b, SS_n = %b", rst_n, MOSI, SS_n);
		endfunction : convert2string_stimulus

		constraint rst_n_cons {
			rst_n dist {1:= 98, 0:= 2};
		}
		constraint SS_n_c {
			if (MOSI_array[10:8] == 3'b111) {
				if (cycle_count == 22)
					SS_n == 1;
				else
					SS_n == 0;
			}
			else {
				if (cycle_count == 12)
					SS_n == 1;
				else
					SS_n == 0;
			}
		}
		constraint valid_op_c {
			if (cycle_count == 0 && !SS_n) {
				MOSI_array[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
			}
			else {
				MOSI_array == MOSI_array_prev;
			}
		}
		constraint MOSI_c {
			if (cycle_count < 12 && cycle_count > 0)
				MOSI == MOSI_array[11-cycle_count];
			else
				MOSI == 0;
		}

		function void post_randomize();
			//MOSI_array_prev = MOSI_array;
			if (!SS_n & rst_n) begin
				cycle_count = cycle_count + 1;
			end else 
				cycle_count = 0;
			if ((MOSI_array[10:8] == 3'b111 && cycle_count > 23) ||
				(MOSI_array[10:8] != 3'b111 && cycle_count > 13)) begin
				cycle_count = 0;
			end
			
			
		endfunction : post_randomize

	endclass : wrapper_seq_item
endpackage : wrapper_seq_item_pkg