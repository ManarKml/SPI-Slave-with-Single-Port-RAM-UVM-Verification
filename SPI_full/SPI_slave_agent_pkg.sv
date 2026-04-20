package SPI_slave_agent_pkg;
	import SPI_slave_sequencer_pkg::*;
	import SPI_slave_sequence_item_pkg::*;
	import SPI_slave_config_obj_pkg::*;
	import SPI_slave_monitor_pkg::*;
	import SPI_slave_driver_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class SPI_slave_agent extends uvm_agent;
		`uvm_component_utils(SPI_slave_agent)

		SPI_slave_sequencer sqr;
		SPI_slave_monitor mon;
		SPI_slave_driver drv;
		SPI_slave_config_obj SPI_slave_cfg;
		uvm_analysis_port #(SPI_slave_sequence_item) agt_ap;

		function new(string name = "SPI_slave_agent", uvm_component parent = null);
			super.new(name,parent);
		endfunction
		function void build_phase(uvm_phase phase);
			super.build_phase (phase);

			if (!uvm_config_db #(SPI_slave_config_obj)::get(this,"", "SLAVE_CFG", SPI_slave_cfg)) begin
				`uvm_fatal ("build _phase", "Driver - unable to get configuration object");
			end

			if (SPI_slave_cfg.is_active == UVM_ACTIVE) begin
				drv = SPI_slave_driver:: type_id::create("drv", this);
				sqr = SPI_slave_sequencer:: type_id::create("sqr",this);
			end

			mon = SPI_slave_monitor:: type_id:: create("mon", this);
			agt_ap =new("agt_ap", this);

		endfunction : build_phase
		function void connect_phase(uvm_phase phase);
			super.connect_phase (phase);

			if (SPI_slave_cfg.is_active == UVM_ACTIVE) begin
				drv.SPI_slave_vif=SPI_slave_cfg.SPI_slave_config_vif;
				drv.seq_item_port.connect (sqr.seq_item_export);
			end

			mon.SPI_slave_vif=SPI_slave_cfg.SPI_slave_config_vif;
			mon. mon_ap. connect(agt_ap);
				
		endfunction : connect_phase
	endclass : SPI_slave_agent
endpackage : SPI_slave_agent_pkg