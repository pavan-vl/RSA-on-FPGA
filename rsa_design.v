//Designed by Pavan V L
module rsa_design(ct_pt_o,invalid,clk,rst,p,q,ext_e_d,msg,enc_dec);
input clk,rst,enc_dec;
input [15:0]p, q;
input [31:0]ext_e_d;
input [127:0]msg;
output reg [127:0]ct_pt_o;
output reg invalid;

reg [31:0]n, phi_n; // N and phi(N)
reg [31:0]exp_val; // exponenet value
reg [31:0]gcd_a, gcd_b; // for calculating gcd using Euclidean algorithm
reg [127:0]b, tmp_res; // base and temporary result
reg [3:0]state;
reg valid;
    
localparam idle=0,gcd_st=1,chk_valid=2,store_expo=3,loop_expo=4,finish_st=5;
    
always @(posedge clk or posedge rst) begin
if(rst) begin
ct_pt_o<=0;
invalid<=0;
state<=idle;
valid<=0;
n<=0;
phi_n<=0;
exp_val<=0;
gcd_a<=0;
gcd_b<=0;
b<=0;
tmp_res<=0;
end 
else begin
case (state)
    idle: begin
        n<=p*q;
        phi_n<=(p-1)*(q-1);
        gcd_a<=ext_e_d;
        gcd_b<=phi_n;
        state<=gcd_st;
    end
                
    gcd_st: begin
        if(gcd_b!=0) begin
            gcd_a<= gcd_b;
            gcd_b<=gcd_a%gcd_b;
        end 
		else 
            state <= chk_valid;
    end
                
    chk_valid: begin
        valid<=(gcd_a==1);
        if(valid)begin
            b<=msg;
            tmp_res<=1;
            exp_val<=ext_e_d;
            state<=store_expo;
            invalid<=0;
        end 
		else begin
            invalid<=1;
            ct_pt_o<=0;
            state<=finish_st;
        end
    end
                
    store_expo: begin
        state<=loop_expo;
    end
                
    loop_expo: begin
        if (exp_val!=0) begin
            if(exp_val[0])
                tmp_res<=(tmp_res*b)%n;  // multiply if LSB is 1
            b<=(b* b)%n;  // square the base
            exp_val<= exp_val>>1;  
            end 
			else 
                state<=finish_st;
    end
                
    finish_st: begin
        ct_pt_o <= tmp_res;
		state<=idle;
    end
    default: state<=idle;
endcase
end
end
endmodule
