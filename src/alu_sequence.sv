class alu_sequence extends uvm_sequence #(alu_sequence_item);
  `uvm_object_utils(alu_sequence)
  function new(string name = "alu_sequence");
    super.new(name);
  endfunction
  virtual task body();
    alu_sequence_item req;
    req = alu_sequence_item::type_id::create("req");
    start_item(req);
    if (!req.randomize())
      `uvm_error("ALU_SEQ", "Randomization failed")
    finish_item(req);
  endtask
endclass

class alu_sequence1 extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(alu_sequence1)
  function new(string name = "alu_sequence1");
    super.new(name);
  endfunction
  virtual task body();
    alu_sequence_item req;
    repeat(1000) begin
      `uvm_do_with(req, { req.INP_VALID == 3; req.MODE == 1; req.CE == 1; req.CMD inside {[0:3],[8:9]}; })
    end
  endtask
endclass

class alu_sequence2 extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(alu_sequence2)
  function new(string name = "alu_sequence2");
    super.new(name);
  endfunction
  virtual task body();
    alu_sequence_item req;
    repeat(1000) begin
      `uvm_do_with(req, { req.INP_VALID == 3; req.MODE == 0; req.CE == 1; req.CMD inside {[0:5],[12:13]}; })
    end
  endtask
endclass

class alu_sequence3 extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(alu_sequence3)
  function new(string name = "alu_sequence3");
    super.new(name);
  endfunction
  virtual task body();
    alu_sequence_item req;
    repeat(1000) begin
      `uvm_do_with(req, {
        req.INP_VALID == 2'b01;
        (req.MODE == 1) -> req.CMD inside {4, 5};
        (req.MODE != 1) -> req.CMD inside {6, 8, 9};
      })
    end
  endtask
endclass

class alu_sequence4 extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(alu_sequence4)
  function new(string name = "alu_sequence4");
    super.new(name);
  endfunction
  virtual task body();
    alu_sequence_item req;
    repeat(1000) begin
      `uvm_do_with(req, {
        req.INP_VALID == 2'b10;
        req.MODE dist {1 := 50, 0 := 50};
        (req.MODE == 1) -> req.CMD inside {6, 7};
        (req.MODE == 0) -> req.CMD inside {7, 10, 11};
      })
    end
  endtask
endclass

class alu_sequence5 extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(alu_sequence5)
  function new(string name = "alu_sequence5");
    super.new(name);
  endfunction
  virtual task body();
    alu_sequence_item req;
    repeat(1000) begin
      `uvm_do_with(req, { req.INP_VALID == 3; req.CE == 1; req.CMD inside {[5:7]}; })
    end
  endtask
endclass

class alu_sequence6 extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(alu_sequence6)
  function new(string name = "alu_sequence6");
    super.new(name);
  endfunction
  virtual task body();
    alu_sequence_item req;
    repeat(1000) begin
 `uvm_do_with(req, {
  req.CMD inside {[0:15]};
  req.INP_VALID dist {2'b00 := 25, 2'b01 := 25, 2'b10 := 25, 2'b11 := 25};
  req.OPA inside {[0:(2**`WIDTH)-1]};
  req.OPB inside {[0:(2**`WIDTH)-1]};
})
    end
  endtask
endclass


class alu_sequence7 extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(alu_sequence7)
  function new(string name = "alu_sequence7");
    super.new(name);
  endfunction
  virtual task body();
    alu_sequence_item req;
    repeat(1000) begin
`uvm_do_with(req, {
  req.INP_VALID inside {2'b00, 2'b11};
  req.CMD       inside {0};
  req.CE        inside {1};
  req.MODE      inside {0};
})
end
  endtask
endclass

class alu_regression extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(alu_regression)
  function new(string name = "alu_regression");
    super.new(name);
  endfunction
  virtual task body();
    alu_sequence1 seq1;
    alu_sequence2 seq2;
    alu_sequence3 seq3;
    alu_sequence4 seq4;
    alu_sequence5 seq5;
    alu_sequence6 seq6;
    alu_sequence7 seq7;
    `uvm_do(seq1)
    `uvm_do(seq2)
    `uvm_do(seq3)
    `uvm_do(seq4)
    `uvm_do(seq5)
    `uvm_do(seq6)
    `uvm_do(seq6)
  endtask
endclass
