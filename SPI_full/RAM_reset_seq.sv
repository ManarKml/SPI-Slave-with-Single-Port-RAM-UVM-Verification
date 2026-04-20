package RAM_reset_seq_pkg;
import RAM_seq_item_pkg::*;
import uvm_pkg::*;

`include "uvm_macros.svh"


class RAM_reset_seq extends uvm_sequence #(RAM_seq_item);
`uvm_object_utils(RAM_reset_seq);
 RAM_seq_item  seq_item_1;
function new(string name = "RAM_reset_seq");
super.new(name);
endfunction
task body();
seq_item_1 = RAM_seq_item :: type_id :: create("seq_item_1");
start_item(seq_item_1);
seq_item_1.rst_n=0;
seq_item_1.rx_valid=0;
seq_item_1.din=0;
finish_item(seq_item_1);
endtask
endclass
endpackage