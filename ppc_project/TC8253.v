`include "arch_def.v"

module TC8253 (
	clk, rst_n, addr, we, wd, TC8253_data, TC8253_out
);
    
    
    input clk;
    input rst_n;
    input [1:0] addr;
    input we;
    input [31:0] wd;
    output [31:0] TC8253_data;
    output TC8253_out;
    

    
    wire we_mode;
    wire we_count;
    
    assign we_mode = we && ( addr[0] == 1'b0 );
    assign we_count = we && ( addr[0] == 1'b1 );
    
    
    // MODE timing-logic
    reg [31:0] MODE;

    always @( posedge clk or negedge rst_n ) begin
       if (!rst_n)
          MODE <= 32'd0;
       else if (we_mode)
          MODE <= { 29'd0,wd[2:0] }; 
       else 
          ;
    end // end always
    

    // count timing-logic
    reg [31:0] INIT_CNT;
    
    always @( posedge clk or negedge rst_n ) begin
       if (!rst_n) begin
          INIT_CNT <= 32'd0;
       end 
       else if (we_count) begin
          INIT_CNT <= wd;
       end
       else begin
          INIT_CNT <= INIT_CNT; 
       end
    end // end always
    
    // start timing-logic
    reg stop;
    
    always @( posedge clk or negedge rst_n ) begin
       if (!rst_n)
          stop <= 1'b1;
       else if (we_mode)
          stop <= 1'b1;
       else if (we_count)
          stop <= 1'b0;
       else   ;          
    end
    
    // cnt timing-logic
    reg [31:0] cnt;
    
    always @( posedge clk or negedge rst_n ) begin
        if (!rst_n) begin
			cnt <= 32'd0;
        end
        else if (we_count) begin
			cnt <= wd;
        end
        else if (!stop) begin
			if (MODE[2:0] == 3'b001) begin
				if (cnt != 32'd0)
					cnt <= cnt - 1'b1;
				else
					cnt <= cnt;
			end
			else if (MODE[2:0] == 3'b011 || MODE[2:0] == 3'b101) begin
				if (cnt == 32'd0)
					cnt <= cnt;
				else if (cnt == 32'd1)
					cnt <= INIT_CNT;
				else
					cnt <= cnt - 1'b1;
			end
		end
        else begin
            cnt <= cnt;
		end
    end // end always
    
    
    // output comb-logic
    reg out_r;
    
    always @( posedge clk or negedge rst_n ) begin
		if (!rst_n)
			out_r <= 1'b0;
		else if (we_mode)
			out_r <= 1'b0;
		else if (!stop) begin       
			case ( MODE[2:0] )
				3'b001: begin            // MODE0: Interrupt Signal Generator
					if (cnt == 32'd0)
						out_r <= 1'b1;
					else
						out_r <= 1'b0;      
				end
				3'b011: begin            // MODE1: Frequency Timing Generator
					if (cnt == 32'd1)
						out_r <= 1'b1;
					else
						out_r <= 1'b0;
				end   
				3'b101: begin            // MODE2: Sequare Wave Generator
					if (cnt > { 1'b0, INIT_CNT[31:1] })
						out_r <= 1'b0;
					else
						out_r <= 1'b1;
				end
				default: begin
					out_r <= 1'b1;      
				end
			endcase
		end
		else begin
			out_r <= out_r;
		end
    end // end always
    
    
    reg [31:0] TC8253_DATA;
    
    always @( addr or MODE or INIT_CNT or cnt ) begin
       case (addr)
          2'b00: TC8253_DATA = MODE;
          2'b01: TC8253_DATA = INIT_CNT;
          2'b10: TC8253_DATA = cnt;
          default: TC8253_DATA = 32'd0;
       endcase    
    end
        
    assign TC8253_data = TC8253_DATA;
    
    assign TC8253_out = out_r;
    
    
endmodule    
