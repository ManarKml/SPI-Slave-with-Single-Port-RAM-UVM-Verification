package SPI_slave_coverage_pkg;
	import uvm_pkg::*;
	import SPI_slave_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class SPI_slave_coverage extends uvm_component;
		`uvm_component_utils(SPI_slave_coverage)
		uvm_analysis_export #(SPI_slave_sequence_item) cov_export;
		uvm_tlm_analysis_fifo #(SPI_slave_sequence_item) cov_fifo;
		SPI_slave_sequence_item seq_item_cov;
  covergroup cg;

    // 1) Cover rx_data[9:8] values and transitions
    rx_data_cp : coverpoint seq_item_cov.rx_data[9:8] {
      bins value_00 = {2'b00};
      bins value_01 = {2'b01};
      bins value_10 = {2'b10};
      bins value_11 = {2'b11};

      // Transition bins: all possible transitions between 2-bit values
      bins trans_00_01 = (2'b00 => 2'b01);
      bins trans_00_10 = (2'b00 => 2'b10);
      bins trans_01_00 = (2'b01 => 2'b00);
      bins trans_01_11 = (2'b01 => 2'b11);
      bins trans_10_00 = (2'b10 => 2'b00);
      bins trans_10_11 = (2'b10 => 2'b11);
      bins trans_11_00 = (2'b11 => 2'b00);
      bins trans_11_01 = (2'b11 => 2'b01);
      bins trans_11_10 = (2'b11 => 2'b10);
    }

    // 2) SS_n sequence bins for transaction length checking
    ss_n_transition : coverpoint seq_item_cov.SS_n {
      // Normal transaction: 1 → 0[*12] → 1
      bins normal_trans = (1 => 0 [*12] => 1);

      // Extended transaction: 1 → 0[*22] → 1
      bins extended_trans = (1 => 0 [*22] => 1);
    }

     SS_n_fell : coverpoint seq_item_cov.SS_n {
      bins SS_fell = (1 => 0 =>0 =>0 =>0);
    }
    // 3) mosi sequence bins to validate transaction types
    mosi_cp : coverpoint seq_item_cov.mosi {
      bins write_addr = (0 => 0 => 0);
      bins write_data = (0 => 0 => 1);
      bins read_addr  = (1 => 1 => 0);
      bins read_data  = (1 => 1 => 1);
    }
    // 4) Cross coverage between SS_n and mosi
    mosi_correct_transition_cross : cross SS_n_fell, mosi_cp;


  endgroup : cg 

		function new(string name = "SPI_slave_coverage", uvm_component parent = null);
			super.new(name,parent);
			cg=new();
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export =new("cov_export",this);
			cov_fifo =new("cov_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_fifo.get(seq_item_cov);
				cg.sample();
			end
		endtask : run_phase
	endclass : SPI_slave_coverage
endpackage : SPI_slave_coverage_pkg