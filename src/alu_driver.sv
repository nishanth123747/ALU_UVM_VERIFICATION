class alu_driver extends uvm_driver #(alu_sequence_item);
  virtual alu_if vif;
  `uvm_component_utils(alu_driver)


  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
     seq_item_port.item_done();
    end
  endtask

virtual task drive();

  bit flag;
  flag = 0;


  @(posedge vif.DRV.CLK);

  // 2 operand
  if ( (req.MODE == 1'b1 && req.CMD inside {0,1,2,3,8,9,10}) ||
       (req.MODE == 1'b0 && req.CMD inside {0,1,2,3,4,5,12,13}) ) begin

    //  single operand valid (01 or 10)
    if (req.INP_VALID == 2'b01 || req.INP_VALID == 2'b10) begin


      vif.drv_cb.OPA       <= req.OPA;
      vif.drv_cb.OPB       <= req.OPB;
      vif.drv_cb.CIN       <= req.CIN;
      vif.drv_cb.MODE      <= req.MODE;
      vif.drv_cb.CE        <= req.CE;
      vif.drv_cb.CMD       <= req.CMD;
      vif.drv_cb.INP_VALID <= req.INP_VALID;

      `uvm_info("ALU_DRIVER", $sformatf(
        "Initial Drive: OPA=%0d OPB=%0d CMD=%0d INP_VALID=%b AT %0t",
        req.OPA, req.OPB, req.CMD, req.INP_VALID, $time), UVM_LOW)


      req.CMD.rand_mode(0);
      req.CE.rand_mode(0);
      req.MODE.rand_mode(0);

      // wait up to 16 clocks for INP_VALID to become 11
      for (int j = 0; j < 16; j++) begin
        @(posedge vif.DRV.CLK);

        // randomize
        void'(req.randomize());

        vif.drv_cb.OPA       <= req.OPA;
        vif.drv_cb.OPB       <= req.OPB;
        vif.drv_cb.CIN       <= req.CIN;
        vif.drv_cb.INP_VALID <= req.INP_VALID;

        if (req.INP_VALID == 2'b11) begin
          flag = 1;
          break;
        end
      end

      // re-enable
      req.CMD.rand_mode(1);
      req.CE.rand_mode(1);
      req.MODE.rand_mode(1);

//       if (!flag) begin
//         `uvm_error("ALU_DRIVER",
//           "INP_VALID=11 not received within 16 cycles (driver will not force ERR; DUT/scoreboard handles it)")
//       end
    end

    // for 11 or 00
    else if (req.INP_VALID == 2'b11 || req.INP_VALID == 2'b00) begin
      @(posedge vif.DRV.CLK);
      vif.drv_cb.OPA       <= req.OPA;
      vif.drv_cb.OPB       <= req.OPB;
      vif.drv_cb.CIN       <= req.CIN;
      vif.drv_cb.MODE      <= req.MODE;
      vif.drv_cb.CE        <= req.CE;
      vif.drv_cb.CMD       <= req.CMD;
      vif.drv_cb.INP_VALID <= req.INP_VALID;


      repeat (2) @(posedge vif.DRV.CLK);

      `uvm_info("ALU_DRIVER3", $sformatf(
        "DRIVER3: OPA=%0d OPB=%0d CIN=%0d CE=%0d MODE=%0d CMD=%0d INP_VALID=%b AT %0t",
        req.OPA, req.OPB, req.CIN, req.CE, req.MODE, req.CMD, req.INP_VALID, $time), UVM_LOW)
    end
  end

  // single  operand
  else begin
    @(posedge vif.DRV.CLK);
    vif.drv_cb.OPA       <= req.OPA;
    vif.drv_cb.OPB       <= req.OPB;
    vif.drv_cb.CIN       <= req.CIN;
    vif.drv_cb.MODE      <= req.MODE;
    vif.drv_cb.CE        <= req.CE;
    vif.drv_cb.CMD       <= req.CMD;
    vif.drv_cb.INP_VALID <= req.INP_VALID;
    repeat (2) @(posedge vif.DRV.CLK);

    //  for multiply
    if (req.MODE == 1'b1 && (req.CMD == 4'd9 || req.CMD == 4'd10))
      repeat (2) @(posedge vif.DRV.CLK);

    `uvm_info("ALU_DRIVER4", $sformatf(
      "DRIVER4: OPA=%0d OPB=%0d CIN=%0d CE=%0d MODE=%0d CMD=%0d INP_VALID=%b AT %0t",
      req.OPA, req.OPB, req.CIN, req.CE, req.MODE, req.CMD, req.INP_VALID, $time), UVM_LOW)
  end
endtask


endclass

