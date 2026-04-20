package RAM_coverage_pkg;
import RAM_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class RAM_coverage extends uvm_component;
  `uvm_component_utils(RAM_coverage)
  uvm_analysis_export #(RAM_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(RAM_seq_item) cov_fifo;
  RAM_seq_item seq_item_cov;

   covergroup cvr_grp ;
	din_cp : coverpoint seq_item_cov.din[9:8]
    {
    bins write_address = {0};
    bins write_data = {1};
    bins read_address = {2};
    bins read_data = {3};
    }   
    din_transitions_cp : coverpoint seq_item_cov.din[9:8]
    {
    bins w_add_data_trans = (0=>1);
    bins r_add_data_trans = (2=>3);
    //bins w_r_add_data_trans = (0=>1=>2=>3);
    //bins w_r = (1=>2); we can't hit this bin din[9:8] will go from 01 to 11 then 10 before rx_valid asserted
    // 2 bits both bits cannot switch simultaneously. 
    }      
    rx_valid_cp : coverpoint seq_item_cov.rx_valid
    { bins rx0 = {0}; bins rx1 = {1}; }
    tx_valid_cp : coverpoint seq_item_cov.tx_valid
    { bins tx0 = {0}; bins tx1 = {1}; }


    cross_rx: cross din_cp,rx_valid_cp {
      illegal_bins invalid_rx = binsof(din_cp) && binsof(rx_valid_cp.rx0);
    }
    cross_tx: cross din_cp,tx_valid_cp {
      option.cross_auto_bin_max = 0;
      bins tx_cross = binsof(din_cp.read_data) && binsof(tx_valid_cp.tx1);

    }

   endgroup


  function new(string name = "RAM_coverage", uvm_component parent = null);
    super.new(name, parent);
    cvr_grp = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo   = new("cov_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      cov_fifo.get(seq_item_cov);
      cvr_grp.sample();
    end
  endtask

endclass
endpackage