module controller (

	input clk,
	input reset,
	input enter,
	input delete,
	input lock,
	input [2:0]counter,
	input saver_done,
	input deleter_done,
	input error_open,
	input comparator_done,
	input match,

	output reg save_start,
	output reg delete_start,
	output reg compare_start,
	output reg [1:0] op_mode,  // 0 means standby, 1 means saver, 2 means deleter, 3 means comparator
	output reg unlock,
	output reg error

);

	parameter IDLE = 4'd0,
			  ERROR_INIT = 4'd1,
			  SAVE_INIT = 4'd2,
			  OPEN = 4'd3,
			  SAVE = 4'd4,
			  DELETE = 4'd5,
			  ERROR_OPEN = 4'd6,
			  LOCKED = 4'd7,
			  COMPARE = 4'd8,
			  UNLOCK = 4'd9,
			  ERROR_LOCK = 4'd10;

	reg [3:0]current_state, next_state;

	always @(posedge clk) begin
		if(reset)
			current_state <= 0;
		else
			current_state <= next_state;
	end

	always @(negedge clk) begin
		case(current_state)
		//state 0
		IDLE: begin
			  error <= 0;
			  save_start <= 0;
			  delete_start <= 0;		//initialize
			  op_mode <= 0;
			  if (!enter)
			  	next_state <= IDLE;
			  else 
			  	next_state <= (counter != 3'd4) ? ERROR_INIT : SAVE_INIT;
			  end
        //state 1
		ERROR_INIT: begin
					error <= 1;
					next_state <= IDLE;
				    end
        //state 2
		SAVE_INIT: begin
				   save_start <= 1;
				   op_mode <= 1;
				   next_state <= (saver_done) ? OPEN : SAVE_INIT;
				   end
        //state 3
		OPEN: begin
			  error <= 0;
			  save_start <= 0;
			  delete_start <= 0;
			  op_mode <= 0;
			  if (lock)
			  	next_state <= LOCKED;
			  else begin
				if (!enter && !delete)
			  		next_state <= OPEN;
			  	else if (counter != 4'd4)
			  		next_state <= ERROR_OPEN;
			  	else
			  		next_state <= (enter) ? SAVE : DELETE;
			  end
			  end
        //state 4
		SAVE: begin
			  save_start <= 1;
			  op_mode <= 1;
			  if (!saver_done)
			  	next_state <= SAVE;
			  else 
			  	next_state <= (!error_open) ? OPEN : ERROR_OPEN;
			  end
        //state 5
		DELETE: begin
			    delete_start <= 1;
			    op_mode <= 2'd2;
				if (!deleter_done)
					next_state <= DELETE;
				else
					next_state <= (!error_open) ? OPEN : ERROR_OPEN;
				end
        //state 6
		ERROR_OPEN: begin
		        save_start <= 0;
		        delete_start <= 0;
				error <= 1;
				next_state <= OPEN;
			    end
        //state 7
		LOCKED: begin
				error <= 0;
				next_state <= (counter == 4'd4) ? COMPARE : LOCKED;
				end
        //state 8
		COMPARE: begin
				 compare_start <= 1;
				 op_mode <= 2'd3;
				 if (!comparator_done)
				 	next_state <= COMPARE;
				 else
				 	next_state <= (match) ? UNLOCK : ERROR_LOCK;
				 end
        //state 9
		UNLOCK: begin
				unlock <= 1;
				next_state <= OPEN;
			    end
        //state 10
		ERROR_LOCK: begin
					error <= 1;
					next_state <= LOCKED;
				    end
		default: next_state <= IDLE;
		endcase
	end

endmodule