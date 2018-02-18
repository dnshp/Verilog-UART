`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2018 03:57:55 PM
// Design Name: 
// Module Name: num_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module num_gen(ready, data, start, rst);
    input ready;
    output reg [7:0] data;
    output start;
    output rst;
    
    initial data = 8'h00;
    
    always @(posedge ready) data <= data + 1;
        
    assign start = 1;
    assign rst = 0;
endmodule
