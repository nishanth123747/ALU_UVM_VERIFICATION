`include "defines.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;

class alu_sequence_item extends uvm_sequence_item;

  rand bit CE, CIN, MODE;
  rand bit [1:0] INP_VALID;
  rand bit [`CMD_WIDTH-1:0] CMD;
  rand bit [`WIDTH-1:0] OPA, OPB;


  bit [`WIDTH:0] RES;
  bit E, G, L, ERR,COUT,OFLOW;


  `uvm_object_utils_begin(alu_sequence_item)
    `uvm_field_int(OPA,        UVM_ALL_ON)
    `uvm_field_int(OPB,        UVM_ALL_ON)
    `uvm_field_int(CIN,        UVM_ALL_ON)
    `uvm_field_int(CE,         UVM_ALL_ON)
    `uvm_field_int(MODE,       UVM_ALL_ON)
    `uvm_field_int(INP_VALID,  UVM_ALL_ON)
    `uvm_field_int(CMD,        UVM_ALL_ON)
    `uvm_field_int(RES,        UVM_ALL_ON)
    `uvm_field_int(E,          UVM_ALL_ON)
    `uvm_field_int(G,          UVM_ALL_ON)
    `uvm_field_int(L,          UVM_ALL_ON)
    `uvm_field_int(ERR,        UVM_ALL_ON)
  `uvm_field_int(COUT,        UVM_ALL_ON)
  `uvm_field_int(OFLOW,        UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "alu_sequence_item");
    super.new(name);
  endfunction

endclass
