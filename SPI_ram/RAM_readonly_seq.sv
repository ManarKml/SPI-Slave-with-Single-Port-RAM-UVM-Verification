package RAM_readonly_seq_pkg;
import RAM_seq_item_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;


class RAM_readonly_seq extends uvm_sequence #(RAM_seq_item);
`uvm_object_utils(RAM_readonly_seq);
 RAM_seq_item  seq_item_3;
function new(string name = "RAM_readonly_seq");
super.new(name);
endfunction
task body();
seq_item_3 = RAM_seq_item::type_id::create("seq_item_3");
seq_item_3.constraint_mode(0);
seq_item_3.read_only_c.constraint_mode(1);
for (int i=0 ; i<500 ; i++) begin
    start_item(seq_item_3);
    if(i==0)
    assert(seq_item_3.randomize() with {din[9:8] == 2'b10 ;}); //start with read address operation
    else  assert(seq_item_3.randomize() with {din[9:8] inside {2,3};});
    finish_item(seq_item_3);
end
endtask
endclass
endpackage