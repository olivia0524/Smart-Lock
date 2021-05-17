module saver (
	input clk,
	input start,
	input reset,
	input [16:0]data_in,							//input from register file

	output reg[1:0]read_addr,
	output reg[1:0]save_addr,
	output reg finish,								//finish signal no matter success or error
	output reg save_start,							//signal directed to RF to start saving
	output reg error								//signal directed to controller for error
);


	parameter START = 2'b00,
			  LOOP = 2'b01,
			  DONE = 2'b10;

	reg [1:0]current_state;
	reg [1:0]next_state;
		

	always @(posedge clk) begin
		if(reset)
			current_state <= 0;
		else
			current_state <= next_state;
	end

	always @(posedge clk) begin
		case (current_state)
		START: begin
		       save_start = 0;
		       finish = 0;
			   read_addr = 0;								//initialize read_addr to 0
			   next_state = start ? LOOP : START;			//when start = 1, move to next state
			   end

		LOOP: begin
		      finish = 0;
			  if (data_in[16]) begin
			  	read_addr = read_addr + 1;					//if reg0 not available, check reg1
			  	next_state = read_addr != 3 ? LOOP : DONE;	//if rege not available, error
			  end
			  else
			  	next_state = DONE;							//if reg0 available, save	
			  end

		DONE: begin
			  next_state = START;
			  finish = 1;
			  save_addr = read_addr;

			  if (read_addr == 3) begin
			  	error = 1;
			  	save_start = 0;
			  end

			  else begin
			  	error = 0;									//if don't write error = 0, latch waste
			  	save_start = 1;
			  end
			  end

		default: next_state = START;
		endcase
	end


endmodule