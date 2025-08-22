module top;
  import uvm_pkg::*;
  import alu_pkg::*;

  bit clk;
  bit rst;

  always #5 clk = ~clk;


  initial begin
    clk = 0;
    rst = 1;
    #5 rst = 0;
  end

  alu_if intf(clk, rst);

  alu DUV(
    .OPA       (intf.OPA),
    .OPB       (intf.OPB),
    .CIN       (intf.CIN),
    .CE        (intf.CE),
    .MODE      (intf.MODE),
    .CLK       (clk),
    .RST       (rst),
    .CMD       (intf.CMD),
    .INP_VALID (intf.INP_VALID),
    .COUT      (intf.COUT),
    .OFLOW     (intf.OFLOW),
    .G         (intf.G),
    .E         (intf.E),
    .L         (intf.L),
    .ERR       (intf.ERR),
    .RES       (intf.RES)
  );

  initial begin
    uvm_config_db#(virtual alu_if)::set(uvm_root::get(), "*", "vif", intf);
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  // Run UVM test
//   initial begin
//     run_test("alu_test");
//     #100 $finish;
//   end
  initial begin:run
        run_test("alu_regression_test");
        #100 $finish;
    end:run

endmodule

