module ADD_SUB#(
	parameter N = 8
)(
	input c_in,
	input [N-1:0] x, y,
	output [N-1:0] sum
);

wire     [N-1:0] t;

assign t = y ^ {N{c_in}};
assign sum = x + t + c_in;

endmodule


module booth_substep#(
	parameter N = 8
)(
	input signed [N-1:0] acc,
	input signed [N-1:0] Q,
	input signed q0,
	input signed [N-1:0] multiplicand,
	output reg signed [N-1:0] next_acc,
	output reg signed [N-1:0] next_Q,
	output reg q0_next
);
    
wire [N-1:0] addsub_temp;
	
ADD_SUB U_ADD_SUB(Q[0], acc, multiplicand, addsub_temp);
	
always @(*) begin	
	if(Q[0] == q0) begin
        	q0_next = Q[0];
        	next_Q = Q>>1;
        	next_Q[N-1] = acc[0];
        	next_acc = acc>>1;

		if (acc[N-1] == 1)
                	next_acc[N-1] = 1;
		end

		else begin
           		q0_next = Q[0];
			next_Q = Q>>1;
            		next_Q[N-1] = addsub_temp[0];
			next_acc = addsub_temp>>1;
			if (addsub_temp[N-1] == 1) begin
                		next_acc[N-1] = 1;
			end
		end			
	end	
endmodule 


module booth_multiplier(
	input signed [7:0] multiplier, multiplicand,
	output signed [15:0] product
);

wire signed [7:0] Q[0:6];
wire signed [7:0] acc[0:7];
wire signed [7:0] q0;
wire qout;
    
assign acc[0] = 8'b00000000;
    
booth_substep step1(acc[0], multiplier, 1'b0, multiplicand, acc[1], Q[0], q0[1]);
booth_substep step2(acc[1], Q[0], q0[1], multiplicand, acc[2], Q[1], q0[2]);
booth_substep step3(acc[2], Q[1], q0[2], multiplicand, acc[3], Q[2], q0[3]);
booth_substep step4(acc[3], Q[2], q0[3], multiplicand, acc[4], Q[3], q0[4]);
booth_substep step5(acc[4], Q[3], q0[4], multiplicand, acc[5], Q[4], q0[5]);
booth_substep step6(acc[5], Q[4], q0[5], multiplicand, acc[6], Q[5], q0[6]);
booth_substep step7(acc[6], Q[5], q0[6], multiplicand, acc[7], Q[6], q0[7]);
booth_substep step8(acc[7], Q[6], q0[7], multiplicand, product[15:8], product[7:0], qout);
    
endmodule


