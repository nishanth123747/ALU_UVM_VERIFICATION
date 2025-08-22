`uvm_analysis_imp_decl(_active_mon)
`uvm_analysis_imp_decl(_passive_mon)

class alu_coverage extends uvm_component;
  `uvm_component_utils(alu_coverage)

  uvm_analysis_imp_active_mon #(alu_sequence_item, alu_coverage) aport_active;
  uvm_analysis_imp_passive_mon #(alu_sequence_item, alu_coverage) aport_passive;

  alu_sequence_item txn_mon1, txn_drv1;
  real mon1_cov, drv1_cov;

//driver covergrooup
  covergroup cg_drv;
    MODE_CP: coverpoint txn_drv1.MODE {
      bins mode_0 = {0};
      bins mode_1 = {1};
    }
    CMD_CP: coverpoint txn_drv1.CMD {
      bins cmd_vals[] = {[0:15]};
    }
    INP_VALID_CP: coverpoint txn_drv1.INP_VALID {
      bins invalid = {2'b00};
      bins opa_valid = {2'b01};
      bins opb_valid = {2'b10};
      bins both_valid = {2'b11};
    }
    CE_CP: coverpoint txn_drv1.CE {
      bins clock_enable[] = {[0:1]};
    }
    CIN_CP: coverpoint txn_drv1.CIN {
      bins cin[] = {[0:1]};
    }
    CMO_CP: coverpoint txn_drv1.CMD {
      bins cmd[] = {[0:15]};
    }
    CMD_ARTH_CP: coverpoint txn_drv1.CMD iff(txn_drv1.MODE == 1) {
      bins add        = {4'd0};
      bins sub        = {4'd1};
      bins add_cin    = {4'd2};
      bins sub_cin    = {4'd3};
      bins inc_a      = {4'd4};
      bins dec_a      = {4'd5};
      bins inc_b      = {4'd6};
      bins dec_b      = {4'd7};
      bins cmp_ab     = {4'd8};
      bins mul_inc    = {4'd9};
      bins mul_shift  = {4'd10};
      ignore_bins invalid = {[11:15]};
    }
    CMD_LOGIC_CP: coverpoint txn_drv1.CMD iff (txn_drv1.MODE == 0) {
      bins and_op = {4'd0};
      bins nand_op = {4'd1};
      bins or_op = {4'd2};
      bins nor_op = {4'd3};
      bins xor_op = {4'd4};
      bins xnor_op = {4'd5};
      bins not_a = {4'd6};
      bins not_b = {4'd7};
      bins shr1_a = {4'd8};
      bins shl1_a = {4'd9};
      bins shr1_b = {4'd10};
      bins shl1_b = {4'd11};
      bins rol_a_b = {4'd12};
      bins ror_a_b = {4'd13};
      ignore_bins invalid_cmd = {[14:15]};
    }
    OPA_CP: coverpoint txn_drv1.OPA {
      bins zero = {0};
      bins smaller = {[1 : (2**(`WIDTH/2))-1]};
      bins largeer = {[2**(`WIDTH/2) : (2**`WIDTH)-1]};
    }
    OPB_CP: coverpoint txn_drv1.OPB {
      bins zero = {0};
      bins smaller = {[1 : (2**(`WIDTH/2))-1]};
      bins largeer = {[2**(`WIDTH/2) : (2**`WIDTH)-1]};
    }
    CMD_X_INP_VALID: cross txn_drv1.CMD, txn_drv1.INP_VALID;
    CMD_X_MODE: cross txn_drv1.CMD, txn_drv1.MODE;

  endgroup

  // Monitor Coverage Group
  covergroup cg_mon;
    RESULT_CP: coverpoint txn_mon1.RES {
      bins result[] = {[0 : (2**`WIDTH)-1]};
    }
    COUT_CP: coverpoint txn_mon1.COUT {
      bins cout[] = {0, 1};
    }
    OFLOW_CP: coverpoint txn_mon1.OFLOW {
      bins overflow[] = {0, 1};
    }
    E_CP: coverpoint txn_mon1.E {
      bins equal[] = {0, 1};
    }
    G_CP: coverpoint txn_mon1.G {
      bins greater[] = {0, 1};
    }
    L_CP: coverpoint txn_mon1.L {
      bins less[] = {0, 1};
    }
    ERR_CP: coverpoint txn_mon1.ERR {
      bins error[] = {0, 1};
    }
  endgroup

  function new(string name = "", uvm_component parent);
    super.new(name, parent);
    cg_mon = new();
    cg_drv = new();
    aport_active = new("aport_active", this);
    aport_passive = new("aport_passive", this);
  endfunction

  function void write_active_mon(alu_sequence_item t);
    txn_drv1 = t;
    cg_drv.sample();
//     `uvm_info(get_type_name(), $sformatf("[DRIVER COV] MODE=%0d CMD=%0d OPA=%0d OPB=%0d INP_VALID=%b",
//               txn_drv1.MODE, txn_drv1.CMD, txn_drv1.OPA, txn_drv1.OPB, txn_drv1.INP_VALID), UVM_MEDIUM);
  endfunction

  function void write_passive_mon(alu_sequence_item t);
    txn_mon1 = t;
    cg_mon.sample();
//     `uvm_info(get_type_name(), $sformatf("[MONITOR COV] RES=%0d COUT=%0d OFLOW=%0d E=%0d G=%0d L=%0d ERR=%0d",
//               txn_mon1.RES, txn_mon1.COUT, txn_mon1.OFLOW, txn_mon1.E, txn_mon1.G, txn_mon1.L, txn_mon1.ERR), UVM_MEDIUM);
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    drv1_cov = cg_drv.get_coverage();
    mon1_cov = cg_mon.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("[DRIVER] Coverage -> %0.2f%%", drv1_cov), UVM_LOW);
    `uvm_info(get_type_name(), $sformatf("[MONITOR] Coverage -> %0.2f%%", mon1_cov), UVM_LOW);

    `uvm_info(get_type_name(), "=== COVERAGE DETAILS ===", UVM_LOW);
    `uvm_info(get_type_name(), $sformatf("Driver Coverage: %0.2f%% (%0d hits)",
              drv1_cov, cg_drv.get_inst_coverage()), UVM_LOW);
    `uvm_info(get_type_name(), $sformatf("Monitor Coverage: %0.2f%% (%0d hits)",
              mon1_cov, cg_mon.get_inst_coverage()), UVM_LOW);
  endfunction

endclass

