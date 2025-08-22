      class alu_test extends uvm_test;
  alu_environment env;
  `uvm_component_utils(alu_test)

  function new(string name = "alu_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.passive_agnt", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.active_agnt", "is_active", UVM_ACTIVE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_sequence seq;
    phase.raise_objection(this, "Objection Raised");
    seq = alu_sequence::type_id::create("seq");
      seq.start(env.active_agnt.seqr);
    phase.drop_objection(this, "Objection Dropped");
  endtask

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    print();
  endfunction
endclass

class alu_test1 extends uvm_test;
  alu_environment env;
  `uvm_component_utils(alu_test1)

  function new(string name = "alu_test1", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.passive_agnt", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.active_agnt", "is_active", UVM_ACTIVE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_sequence1 seq;
    phase.raise_objection(this, "Running alu_test1");
    seq = alu_sequence1::type_id::create("seq");
    seq.start(env.active_agnt.seqr);
    phase.drop_objection(this, "Completed alu_test1");
  endtask
endclass

class alu_test2 extends uvm_test;
  alu_environment env;
  `uvm_component_utils(alu_test2)

  function new(string name = "alu_test2", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.passive_agnt", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.active_agnt", "is_active", UVM_ACTIVE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_sequence2 seq;
    phase.raise_objection(this, "Running alu_test2");
    seq = alu_sequence2::type_id::create("seq");
    seq.start(env.active_agnt.seqr);
    phase.drop_objection(this, "Completed alu_test2");
  endtask
endclass

class alu_test3 extends uvm_test;
  alu_environment env;
  `uvm_component_utils(alu_test3)

  function new(string name = "alu_test3", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.passive_agnt", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.active_agnt", "is_active", UVM_ACTIVE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_sequence3 seq;
    phase.raise_objection(this, "Running alu_test3");
    seq = alu_sequence3::type_id::create("seq");
    seq.start(env.active_agnt.seqr);
    phase.drop_objection(this, "Completed alu_test3");
  endtask
endclass

class alu_test4 extends uvm_test;
  alu_environment env;
  `uvm_component_utils(alu_test4)

  function new(string name = "alu_test4", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.passive_agnt", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.active_agnt", "is_active", UVM_ACTIVE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_sequence4 seq;
    phase.raise_objection(this, "Running alu_test4");
    seq = alu_sequence4::type_id::create("seq");
    seq.start(env.active_agnt.seqr);
    phase.drop_objection(this, "Completed alu_test4");
  endtask
endclass

class alu_test5 extends uvm_test;
  alu_environment env;
  `uvm_component_utils(alu_test5)

  function new(string name = "alu_test5", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.passive_agnt", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.active_agnt", "is_active", UVM_ACTIVE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_sequence5 seq;
    phase.raise_objection(this, "Running alu_test5");
    seq = alu_sequence5::type_id::create("seq");
    seq.start(env.active_agnt.seqr);
    phase.drop_objection(this, "Completed alu_test5");
  endtask
endclass


class alu_test6 extends uvm_test;
  alu_environment env;
  `uvm_component_utils(alu_test6)

  function new(string name = "alu_test6", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.passive_agnt", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.active_agnt", "is_active", UVM_ACTIVE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_sequence6 seq;
    phase.raise_objection(this, "Running alu_test6");
    seq = alu_sequence6::type_id::create("seq");
    seq.start(env.active_agnt.seqr);
    phase.drop_objection(this, "Completed alu_test6");
  endtask
endclass

class alu_test7 extends uvm_test;
  alu_environment env;
  `uvm_component_utils(alu_test7)

  function new(string name = "alu_test7", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.passive_agnt", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.active_agnt", "is_active", UVM_ACTIVE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_sequence7 seq;
    phase.raise_objection(this, "Running alu_test7");
    seq = alu_sequence7::type_id::create("seq");
    seq.start(env.active_agnt.seqr);
    phase.drop_objection(this, "Completed alu_test7");
  endtask
endclass



class alu_regression_test extends uvm_test;
  alu_environment env;
  `uvm_component_utils(alu_regression_test)

  function new(string name = "alu_regression_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.passive_agnt", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.active_agnt", "is_active", UVM_ACTIVE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_regression seq;
    phase.raise_objection(this, "Running regression test8");
    seq = alu_regression::type_id::create("seq");
    seq.start(env.active_agnt.seqr);
    phase.drop_objection(this, "Completed regression test8");
  endtask
endclass
