module top (
	input wire clk25,
	inout wire [3:0] gpio,
	output wire [3:0] led,
	input wire [3:0] key
);

	wire [3:0] test;
	wire rst;
	wire ir_ready;
	wire [31:0] ir_cmd;

	assign rst = key[3];

//	assign led[3] = ir_cmd[30];
//	assign led[2] = ir_cmd[20];
//	assign led[1] = ir_cmd[11];
//	assign led[0] = ir_cmd[0];
//	assign led[3:0] = ir_cmd[3:0];

//	assign gpio[1:0] = test[1:0];
//	assign gpio[2] = test[2];
	assign led[3:0] = test[3:0];

	ir_decoder ir_dec(
			.clk(clk25),
			.rst(rst),
			.enable(1'b1),
			.ir_input(gpio[3]),
			.ready(ir_ready),
			.command(ir_cmd),
			.test(test[3:0]));

/*	always_ff @(posedge clk25 or posedge rst)
	begin
		if(rst) begin

		end else begin
			// To-Do

		end

	end*/
endmodule
