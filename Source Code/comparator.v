module comparator (

	input clk,
	input start,
	input reset,
	input [16:0]data_in,
	input compare_done, compare_match,		//result from pwChecker

	output reg [1:0]read_addr,
	output reg [1:0]del_addr,
	output reg compare_start,				//signal telling pwCheck to compare
	output reg finish,
	output reg match						//signal telling RF to delete
);

	parameter START = 2'd0,					//2 bits to represent 4 states
			  LOOP = 2'd1,
			  COMPARE = 2'd2,
			  DONE = 2'd3;

	reg [1:0]current_state;
	reg [1:0]next_state;


	always @(posedge clk) begin
		if(reset)
			current_state <= 0;
		else
			current_state <= next_state;
	end


	always @(negedge clk) begin				//negedge
		case(current_state)
		START: begin
		       finish = 0;
			   read_addr = 0;
			   next_state = (start) ? LOOP : START;
			   end

		LOOP: begin
		      finish = 0;
		      compare_start = 0;
			  if (data_in[16])
			  	next_state = COMPARE;
			  else begin
			  	next_state = (read_addr == 2) ? DONE : LOOP;
			  	read_addr = read_addr + 1;
			  end			  	
			  end

		COMPARE: begin
		         finish = 0;
				 compare_start = 1;
				 if (!compare_done)
				 	next_state = COMPARE;
				 else if (compare_match)
				 	next_state = DONE;
				 else begin
				 	read_addr = read_addr + 1;
				 	next_state = LOOP;
				 end
				 end

		DONE: begin
			  next_state = START;
			  compare_start = 0;			//stop comparing
			  finish = 1;
			  del_addr = read_addr;
			  if (read_addr == 3)
			  	match = 0;
			  else
			  	match = 1;
			  end

		default: next_state = START;
		endcase
	end

endmodule
