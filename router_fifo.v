`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:18:53 08/15/2018 
// Design Name: 
// Module Name:    router_fifo 
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
module router_fifo(
    input clock,
    input [7:0] data_in,
    input write_enb,
    input read_enb,
    input resetn,soft_reset,
    input lfd_state,
    output full,
    output empty,
    output reg [7:0] data_out
    );

reg [8:0]mem[15:0];
reg [4:0]write_ptr=0,read_ptr=0;
reg [6:0] count; 



// write logic into fifo
always@(posedge clock)
 begin
   if(~resetn)
	  begin : B1
	  integer i;
	    for(i=0;i<16;i=i+1)
		  mem[i]<=0;
	  end
	 else if(soft_reset)
		        begin: B2
				  integer i;
				  for(i=0;i<16;i=i+1)
				    mem[i]<=0;
				  end
	 else if(write_enb && ~full)
		 begin
			 {mem[write_ptr[3:0]][8],mem[write_ptr[3:0]][7:0]}<={lfd_state,data_in};
		  end
 end
 
 // read logic fro fifo
 
always@(posedge clock)
  begin
   if(~resetn)
	   data_out<=0;
		else if(soft_reset)
		  data_out<=8'bz;
		    else if( count==0 && data_out!=0)
			    data_out<=8'bz;
			  else if( read_enb && ~empty)
			   data_out<=mem[read_ptr[3:0]][7:0];					
            
 end
 

// pointer logic

always@(posedge clock)
 begin
   if(~resetn)
	  begin
	   read_ptr<=0;
		write_ptr<=0;
	  end
     else if(soft_reset)
	   begin
		 read_ptr<=0;
		 write_ptr<=0;
		end
		  else
          begin		  
		  if(write_enb && ~full) write_ptr<=write_ptr+1'b1;
        if(read_enb && ~empty) read_ptr<=read_ptr+1'b1;
		     end

 end
 
 //counter logic
always@(posedge clock) 
if(~resetn)
count<=0;
 else
 begin
  if(read_enb && ~empty && (mem[read_ptr[3:0]][8]==1))
  
	  count=mem[read_ptr[3:0]][7:2]+1'b1;
	   else if(read_enb && ~empty&& count!=0)
		 count=count-1;
		  else if( read_enb && ~empty)
		   count<=0;
	end


assign full=((write_ptr[3:0]==read_ptr[3:0]) && (write_ptr[4]!=read_ptr[4]))?1'b1:1'b0;
assign empty=(read_ptr==write_ptr);

endmodule
			