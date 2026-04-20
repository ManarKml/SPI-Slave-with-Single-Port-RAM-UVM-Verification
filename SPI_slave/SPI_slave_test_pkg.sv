package SPI_slave_test_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import  SPI_slave_env_pkg::*;	
	import SPI_slave_config_obj_pkg::*;
	import SPI_slave_agent_pkg::*;
	import SPI_slave_main_sequence_pkg::*;
	import SPI_slave_reset_sequence_pkg::*;

	class SPI_slave_test extends uvm_test ;
		`uvm_component_utils(SPI_slave_test)

		SPI_slave_config_obj SPI_slave_config_obj_test;
		SPI_slave_env env;
		virtual SPI_slave_interface SPI_slave_test_vif;
		SPI_slave_reset_sequence reset_seq;
		SPI_slave_main_sequence main_seq;


		function new(string name ="SPI_slave_test", uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env = SPI_slave_env::type_id::create("env",this);
			SPI_slave_config_obj_test = SPI_slave_config_obj::type_id::create("SPI_slave_config_obj_test");
			reset_seq = SPI_slave_reset_sequence::type_id::create("reset_seq");
			main_seq = SPI_slave_main_sequence::type_id::create("main_seq");

			if (!uvm_config_db#(virtual SPI_slave_interface)::get(this, "", "SPI_slave_IF", SPI_slave_config_obj_test.SPI_slave_config_vif)) begin
			 	`uvm_fatal("build_phase","Test - unable to get the virtual interface");
			 end 

			uvm_config_db#(SPI_slave_config_obj)::set(this, "*", "CFG", SPI_slave_config_obj_test);	

		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);

			`uvm_info("run_phase","Reset asserted", UVM_LOW)
			reset_seq.start(env.agt.sqr);
			
			`uvm_info("run_phase","Stimulus generation started", UVM_LOW)
			main_seq.start(env.agt.sqr);

			phase.drop_objection(this);
		endtask 

	endclass : SPI_slave_test
endpackage : SPI_slave_test_pkg
