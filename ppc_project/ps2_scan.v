module ps2_scan (
	clk, rst_n, ps2_clk, ps2_data, ps2_byte, ps2_state, ps2_intp, caps_flg
);
	
	input clk;
	input rst_n;
	input ps2_clk;
	input ps2_data;
	output [7:0] ps2_byte;	
	output caps_flg;
	output ps2_state;
	output ps2_intp;
	
	// some parameters
	parameter CAPSLOCK_CODE = 8'h58;
	
	//-----------------------------------------------------
	// capture the negedge of PS/2 keyboard
	reg ps2_clk_r0, ps2_clk_r1, ps2_clk_r2;
	wire neg_ps2_clk;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			ps2_clk_r0 <= 1'b0;
			ps2_clk_r1 <= 1'b0;
			ps2_clk_r2 <= 1'b0;
		end
		else begin
			ps2_clk_r0 <= ps2_clk;
			ps2_clk_r1 <= ps2_clk_r0;
			ps2_clk_r2 <= ps2_clk_r1;
		end	
	end // end always
	
	assign neg_ps2_clk = ps2_clk_r2 & (~ps2_clk_r1);
	
	//------------------------------------------------------
	// receive the data from PS/2. Serial -> parallel
	reg [7:0] ps2_byte_r;			// store the data from PS/2
	reg [7:0] temp_data;			// current accept data
	reg [3:0] num;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			num <= 4'd0;
			temp_data <= 8'd0;
		end
		else if (neg_ps2_clk) begin
			case (num)
				4'd0: begin
					num <= num + 1'b1;
				end
				4'd1: begin
					num <= num + 1'b1;
					temp_data[0] <= ps2_data;
				end
				4'd2: begin
					num <= num + 1'b1;
					temp_data[1] <= ps2_data;
				end
				4'd3: begin
					num <= num + 1'b1;
					temp_data[2] <= ps2_data;
				end
				4'd4: begin
					num <= num + 1'b1;
					temp_data[3] <= ps2_data;
				end
				4'd5: begin
					num <= num + 1'b1;
					temp_data[4] <= ps2_data;
				end
				4'd6: begin
					num <= num + 1'b1;
					temp_data[5] <= ps2_data;
				end
				4'd7: begin
					num <= num + 1'b1;
					temp_data[6] <= ps2_data;
				end
				4'd8: begin
					num <= num + 1'b1;
					temp_data[7] <= ps2_data;
				end
				4'd9: begin
					num <= num + 1'b1;
				end
				4'd10: begin
					num <= 4'b0;
				end
				default: num <= 4'd0;
			endcase
		end
	end // end always
	
	
	//-------------------------------------
	reg key_f0;				// flag to sign the release the key
	reg ps2_state_r;		// high: press the key
	wire neg_ps2_intp;		// key inerrupt-pending
	reg caps_flg_r;		// flag of CapsLock
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			key_f0 		<= 1'b0;
			ps2_state_r <= 1'b0;
			ps2_byte_r  <= 8'd0;
			caps_flg_r	<= 1'b0;
		end
		else if (num == 4'd10) begin		// just send a byte
			if (temp_data == 8'hf0)		   // the break code
				key_f0 <= 1'b1;
			else begin
				if (!key_f0) begin			// store the scan_code
					ps2_state_r <= 1'b1;
					ps2_byte_r <= temp_data;
					if (temp_data == CAPSLOCK_CODE) begin
						caps_flg_r <= ~caps_flg_r;
					end	
				end
				else begin
					ps2_state_r <= 1'b0;
					key_f0 <= 1'b0;
				end
			end	
		end
		else	
			;
	end // end always
	
	// get the negedge of ps2_state_r;
	reg ps2_state_r0, ps2_state_r1, ps2_state_r2;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			ps2_state_r0 <= 1'b0;
			ps2_state_r1 <= 1'b0;
			ps2_state_r2 <= 1'b0;
		end
		else begin
			ps2_state_r0 <= ps2_state_r;
			ps2_state_r1 <= ps2_state_r0;
			ps2_state_r2 <= ps2_state_r1;
		end	
	end // end always
	
	assign neg_ps2_intp= ps2_state_r2 & (~ps2_state_r1);
	
	reg ps2_intp_r;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			ps2_intp_r <= 1'b0;
		else if (neg_ps2_intp)
			ps2_intp_r <= 1'b1;
		else
			ps2_intp_r <= 1'b0;
	end
	
	assign ps2_byte  = ps2_byte_r;
	assign ps2_state = ps2_state_r;
	assign ps2_intp  = ps2_intp_r;
	assign caps_flg  = caps_flg_r;

endmodule
