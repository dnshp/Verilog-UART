`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2018 04:39:40 PM
// Design Name: 
// Module Name: uart_tx
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


module baud_generator(sys_clk, baud_clk);
  // Sys clock of 667MHz and baud rate of 115200 is roughly equal to a counter of 2^20 with an increment of 181
  input sys_clk;
  output baud_clk;
  reg[20:0] counter;
  parameter INCREMENT = 181;

  initial counter = 0;

  always @(posedge sys_clk) counter <= counter[19:0] + INCREMENT;

  assign baud_clk = counter[20];
endmodule

module baud_div_8(baud_clk, tx_clk);
  input baud_clk;
  output tx_clk;

  reg [2:0] counter;

  initial counter = 3'b000;

  always @(posedge baud_clk) counter <= counter + 1;
  
  assign tx_clk = counter[2];
endmodule

module uart_tx(clk, data, tx_out, rst, start, ready, state, data_bit); //8-N-1
  input clk;
  input [7:0] data; // byte to be transmitted
  input start; // 1 when we want to capture and transmit input data
  input rst;
  output reg tx_out; // transmission line
  output reg ready; // ready for new data

  output reg [1:0] state; // three stages of transmission + idle state
  output reg [2:0] data_bit; // which bit of data are we transmitting right now?
  reg [7:0] data_captured; // capture data at start of transmission sequence
  wire tx_clk;

  baud_generator baud_gen (.sys_clk(clk), .baud_clk(baud_clk));
  baud_div_8 clock_gen (.baud_clk(baud_clk), .tx_clk(tx_clk)); // generates a div8 clock

  parameter IDLE = 2'b00; // no transmission
  parameter START = 2'b01; // start bit
  parameter DATA = 2'b10; // data
  parameter STOP = 2'b11; // end bit

  // initialize
  initial state = IDLE;
  initial data_bit = 0;

  always @(posedge tx_clk) begin
    if (rst) state <= IDLE;
    else begin
      case (state)
        IDLE: state <= start ? START : IDLE;
        START: begin
          state <= DATA;
          data_bit = 3'b000;
          data_captured <= data;
        end
        DATA: begin
          if (data_bit == 7) state <= STOP;
          else begin
            state <= DATA;
            data_bit <= data_bit + 1;
          end
        end
        STOP: state <= start ? START : IDLE;
      endcase
    end
  end

  always @(*) begin
    case (state)
      IDLE: begin
        tx_out = 1;
        ready = 1;
      end
      START: begin
        tx_out = 0;
        ready = 0;
      end
      DATA: begin
        tx_out = data_captured[data_bit];
        ready = 0;
      end
      STOP: begin
        tx_out = 1;
        ready = 1;
      end
    endcase
  end
endmodule

