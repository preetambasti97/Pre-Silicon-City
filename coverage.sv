
class coverage extends uvm_subscriber#(write_xtn);
  `uvm_component_utils(coverage);
  
  virtual parallel_processor_if.MONITOR2_MP vif;
        parallel_processor_config m_cfg;
	write_xtn  xtn;
	real cov,cov1,cov2,cov3;
  
  byte unsigned A, B;
  bit [3:0]OPCODE;
  

 covergroup all_op_cov;
  option.per_instance = 1;
    coverpoint vif.monitor1_cb.OPCODE[0] {
      bins single_cycle[] = {[0:3], [10:15]};
      bins multi_cycle[] = {[4:7]};
      bins load_store[] = {[8:9]}; 
}

coverpoint vif.monitor1_cb.OPCODE[1] {
      bins single_cycle[] = {[0:3], [10:15]};
      bins multi_cycle[] = {[4:7]};
      bins load_store[] = {[8:9]}; 
}

coverpoint vif.monitor1_cb.OPCODE[2] {
      bins single_cycle[] = {[0:3], [10:15]};
      bins multi_cycle[] = {[4:7]};
      bins load_store[] = {[8:9]}; 
}

coverpoint vif.monitor1_cb.OPCODE[3] {
      bins single_cycle[] = {[0:3], [10:15]};
      bins multi_cycle[] = {[4:7]};
      bins load_store[] = {[8:9]};  
}

endgroup:all_op_cov

covergroup op_trans_cov;
  option.per_instance = 1;
    coverpoint vif.monitor1_cb.OPCODE[0] {
      bins singletomult = ([0:3], [10:15] => [4:7]);
      bins multtosingle = ([4:7] => [0:3], [10:15]);
      bins multb2b = ([4:7][->2]);
}
    coverpoint vif.monitor1_cb.OPCODE[1] {
      bins singletomult = ([0:3], [10:15] => [4:7]);
      bins multtosingle = ([4:7] => [0:3], [10:15]);
      bins multb2b = ([4:7][->2]);
}
    coverpoint vif.monitor1_cb.OPCODE[2] {
      bins singletomult = ([0:3], [10:15] => [4:7]);
      bins multtosingle = ([4:7] => [0:3], [10:15]);
      bins multb2b = ([4:7][->2]);
}
    coverpoint vif.monitor1_cb.OPCODE[3] {
      bins singletomult = ([0:3], [10:15] => [4:7]);
      bins multtosingle = ([4:7] => [0:3], [10:15]);
      bins multb2b = ([4:7][->2]);
      bins singleb2b = ([0:3], [10:15][->2]);
}

endgroup:op_trans_cov

covergroup load_store_cov;
   coverpoint vif.monitor1_cb.OPCODE[0] {
	bins load2load = (8 =>8);
	bins store2store = (9 => 9);
	//bins load2store = (8=> 9);
	//bins store2load = (9 => 8);
	bins loadstoreb2b = ([8:9][->2]);
	}

   coverpoint vif.monitor1_cb.OPCODE[1] {
	bins load2load = (8 =>8);
	bins store2store = (9 => 9);
	//bins load2store = (8=> 9);
	//bins store2load = (9 => 8);
	bins loadstoreb2b = ([8:9][->2]);
	}

   coverpoint vif.monitor1_cb.OPCODE[2] {
	bins load2load = (8 =>8);
	bins store2store = (9 => 9);
	//bins load2store = (8=> 9);
	//bins store2load = (9 => 8);
	bins loadstoreb2b = ([8:9][->2]);
	}

   coverpoint vif.monitor1_cb.OPCODE[3] {
	bins load2load = (8 =>8);
	bins store2store = (9 => 9);
	//bins load2store = (8=> 9);
	//bins store2load = (9 => 8);
	bins loadstoreb2b = ([8:9][->2]);
	}
endgroup : load_store_cov 



  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    
    all_op_cov = new();
    op_trans_cov = new();
    load_store_cov = new();
    //cg =new();
    
  endfunction : new
  
  function void build_phase (uvm_phase phase);
        super.build_phase(phase);

	  if(!uvm_config_db #(parallel_processor_config)::get(this,"","parallel_processor_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
   endfunction

function void connect_phase(uvm_phase phase);
          vif = m_cfg.vif;
endfunction

 
function void write(write_xtn t);
    xtn=t;
    //op_cov1.sample();
  endfunction


task run_phase(uvm_phase phase);
    forever begin
      @( vif.monitor1_cb);
	all_op_cov.sample();
	op_trans_cov.sample();
	load_store_cov.sample();
	//cg.sample();
	end
endtask

function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov=all_op_cov.get_coverage();
    cov1=op_trans_cov.get_coverage();
    cov2=load_store_cov.get_coverage();
    //cov3=cg.get_coverage();
  endfunction


function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Coverage is %f",cov),UVM_MEDIUM)
  endfunction
  

endclass
 
