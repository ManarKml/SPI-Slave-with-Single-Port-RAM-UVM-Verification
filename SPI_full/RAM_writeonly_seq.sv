package RAM_writeonly_seq_pkg;
import RAM_seq_item_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;


class RAM_writeonly_seq extends uvm_sequence #(RAM_seq_item);
`uvm_object_utils(RAM_writeonly_seq);
 RAM_seq_item  seq_item_2;
function new(string name = "RAM_writeonly_seq");
super.new(name);
endfunction
task body();
seq_item_2 = RAM_seq_item::type_id::create("seq_item_2");
seq_item_2.constraint_mode(0); //inline constraint is enough here 
for (int i=0 ; i<500 ; i++) begin
  start_item(seq_item_2);
  if(i==0)
  assert(seq_item_2.randomize() with {din[9:8] == 2'b00;}); //start with write address operation
  else assert(seq_item_2.randomize() with {din[9:8] inside {0,1};}); //operation is write address or write data
  finish_item(seq_item_2);
end
endtask
endclass
endpackage
