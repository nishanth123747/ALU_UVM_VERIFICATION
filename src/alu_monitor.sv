class alu_monitor extends uvm_monitor;
  virtual alu_if vif;
  uvm_analysis_port #(alu_sequence_item) item_collected_port;
  alu_sequence_item seq_item;

  `uvm_component_utils(alu_monitor)

  function new (string name, uvm_component parent);
    super.new(name, parent);
    seq_item = new();
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    repeat(3)@(posedge vif.MON.CLK);
   forever
     begin
       #0;
//        @(posedge vif.MON.CLK);
      seq_item.RES=vif.mon_cb.RES;
      seq_item.COUT=vif.mon_cb.COUT;
      seq_item.OFLOW=vif.mon_cb.OFLOW;
      seq_item.G=vif.mon_cb.G;
      seq_item.L=vif.mon_cb.L;
      seq_item.E=vif.mon_cb.E;

      seq_item.OPA=vif.mon_cb.OPA;
      seq_item.OPB=vif.mon_cb.OPB;
      seq_item.CIN=vif.mon_cb.CIN;
      seq_item.CMD=vif.mon_cb.CMD;
      seq_item.MODE=vif.mon_cb.MODE;
      seq_item.INP_VALID=vif.mon_cb.INP_VALID;
      seq_item.CE=vif.mon_cb.CE;
       `uvm_info(get_type_name(),$sformatf("OPA=%d OPB=%d CMD=%d INP_VALID=%d MODE=%d RES=%d,OFLOW=%d,COUT=%d,ERR=%d,E=%d,G=%d,L=%d,AT %0t",seq_item.OPA,seq_item.OPB,seq_item.CMD,seq_item.INP_VALID,seq_item.MODE,seq_item.RES,seq_item.OFLOW,seq_item.COUT,seq_item.ERR,seq_item.E,seq_item.G,seq_item.L,$time),UVM_LOW);
      item_collected_port.write(seq_item);
       repeat(4) @(posedge vif.MON.CLK);
    end
  endtask
endclass
