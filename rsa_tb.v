//Designed by Pavan V L
module rsa_tb;
reg clk,rst,enc_dec;
reg [15:0]p,q;
reg [31:0] ext_e_d;
reg [127:0]msg;

wire [127:0]ct_pt_o;
wire invalid;

rsa_design rsa_design_inst(ct_pt_o,invalid,clk,rst,p,q,ext_e_d,msg,enc_dec);

initial begin
clk=0;
rst=1;
p=16'd2;
q=16'd7;
enc_dec=1;
ext_e_d=32'd5;
msg=128'd2;
$monitor(" Message= %0d (%0s)  Cipher text= %0d (%0s) ",msg,msg,ct_pt_o,ct_pt_o);
#800 $finish;
end

always #2 clk=~clk;

initial #3.5 rst=0;

endmodule