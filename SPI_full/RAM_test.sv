
package RAM_test_pkg;
import RAM_env_pkg::*;
import RAM_config_pkg::*;
import RAM_reset_seq_pkg::*;
import RAM_writeonly_seq_pkg::*;
import RAM_readonly_seq_pkg::*;
import RAM_write_read_seq_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"


class RAM_test extends uvm_test;
  `uvm_component_utils(RAM_test)

  RAM_env env;
  RAM_config RAM_cfg;
  virtual RAM_if RAM_vif;
  RAM_reset_seq reset_seq;
  RAM_writeonly_seq writeonly_seq;
  RAM_readonly_seq readonly_seq;
  RAM_write_read_seq write_read_seq;
  function new(string name = "RAM_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env        = RAM_env::type_id::create("env", this);
    RAM_cfg = RAM_config::type_id::create("RAM_cfg", this);
    reset_seq  = RAM_reset_seq::type_id::create("reset_seq", this);
    writeonly_seq  = RAM_writeonly_seq::type_id::create("writeonly_seq", this);
    readonly_seq  = RAM_readonly_seq::type_id::create("readonly_seq", this);
    write_read_seq  = RAM_write_read_seq::type_id::create("write_read_seq", this);
    if (!uvm_config_db#(virtual RAM_if)::get(this, "", "RAM_IF", RAM_cfg.RAM_vif)) begin
      `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the RAM from the uvm_config_db");
    end
    RAM_cfg.is_active = UVM_ACTIVE;
    uvm_config_db#(RAM_config)::set(this, "*", "CFG", RAM_cfg);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    // Reset sequence
    `uvm_info("run_phase", "Reset Asserted", UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Reset Deasserted", UVM_LOW)

    // write only sequence
    `uvm_info("run_phase", "Stimulus Generation Started", UVM_LOW)
    writeonly_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Stimulus Generation Ended", UVM_LOW)

    // read only sequence
    `uvm_info("run_phase", "Stimulus Generation Started", UVM_LOW)
    readonly_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Stimulus Generation Ended", UVM_LOW)
    
     // write and read only sequence
    `uvm_info("run_phase", "Stimulus Generation Started", UVM_LOW)
    write_read_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Stimulus Generation Ended", UVM_LOW)

    phase.drop_objection(this);
  endtask
endclass

endpackage