module controller_tb;

	reg clk;
	reg reset;
	reg enter;
	reg delete;
	reg lock;
	reg [2:0]counter;
	reg saver_done;
	reg deleter_done;
	reg error_open;
	reg comparator_done;
	reg match;

	wire save_start;
	wire delete_start;
	wire compare_start;
	wire unlock;
	wire error;


	controller controller_inst (

		.clk(clk),
		.reset(reset),
		.enter(enter),
		.delete(delete),
		.lock(lock),
		.counter(counter),
		.saver_done(saver_done),
		.deleter_done(deleter_done),
		.error_open(error_open),
		.comparator_done(comparator_done),
		.match(match),

		.save_start(save_start),
		.delete_start(delete_start),
		.compare_start(compare_start),
		.unlock(unlock),
		.error(error)

		);

    //clk generation////////////////!!!!!!!!!!!!!
	always
	begin
	clk = 1;
	#10;
	clk = 0;
	#10;
	end

	initial
	begin
		reset = 1;
		counter = 0;
		enter = 0;
		delete = 0;
		#20;

		reset = 0;
		enter = 0;
		counter = 1;
		#20;

		counter = 3;
		enter = 1;
		#20;

		enter = 0;
		counter = 3;
		#40;

		counter = 4;
		enter = 1;
		#20;

		enter = 0;
		saver_done = 0;
		#40;

		saver_done = 1;
		#20;

		delete = 0;
		#20;

		counter = 4;
		enter = 1;
		saver_done = 0;
		#40;

		enter = 0;
		saver_done = 1;
		error_open = 1;
		#40;

		counter = 4;
		delete = 1;
		#20;

		delete = 0;
		#20;

		deleter_done = 1;
		error_open = 0;
		#20;

		deleter_done = 0;
		lock = 1;
		#20;

		lock = 0;
		counter = 3;
		#20;

		counter = 4;
		#20;

		counter = 0;
		
		match = 0;
		#40;
		
        comparator_done = 1;
        #20;
		comparator_done = 0;
		#20;
		
		counter = 4;
		#20;

		comparator_done = 1;
		match = 1;
		counter = 0;
		#20;
		
		$monitor($time, "%b,%b,%b,%b,%b", save_start, delete_start, compare_start, unlock, error);
		
	$finish;
	end

endmodule