package wrapper_scoreboard_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import wrapper_seq_item_pkg::*;
  //import wrapper_shared_pkg::*;
  
  class wrapper_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(wrapper_scoreboard)
	
	uvm_analysis_export #(wrapper_seq_item) sb_export;
	uvm_tlm_analysis_fifo #(wrapper_seq_item) sb_fifo;
	wrapper_seq_item seq_item_sb;
	logic signed [5:0] out_ref;
	logic [15:0] leds_ref;

	int error_count = 0;
	int correct_count = 0;

	function new(string name = "wrapper_scoreboard", uvm_component parent = null);
	  super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	  sb_export = new("sb_export", this);
	  sb_fifo = new("sb_fifo", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
	  super.connect_phase(phase);
	  sb_export.connect(sb_fifo.analysis_export);
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  forever begin
		sb_fifo.get(seq_item_sb);
		if(seq_item_sb.MISO != seq_item_sb.MISO_ref) begin
		  `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT: %s While the reference out:%0d", seq_item_sb.convert2string(), seq_item_sb.MISO_ref));
		  error_count++;
		end else begin
		  correct_count++;
		end
		`uvm_info("run_phase", seq_item_sb.convert2string(), UVM_HIGH)
	  end
	endtask

	function void report_phase(uvm_phase phase);
	  super.report_phase(phase);
	  `uvm_info("report_phase", $sformatf("Total successful transactions: %d", correct_count), UVM_MEDIUM)
	  `uvm_info("report_phase", $sformatf("Total failed transactions: %d", error_count), UVM_MEDIUM)
	endfunction : report_phase
  endclass
endpackage : wrapper_scoreboard_pkg
