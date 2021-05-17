`timescale 1 ns/10 ps

module regFile_tb;

	reg [15:0]data_in;
	reg save;
	reg delete;
	reg reset;
	reg [1:0]save_addr;
	reg [1:0]del_addr;
	reg [1:0]read_addr;

	wire [16:0]data_out;

	regFile regFile_inst(
		.data_in(data_in),
		.save(save),
		.delete(delete),
		.reset(reset),
		.save_addr(save_addr),
		.del_addr(del_addr),
		.read_addr(read_addr),

		.data_out(data_out)
		);


	initial
	begin
		//write
		reset = 1;
		#20

		reset = 0;
		data_in = 16'hFFFF;
		#20

		save = 1;
		save_addr = 2'd1;
		#20

		save = 0;
		#20

		//read
		data_in = 16'hFFFF;
		#20

		read_addr = 2'd1;
		#20

		//delete
		delete = 1;
		del_addr = 2'd1;
		#20

		delete = 0;
		#20			

    $finish;
	end

endmodule