`include "defines.sv"
interface alu_if(input logic CLK,input logic RST);
  logic [`WIDTH-1:0]OPA,OPB;
  logic [`CMD_WIDTH -1:0]CMD;
  logic [1:0]INP_VALID;
  logic CE,CIN,MODE;
  logic ERR,OFLOW,COUT,G,L,E;
  logic [`WIDTH:0]RES;

 clocking drv_cb@(posedge CLK);
 default input #0 output #0;
 output OPA,OPB,INP_VALID,MODE,CMD,CE,CIN;
endclocking


clocking mon_cb@(posedge CLK);
default input #0 output #0;
input RES,ERR,OFLOW,G,L,E,COUT,OPA,OPB,CIN,CE,MODE,CMD,INP_VALID;
endclocking


  modport DRV(clocking drv_cb,input CLK,RST);
  modport MON(clocking mon_cb,input CLK,RST);

// clock validity check
property clk_valid_check;
    @(posedge CLK) !$isunknown(CLK);
endproperty
assert property (clk_valid_check)
else $error("[ASSERTION] Clock signal is unknown at time %0t", $time);

//  reset signal validity check
property rst_valid_check;
    @(posedge CLK) !$isunknown(RST);
endproperty
assert_rst_valid: assert property (rst_valid_check)
else $error("[ASSERTION] Reset signal is unknown at time %0t", $time);

// reset signal behavior check
property Reset_signal_check;
    @(posedge CLK) RST |=> (RES === {(`WIDTH+1){1'bz}} && ERR === 1'bz && E === 1'bz && G === 1'bz && L === 1'bz && COUT === 1'bz && OFLOW === 1'bz);
endproperty: Reset_signal_check
assert_reset_behavior: assert property(Reset_signal_check)
else $error("RST assertion FAILED @ time %0t", $time);

//  16-cycle timeout assertion for arithmetic operations 
property ppt_timeout_arithmetic;
    @(posedge CLK) disable iff(RST) (CE && (CMD == `ADD || CMD == `SUB || CMD == `ADD_IN || CMD == `SUB_IN || CMD == `INC_A || CMD == `DEC_A || CMD == `INC_B || CMD == `DEC_B || CMD == `CMP || CMD == `MUL_IN || CMD == `MUL_S) && (INP_VALID == 2'b01 || INP_VALID == 2'b10)) |-> ##16 (ERR == 1'b1);
endproperty: ppt_timeout_arithmetic
assert_timeout_arith: assert property(ppt_timeout_arithmetic)
else $error("Arithmetic timeout assertion failed at time %0t", $time);

// 16-cycle TIMEOUT assertion for logical operations 
property ppt_timeout_logical;
    @(posedge CLK) disable iff(RST) (CE && (CMD == `AND || CMD == `OR || CMD == `NAND || CMD == `XOR || CMD == `XNOR || CMD == `NOR || CMD == `NOT_A || CMD == `NOT_B || CMD == `SHR1_A || CMD == `SHL1_A || CMD == `SHR1_B || CMD == `SHL1_B || CMD == `ROR || CMD == `ROL) && (INP_VALID == 2'b01 || INP_VALID == 2'b10)) |-> ##16 (ERR == 1'b1);
endproperty: ppt_timeout_logical
assert_timeout_logical: assert property(ppt_timeout_logical)
else $error("Logical timeout assertion failed at time %0t", $time);

//  ROR/ROL error assertion 
property ror_rol_error_check;
    @(posedge CLK) disable iff(RST) (CE && MODE && INP_VALID == 2'b11 && (CMD == `ROR || CMD == `ROL) && $countones(OPB) > `ROR_WIDTH + 1) |-> ##1 ERR;
endproperty: ror_rol_error_check
assert_ror_rol_error: assert property(ror_rol_error_check)
else $error("ROR/ROL error assertion failed at time %0t", $time);

//  CMD validation for arithmetic mode 
property CMD_validation_arithmetic;
    @(posedge CLK) disable iff(RST) (MODE && CMD > `MUL_S) |-> ##1 ERR;
endproperty: CMD_validation_arithmetic
assert_cmd_arith: assert property(CMD_validation_arithmetic)
else $error("CMD out of range for arithmetic assertion failed at time %0t", $time);

//  CMD validation for logical mode 
property CMD_validation_logical;
    @(posedge CLK) disable iff(RST) (!MODE && CMD > `ROR) |-> ##1 ERR;
endproperty: CMD_validation_logical
assert_cmd_logical: assert property(CMD_validation_logical)
else $error("CMD out of range for logical assertion failed at time %0t", $time);

//  INP_VALID 00 case error detection
property Error_detection_in_inp_valid_00;
    @(posedge CLK) disable iff(RST) (CE && INP_VALID == 2'b00) |-> ##1 ERR;
endproperty: Error_detection_in_inp_valid_00
assert_inp_valid_00: assert property(Error_detection_in_inp_valid_00)
else $error("INP_VALID 00 assertion failed at time %0t", $time);

//  clock enable functionality
property Clock_enable_functionality;
    @(posedge CLK) disable iff(RST) !CE |-> ##1 ($stable(RES) && $stable(COUT) && $stable(OFLOW) && $stable(G) && $stable(L) && $stable(E) && $stable(ERR));
endproperty: Clock_enable_functionality
assert_clock_enable: assert property(Clock_enable_functionality)
else $error("Clock enable assertion failed at time %0t", $time);

//  valid inputs check
property VALID_INPUTS_CHECK;
    @(posedge CLK) disable iff(RST) CE |-> !$isunknown({OPA,OPB,INP_VALID,CIN,MODE,CMD});
endproperty: VALID_INPUTS_CHECK
assert_valid_inputs: assert property(VALID_INPUTS_CHECK)
else $error("Input validity assertion failed at time %0t", $time);
endinterface
