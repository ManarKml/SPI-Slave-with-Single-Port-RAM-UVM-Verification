package RAM_write_read_seq_pkg;
import RAM_seq_item_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;


class RAM_write_read_seq extends uvm_sequence #(RAM_seq_item);
`uvm_object_utils(RAM_write_read_seq);
 RAM_seq_item  seq_item_4;
function new(string name = "RAM_write_read_seq");
super.new(name);
endfunction
task body();
seq_item_4 = RAM_seq_item::type_id::create("seq_item_4");
seq_item_4.constraint_mode(1);
seq_item_4.read_only_c.constraint_mode(0);
for (int i=0 ; i<500 ; i++) begin
    start_item(seq_item_4);
    if(i==0)
    assert(seq_item_4.randomize() with {din[9:8] == 2'b00;}); //start with write address operation
    else assert(seq_item_4.randomize());
    finish_item(seq_item_4);
  end
endtask
endclass
endpackage
