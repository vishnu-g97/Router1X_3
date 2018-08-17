`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:29:53 08/15/2018 
// Design Name: 
// Module Name:    router_fifo_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module router_fifo_tb();
reg clk,resetn,soft_reset,write_enb,read_enb,lfd_state;
reg [7:0]data_in;

wire full,empty;
wire [7:0]data_out;
integer i;
router_fifo DUT(clk,data_in,write_enb,read_enb, resetn,soft_reset,lfd_state,full,empty,data_out);


always
begin
clk=0;
forever
#10 clk=~clk;
end


// packet generation
task pkt_gen;
reg[7:0]payload_data,parity,header;
reg[5:0]payload_len;
reg[1:0]addr;

begin
@(negedge clk);
payload_len=6'd4;
addr=2'b01;
header={payload_len,addr};
data_in=header;
lfd_state=1'b1;
write_enb=1;
for(i=0;i<payload_len;i=i+1)
begin
@(negedge clk);
lfd_state=0;
payload_data={$random}%256;
data_in=payload_data;
end

@(negedge clk);
parity={$random}%256;
data_in=parity;

//@(negedge clk);
//write_enb=0;
//data_in=0;
end
endtask
task pkt_read;
 
    	  begin
	  @(negedge clk);
	  read_enb=1'b0;
	  @(negedge clk);
	  read_enb=1'b1;
	  end 
	  
	  endtask
	  
	  task soft_reset1();
	  begin
	  @(negedge clk);
	  soft_reset=1;
	  @(negedge clk);
	  soft_reset=0;
	  end
	  endtask
	  
	  task reset1;
	  begin
	  @(negedge clk);
	  resetn=0;
	  @(negedge clk);
	  resetn=1;
	  end 
	 
	  endtask
	  
	/*  task read1();
	  begin
	    @(negedge clk);
		 read_enb=1'b0;
		 @(negedge clk);
		 read_enb=1'b1;
	  end
	  endtask */
	  
	  
	  initial
	  begin
	   reset1;
		soft_reset1();
		pkt_gen;
		read_enb=1;
		//read1;
		@(negedge clk)
		write_enb=0;
		
		//pkt_read();
	//	pkt_gen;
		
		//repeat(5)
		//read_enb=1;
		
		end
	
		endmodule
	  
	   
	  
	  
	  
   
	




