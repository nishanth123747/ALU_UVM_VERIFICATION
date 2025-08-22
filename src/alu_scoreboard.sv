`include "defines.sv"
`uvm_analysis_imp_decl(_act_mon)
`uvm_analysis_imp_decl(_pass_mon)

class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)
  uvm_analysis_imp_act_mon #(alu_sequence_item, alu_scoreboard) item_collected_export_active;
  uvm_analysis_imp_pass_mon #(alu_sequence_item, alu_scoreboard) item_collected_export_passive;

  int match = 0, mismatch = 0;
  alu_sequence_item active_monitor_queue[$];
  alu_sequence_item passive_monitor_queue[$];

  function new (string name = "alu_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export_active = new("item_collected_export_active", this);
    item_collected_export_passive = new("item_collected_export_passive", this);
  endfunction

  virtual function void write_act_mon(alu_sequence_item pack);
    alu_sequence_item act_mon_item;
    $display("Scoreboard received packet from active monitor");
    act_mon_item = alu_sequence_item::type_id::create("act_mon_item");
    act_mon_item.copy(pack);
    active_monitor_queue.push_back(act_mon_item);
    `uvm_info(get_type_name(),
              $sformatf("Scoreboard received from active monitor: OPA=%0d OPB=%0d CMD=%0d INP_VALID=%0d,CE=%d,MODE=%d, RES=%0d,OFLOW=%d,COUT=%d,E=%d,G=%d,L=%d,ERR=%d, at %t",
                        pack.OPA, pack.OPB, pack.CMD, pack.INP_VALID,pack.CE,pack.MODE, pack.RES,pack.OFLOW,pack.COUT,pack.E,pack.G,pack.L,pack.ERR,$time),
              UVM_LOW)
  endfunction

  virtual function void write_pass_mon(alu_sequence_item pack);
    alu_sequence_item pass_mon_item;
    $display("Scoreboard received packet from passive monitor");
    pass_mon_item = alu_sequence_item::type_id::create("pass_mon_item");
    pass_mon_item.copy(pack);
    passive_monitor_queue.push_back(pass_mon_item);
    `uvm_info(get_type_name(),
              $sformatf("Scoreboard received from passive monitor: OPA=%0d OPB=%0d CMD=%0d INP_VALID=%0d,CE=%d,MODE=%d, RES=%0d,OFLOW=%d,COUT=%d,E=%d,G=%d,L=%d,ERR=%d, at %t",
                        pack.OPA, pack.OPB, pack.CMD, pack.INP_VALID,pack.CE,pack.MODE, pack.RES,pack.OFLOW,pack.COUT,pack.E,pack.G,pack.L,pack.ERR,$time),
              UVM_LOW)
  endfunction

  function bit both_op(alu_sequence_item sb_trans);
    if (sb_trans.MODE == 1'b1) begin
      if (sb_trans.CMD inside {`ADD, `SUB, `ADD_IN, `SUB_IN, `CMP, `MUL_IN, `MUL_S})
        return 1;
      else
        return 0;
    end
    else begin
      if (sb_trans.CMD inside {`AND, `NAND, `OR, `NOR, `XOR, `XNOR, `ROL, `ROR})
        return 1;
      else
        return 0;
    end
  endfunction

  function alu_sequence_item alu_ref_model(alu_sequence_item ref_trans);
    logic [`WIDTH:0] mul_res;
    bit [$clog2(`WIDTH)-1:0] rot_val;

    // reset outputs
    ref_trans.RES    = {(`WIDTH+1){1'bz}};
    ref_trans.ERR    = 1'bz;
    ref_trans.G      = 1'bz;
    ref_trans.E      = 1'bz;
    ref_trans.L      = 1'bz;
    ref_trans.OFLOW  = 1'bz;
    ref_trans.COUT   = 1'bz;

    if (ref_trans.MODE) begin
      if (ref_trans.INP_VALID == 2'b00) begin
        ref_trans.ERR = 1;
      end
      else if (ref_trans.INP_VALID == 2'b01) begin
        case (ref_trans.CMD)
          `INC_A: begin
            ref_trans.RES  = ref_trans.OPA + 1;
            ref_trans.COUT = ref_trans.RES[`WIDTH];
          end
          `DEC_A: begin
            ref_trans.RES   = ref_trans.OPA - 1;
            ref_trans.OFLOW = ref_trans.RES[`WIDTH];
          end
          default: ref_trans.ERR = 1;
        endcase
      end
      else if (ref_trans.INP_VALID == 2'b10) begin
        case (ref_trans.CMD)
          `INC_B: begin
            ref_trans.RES  = ref_trans.OPB + 1;
            ref_trans.COUT = ref_trans.RES[`WIDTH];
          end
          `DEC_B: begin
            ref_trans.RES   = ref_trans.OPB - 1;
            ref_trans.OFLOW = ref_trans.RES[`WIDTH];
          end
          default: ref_trans.ERR = 1;
        endcase
      end
      else if (ref_trans.INP_VALID == 2'b11) begin
        case (ref_trans.CMD)
          `ADD: begin
            ref_trans.RES  = ref_trans.OPA + ref_trans.OPB;
            ref_trans.COUT = ref_trans.RES[`WIDTH];
          end
          `SUB: begin
            ref_trans.RES   = ref_trans.OPA - ref_trans.OPB;
            ref_trans.OFLOW = (ref_trans.OPA < ref_trans.OPB);
          end
          `ADD_IN: begin
            ref_trans.RES  = ref_trans.OPA + ref_trans.OPB + ref_trans.CIN;
            ref_trans.COUT = ref_trans.RES[`WIDTH];
          end
          `SUB_IN: begin
            ref_trans.RES   = ref_trans.OPA - ref_trans.OPB - ref_trans.CIN;
            ref_trans.OFLOW = (ref_trans.OPA < ref_trans.OPB);
          end
          `INC_A: begin
            ref_trans.RES  = ref_trans.OPA + 1;
            ref_trans.COUT = ref_trans.RES[`WIDTH];
          end
          `DEC_A: begin
            ref_trans.RES   = ref_trans.OPA - 1;
            ref_trans.OFLOW = ref_trans.RES[`WIDTH];
          end
          `INC_B: begin
            ref_trans.RES  = ref_trans.OPB + 1;
            ref_trans.COUT = ref_trans.RES[`WIDTH];
          end
          `DEC_B: begin
            ref_trans.RES   = ref_trans.OPB - 1;
            ref_trans.OFLOW = ref_trans.RES[`WIDTH];
          end
          `CMP: begin
            ref_trans.L = (ref_trans.OPA <  ref_trans.OPB);
            ref_trans.E = (ref_trans.OPA == ref_trans.OPB);
            ref_trans.G = (ref_trans.OPA >  ref_trans.OPB);
          end
          `MUL_IN: begin
            mul_res         = (ref_trans.OPA + 1) * (ref_trans.OPB + 1);
            ref_trans.RES   = mul_res;
          end
          `MUL_S: begin
            mul_res         = (ref_trans.OPA << 1) * ref_trans.OPB;
            ref_trans.RES   = mul_res;
          end
          default: ref_trans.ERR = 1;
        endcase
      end
    end
    else begin
      if (ref_trans.INP_VALID == 2'b00) begin
        ref_trans.ERR = 1;
      end
      else if (ref_trans.INP_VALID == 2'b01) begin
        case (ref_trans.CMD)
          `NOT_A:   ref_trans.RES = {1'b0, ~ref_trans.OPA};
          `SHR1_A:  ref_trans.RES = {1'b0,  ref_trans.OPA >> 1};
          `SHL1_A:  begin
            ref_trans.RES  = {ref_trans.OPA, 1'b0};
            ref_trans.COUT = ref_trans.RES[`WIDTH];
          end
          default: ref_trans.ERR = 1;
        endcase
      end
      else if (ref_trans.INP_VALID == 2'b10) begin
        case (ref_trans.CMD)
          `NOT_B:   ref_trans.RES = {1'b0, ~ref_trans.OPB};
          `SHR1_B:  ref_trans.RES = {1'b0,  ref_trans.OPB >> 1}; // was OPA
          `SHL1_B:  begin
            ref_trans.RES  = {ref_trans.OPB, 1'b0};             // was OPA
            ref_trans.COUT = ref_trans.RES[`WIDTH];
          end
          default: ref_trans.ERR = 1;
        endcase
      end
      else if (ref_trans.INP_VALID == 2'b11) begin
        case (ref_trans.CMD)
          `AND:   ref_trans.RES = {1'b0, (ref_trans.OPA &  ref_trans.OPB)};
          `NAND:  ref_trans.RES = {1'b0, ~(ref_trans.OPA &  ref_trans.OPB)};
          `OR:    ref_trans.RES = {1'b0, (ref_trans.OPA |  ref_trans.OPB)};
          `NOR:   ref_trans.RES = {1'b0, ~(ref_trans.OPA |  ref_trans.OPB)};
          `XOR:   ref_trans.RES = {1'b0, (ref_trans.OPA ^  ref_trans.OPB)};
          `XNOR:  ref_trans.RES = {1'b0, ~(ref_trans.OPA ^  ref_trans.OPB)};
          `NOT_A: ref_trans.RES = {1'b0, ~ref_trans.OPA};
          `NOT_B: ref_trans.RES = {1'b0, ~ref_trans.OPB};
          `SHR1_A: ref_trans.RES = {1'b0, ref_trans.OPA >> 1};
          `SHL1_A: ref_trans.RES = {1'b0, ref_trans.OPA << 1};
          `SHR1_B: ref_trans.RES = {1'b0, ref_trans.OPB >> 1}; // was OPA
          `SHL1_B: ref_trans.RES = {1'b0, ref_trans.OPB << 1}; // was OPA
          `ROL: begin
            rot_val         = ref_trans.OPB[$clog2(`WIDTH)-1:0];
            ref_trans.RES   = {1'b0, (ref_trans.OPA << rot_val) |
                                      (ref_trans.OPA >> (`WIDTH - rot_val))};
            ref_trans.ERR   = (ref_trans.OPB >= `WIDTH);
          end
          `ROR: begin
            rot_val         = ref_trans.OPB[$clog2(`WIDTH)-1:0];
            ref_trans.RES   = {1'b0, (ref_trans.OPA >> rot_val) |
                                      (ref_trans.OPA << (`WIDTH - rot_val))};
            ref_trans.ERR   = (ref_trans.OPB >= `WIDTH);
          end
          default: ref_trans.ERR = 1;
        endcase
      end
    end
    return ref_trans;
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_sequence_item actual_result;
    alu_sequence_item expected_result;
    alu_sequence_item latch_res;
    alu_sequence_item input_stimulus;
    int count = 0;

    latch_res = alu_sequence_item::type_id::create("latch_res");

    forever begin
      wait (active_monitor_queue.size() > 0 && passive_monitor_queue.size() > 0);

      //`uvm_info(get_type_name(), $sformatf("-------------------------------"), UVM_LOW)

      expected_result = alu_sequence_item::type_id::create("expected_result");
      actual_result   = passive_monitor_queue.pop_front();
      input_stimulus  = active_monitor_queue.pop_front();

      if (input_stimulus.CE) begin
        if (count != 0 && count <= 16) begin
          if (input_stimulus.INP_VALID == 3) begin
            count = 0;
            $display("inside 16 loop but inp_valid 3 occurred");
            expected_result = alu_ref_model(input_stimulus);
          end
          else if (input_stimulus.INP_VALID != 3 && count == 16) begin
            expected_result.RES   = {(`WIDTH+1){1'bZ}};
            expected_result.ERR   = 1'b1;
            expected_result.OFLOW = 1'bZ;
            expected_result.COUT  = 1'bZ;
            expected_result.G     = 1'bZ;
            expected_result.E     = 1'bZ;
            expected_result.L     = 1'bZ;
            count = 0;
            $display("inside 16 and count 16 - timeout error");
          end
          else begin
            expected_result.RES   = {(`WIDTH+1){1'bZ}};
            expected_result.ERR   = 1'bZ;
            expected_result.OFLOW = 1'bZ;
            expected_result.COUT  = 1'bZ;
            expected_result.G     = 1'bZ;
            expected_result.E     = 1'bZ;
            expected_result.L     = 1'bZ;
            count++;
            $display("inside 16 and inp_valid again 1 or 2, count = %0d", count);
          end
        end
        else begin
          $display("outside 16 loop");
          if ((input_stimulus.INP_VALID == 1 || input_stimulus.INP_VALID == 2) && both_op(input_stimulus)) begin
            expected_result.RES   = {(`WIDTH+1){1'bZ}};
            expected_result.ERR   = 1'bZ;
            expected_result.OFLOW = 1'bZ;
            expected_result.COUT  = 1'bZ;
            expected_result.G     = 1'bZ;
            expected_result.E     = 1'bZ;
            expected_result.L     = 1'bZ;
            $display("first inp_valid 1 or 2 occurred for two-operand CMD=%0d", input_stimulus.CMD);
            count = 1;
          end
          else if (input_stimulus.INP_VALID == 0) begin
            expected_result.RES   = {(`WIDTH+1){1'bZ}};
            expected_result.ERR   = 1'b1;
            expected_result.OFLOW = 1'bZ;
            expected_result.COUT  = 1'bZ;
            expected_result.G     = 1'bZ;
            expected_result.E     = 1'bZ;
            expected_result.L     = 1'bZ;
            count = 0;
            $display("outside 16 and inp_valid 0");
          end
          else begin
            expected_result = alu_ref_model(input_stimulus);
            `uvm_info(get_type_name(),
  $sformatf("Scoreboard received from reference model:OPA=%0d OPB=%0d CMD=%0d INP_VALID=%0d CE=%0d MODE=%0d,RES=%0d OFLOW=%0d COUT=%0d E=%0d G=%0d L=%0d ERR=%0d, at %0t",
  expected_result.OPA, expected_result.OPB, expected_result.CMD,
    expected_result.INP_VALID, expected_result.CE, expected_result.MODE,
    expected_result.RES, expected_result.OFLOW, expected_result.COUT,
    expected_result.E, expected_result.G, expected_result.L,
    expected_result.ERR, $time),
  UVM_LOW);

          end
        end
        $display("count = %0d", count);
        latch_res.copy(expected_result);
      end
      else begin
        expected_result.copy(latch_res);
        $display("CE = 0, using latched result, count = %0d", count);
      end

      if ( {actual_result.RES, actual_result.ERR, actual_result.OFLOW, actual_result.COUT,
            actual_result.G,   actual_result.E,   actual_result.L} ===
           {expected_result.RES, expected_result.ERR, expected_result.OFLOW, expected_result.COUT,
            expected_result.G,   expected_result.E,   expected_result.L} ) begin
        match++;
        `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
    //    `uvm_info(get_type_name(), "----------------------------------------", UVM_NONE)
        `uvm_info(get_type_name(),
                  $sformatf("Expected: res=%0d err=%0d oflow=%0d cout=%0d g=%0d e=%0d l=%0d",
                            expected_result.RES, expected_result.ERR, expected_result.OFLOW,
                            expected_result.COUT, expected_result.G, expected_result.E, expected_result.L),
                  UVM_LOW)
        `uvm_info(get_type_name(),
                  $sformatf("Actual  : res=%0d err=%0d oflow=%0d cout=%0d g=%0d e=%0d l=%0d",
                            actual_result.RES, actual_result.ERR, actual_result.OFLOW,
                            actual_result.COUT, actual_result.G, actual_result.E, actual_result.L),
                  UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("number of matches = %0d", match), UVM_LOW)
      end
      else begin
        mismatch++;
        `uvm_error(get_type_name(), "----           TEST FAIL           ----")
        `uvm_info(get_type_name(), "----------------------------------------", UVM_NONE)
        `uvm_info(get_type_name(),
                  $sformatf("Expected: res=%0d err=%0d oflow=%0d cout=%0d g=%0d e=%0d l=%0d",
                            expected_result.RES, expected_result.ERR, expected_result.OFLOW,
                            expected_result.COUT, expected_result.G, expected_result.E, expected_result.L),
                  UVM_LOW)
        `uvm_info(get_type_name(),
                  $sformatf("Actual  : res=%0d err=%0d oflow=%0d cout=%0d g=%0d e=%0d l=%0d",
                            actual_result.RES, actual_result.ERR, actual_result.OFLOW,
                            actual_result.COUT, actual_result.G, actual_result.E, actual_result.L),
                  UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("number of mismatches = %0d", mismatch), UVM_LOW)
      end
    end
  endtask
endclass
