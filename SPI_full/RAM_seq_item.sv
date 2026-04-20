package RAM_seq_item_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  parameter WRITE_ADD  = 2'b00;
  parameter WRITE_DATA = 2'b01;
  parameter READ_ADD   = 2'b10;
  parameter READ_DATA  = 2'b11;

  class RAM_seq_item extends uvm_sequence_item;
    `uvm_object_utils(RAM_seq_item)
    rand bit  rst_n, rx_valid;
    rand logic [9:0]  din;
    logic tx_valid,tx_valid_ref;
    logic [7:0] dout,dout_ref;
    logic [1:0] last_operation;
    // Constraints
    constraint rst_c        { rst_n    dist {0:/2, 1:/98}; } // deasserted most of the time
    constraint rx_valid_c   { rx_valid dist {1:/98, 0:/2}; } // asserted most of the time

    constraint write_only_c { if (last_operation == WRITE_ADD)
                              din[9:8] inside {WRITE_ADD, WRITE_DATA}; }

    constraint read_only_c  { if (last_operation == READ_ADD)
                              din[9:8] == READ_DATA;
                              if (last_operation == READ_DATA)
                              din[9:8] == READ_ADD; }

    constraint write_read_c { if (last_operation == READ_ADD)
                                din[9:8] == READ_DATA;
                              if (last_operation == WRITE_DATA)
                                din[9:8] dist {READ_ADD:/60, WRITE_ADD:/40};
                              if (last_operation == READ_DATA)
                                din[9:8] dist {WRITE_ADD:/60, READ_ADD:/40};
                            }
    function void post_randomize();
      last_operation = din[9:8];
    endfunction

    function new(string name = "RAM_seq_item");
      super.new(name);
      last_operation = WRITE_ADD;
    endfunction

    function string convert2string();
      return $sformatf("%s  rst_n=%0b, rx_valid=%0b, din=%0d, tx_valid=%0b, dout=%0d",
                      super.convert2string(), rst_n, rx_valid, din, tx_valid, dout);
    endfunction

    function string convert2string_stimulus();
      return $sformatf("rst_n=%0b, rx_valid=%0b, din=%0d",
                       rst_n, rx_valid, din);
    endfunction

  endclass
endpackage
