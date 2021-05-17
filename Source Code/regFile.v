module regFile (

	input reset,
	input save,
	input delete,
	input [15:0]data_in,		
	input [1:0]save_addr,						//three registers, 00,10,01, two bits
	input [1:0]del_addr,
	input [1:0]read_addr,

	output reg [16:0]data_out	
	
);

	reg [16:0]register[0:2];	

	always @(posedge reset) begin				//must be @ one edge!
		register[0][16] <= 0;					//reset: clear all the available-bits
		register[1][16] <= 0;
		register[2][16] <= 0;
	end

	//save
	always @(posedge save) begin
		register[save_addr][15:0] = data_in;
		register[save_addr][16] = 1;			//change available bit to 1
	end

	//delete
	always @(posedge delete) begin
		register[del_addr][16] = 0;				//only need to clear available-bit
	end

	//read
	always @(*) begin							//data_out not up to date if always@(read_addr)
		data_out = register[read_addr];			//output all 17 digits
	end

endmodule