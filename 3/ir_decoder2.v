module ir_decoder2
(       input wire clk,
        input wire rst,
        input wire enable,
        input wire ir_input,
        output wire ready,
        output wire [31:0] command,
        output wire [3:0] test
);
	localparam T0_MIN = 25312;
	localparam T0_MAX = 30937;
	localparam T1_MIN = 50000;
	localparam T1_MAX = 61875;
	localparam START_MIN = 121770;
	localparam START_MAX = 371250;
	localparam T1_TOP = 1750000;


        wire strobe_front;

	reg  ir_input_last;
	reg [20:0] t1;
	reg [20:0] t2;
	reg [4:0] bit_cout;
	reg [5:0] dem;
	reg [31:0] cmd;
	reg [1250:0] a;



	assign command[31:0] = cmd[31:0];

	assign strobe_front = (ir_input_last != ir_input) * ir_input;
//	assign test[0]= ir_input;
//	assign test[1] = ir_input_last;
//	assign test[2]= strobe_front;
//	assign test[3]='0;
	assign test[3:0] = dem[3:0];     
	always @(posedge clk or posedge rst)
        begin
		if(rst) begin
			ir_input_last <= '1;
		        t1 <= '0;
			bit_cout <= '0;
			dem[5:0] <= 6'b000000;
			cmd<= '0;

                end else begin
                        if(enable)
                        begin	
				t2 <= t2 + '1;
				a[1250:0] <= { a[1249:0], ir_input };
				ir_input_last <= a[1250];
				
				if(strobe_front == 0)
					t1<=t1+'1;
				else begin
					if (bit_cout != 5'b11111)
						dem <= dem + '1;
				        if(t1>START_MIN  && t1<START_MAX) begin
						dem<='0;
						bit_cout <= '0;
						cmd <= '0;
						t2 <= '0;
					end
					if(t1<T0_MAX && t1>T0_MIN) begin
						cmd[bit_cout]<='0;
						bit_cout<=bit_cout+'1;	
					end

					if(t1>T1_MIN && t1<T1_MAX)
					begin
						cmd[bit_cout]<='1;
						bit_cout <= bit_cout + '1;
					end

					t1<='0;	
				end
                        end
                end

        end
endmodule
