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
	
	reg [15:0] slow_clk_div;
	wire slow_clk;

	assign slow_clk = slow_clk_div[5];

	assign rst = key[3];

	assign led[3:0] = ir_ready ? ir_cmd[27:24] : '0;

	ir_decoder2 ir_dec(
			.clk(slow_clk),
			.rst(rst),
			.enable('1),
			.ir_input(gpio[3]),
			.ready(ir_ready),
			.command(ir_cmd),
			.test(test[3:0]));

	always @(posedge clk25 or posedge rst)
	begin
		if(rst) begin
			slow_clk_div <= '0;
		end else begin
			slow_clk_div <= slow_clk_div + 'd1;
		end

	end
endmodule
