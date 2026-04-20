package SPI_slave_scoreboard_pkg;
	import uvm_pkg::*;
	import SPI_slave_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class SPI_slave_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(SPI_slave_scoreboard)
		uvm_analysis_export #(SPI_slave_sequence_item) sb_export;
		uvm_tlm_analysis_fifo #(SPI_slave_sequence_item) sb_fifo;
		SPI_slave_sequence_item seq_item_sb;

		integer correct_counter=0;
		integer error_counter=0;

		function new(string name = "SPI_slave_scoreboard", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export =new("sb_export",this);
			sb_fifo =new("sb_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_fifo.get(seq_item_sb);
				if ((seq_item_sb.rx_valid_ref!= seq_item_sb.rx_valid)||(seq_item_sb.rx_data_ref!= seq_item_sb.rx_data ||(seq_item_sb.MISO_ref!= seq_item_sb.miso))) begin
					if(seq_item_sb.rx_valid_ref!= seq_item_sb.rx_valid)begin
					`uvm_error("run_phase", $sformatf("There is an error !!, Transacton received by the DUT is: %s whilethe refernce rx_valid output is: 0b%0b , refernce rx_data output is: 0b%0b , refernce miso output is: 0b%0b  ",
					 seq_item_sb.convert2string(), seq_item_sb.rx_valid_ref,seq_item_sb.rx_data_ref,seq_item_sb.MISO_ref));
					error_counter++;
					end
				end else begin
					`uvm_info("run_phase", $sformatf("Correct Transacton received, Output is: %s",
								 seq_item_sb.convert2string()),UVM_HIGH)
					correct_counter++;
				end
			end
		endtask 

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("Total coorect counts is: 0d%0d",correct_counter),UVM_LOW)
			`uvm_info("report_phase", $sformatf("Total error counts is: 0d%0d",error_counter),UVM_LOW)
		endfunction 
	endclass : SPI_slave_scoreboard
endpackage : SPI_slave_scoreboard_pkg