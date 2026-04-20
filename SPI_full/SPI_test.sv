////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package wrapper_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import wrapper_config_pkg::*;
import wrapper_reset_seq_pkg::*;
import wrapper_write_only_seq_pkg::*;
import wrapper_read_only_seq_pkg::*;
import wrapper_write_read_seq_pkg::*;
import wrapper_env_pkg::*;
import SPI_slave_env_pkg::*;
import SPI_slave_config_obj_pkg::*;
import RAM_env_pkg::*;
import RAM_config_pkg::*;

class wrapper_test extends uvm_test;
	`uvm_component_utils(wrapper_test)

	wrapper_env env;
	SPI_slave_env slave_env;
	RAM_env ram_env;

	wrapper_config wrapper_cfg;
	SPI_slave_config_obj slave_cfg;
	RAM_config ram_cfg;

	wrapper_write_only_seq write_seq;
	wrapper_read_only_seq read_seq;
	wrapper_write_read_seq write_read_seq;
	wrapper_reset_seq reset_seq;

	function new(string name = "wrapper_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = wrapper_env::type_id::create("env", this);
		slave_env = SPI_slave_env::type_id::create("slave_env", this);
		ram_env = RAM_env::type_id::create("ram_env", this);

		wrapper_cfg = wrapper_config::type_id::create("wrapper_cfg");
		slave_cfg = SPI_slave_config_obj::type_id::create("slave_cfg");
		ram_cfg = RAM_config::type_id::create("ram_cfg");

		write_seq = wrapper_write_only_seq::type_id::create("write_seq");
		read_seq = wrapper_read_only_seq::type_id::create("read_seq");
		write_read_seq = wrapper_write_read_seq::type_id::create("write_read_seq");
		reset_seq = wrapper_reset_seq::type_id::create("reset_seq");

		if(!uvm_config_db #(virtual wrapper_if)::get(this, "", "WRAPPER_IF", wrapper_cfg.wrapper_vif))
			`uvm_fatal("build_phase", "Test - Unable to get the wrapper virtual interface")

		if(!uvm_config_db #(virtual SPI_slave_interface)::get(this, "", "SLAVE_IF", slave_cfg.SPI_slave_config_vif))
			`uvm_fatal("build_phase", "Test - Unable to get the slave virtual interface")

		if(!uvm_config_db #(virtual RAM_if)::get(this, "", "RAM_IF", ram_cfg.RAM_vif))
			`uvm_fatal("build_phase", "Test - Unable to get the RAM virtual interface")

		wrapper_cfg.is_active = UVM_ACTIVE;
		slave_cfg.is_active = UVM_PASSIVE;
		ram_cfg.is_active = UVM_PASSIVE;

		uvm_config_db #(wrapper_config)::set(this, "env.*", "WRAPPER_CFG", wrapper_cfg);
		uvm_config_db #(SPI_slave_config_obj)::set(this, "slave_env.*", "SLAVE_CFG", slave_cfg);
		uvm_config_db #(RAM_config)::set(this, "ram_env.*", "RAM_CFG", ram_cfg);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		`uvm_info("run_phase", "Reset asserted", UVM_MEDIUM)
		reset_seq.start(env.agt.sqr);
		`uvm_info("run_phase", "Reset deasserted", UVM_MEDIUM)

		`uvm_info("run_phase", "Write only stimulus generation started", UVM_MEDIUM)
		write_seq.start(env.agt.sqr);
		`uvm_info("run_phase", "Write only Stimulus generation ended", UVM_MEDIUM)
        `uvm_info("run_phase", "Reset asserted", UVM_MEDIUM)
		reset_seq.start(env.agt.sqr);
		`uvm_info("run_phase", "Reset deasserted", UVM_MEDIUM)
		`uvm_info("run_phase", "Read only stimulus generation started", UVM_MEDIUM)
		read_seq.start(env.agt.sqr);
		`uvm_info("run_phase", "Read only Stimulus generation ended", UVM_MEDIUM)
        `uvm_info("run_phase", "Reset asserted", UVM_MEDIUM)
		reset_seq.start(env.agt.sqr);
		`uvm_info("run_phase", "Reset deasserted", UVM_MEDIUM)
		`uvm_info("run_phase", "Write-read stimulus generation started", UVM_MEDIUM)
		write_read_seq.start(env.agt.sqr);
		`uvm_info("run_phase", "Write-read Stimulus generation ended", UVM_MEDIUM)
		phase.drop_objection(this);
	endtask : run_phase
endclass: wrapper_test
endpackage