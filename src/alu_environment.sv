class alu_environment extends uvm_env;
    alu_agent active_agnt;
    alu_agent passive_agnt;
    alu_scoreboard scb;
    alu_coverage cov;


    `uvm_component_utils(alu_environment)

    function new(string name = "alu_environment", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        active_agnt = alu_agent::type_id::create("active_agnt", this);
        passive_agnt = alu_agent::type_id::create("passive_agnt", this);
        scb = alu_scoreboard::type_id::create("scb", this);
        cov = alu_coverage::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
      // monitors to scoreboard
      active_agnt.mon.item_collected_port.connect(scb.item_collected_export_active);
      passive_agnt.mon.item_collected_port.connect(scb.item_collected_export_passive);

      // monitors to coverage
      active_agnt.mon.item_collected_port.connect(cov.aport_active);
      passive_agnt.mon.item_collected_port.connect(cov.aport_passive);
    endfunction
endclass
