A basic Verilog module implementing a UART transmitter at 9600 baud, based on a clock speed of 667 MHz (the default speed of Krtkl's [Snickerdoodle](http://krtkl.com/), my current primary dev board). 

**uart_tx.v** contains 3 modules: the baud generator, a simple module that divides it by 8 to simplify the transmitter FSM, and the transmitter itself.

**num_gen.v** is a test-bench module that increments and feeds 8-bit numbers to the TX module. *ready*, *start*, and *rst* should be wired to the same ports on **uart_tx** in testing.

This has not yet been tested on the Snickerdoodle, but has been simulated in Vivado's native behavioral simulator and found to work quite well. To implement it on the Snickerdoodle, I exported both modules as custom IP blocks and wired them to the ZYNQ7 block in the IP design view.