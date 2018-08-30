// template.sv

import internal_pkg::*;

module template
(
  input logic clk,
  input logic reset,

  input t_if_internal pkt_in,

  output logic sync
);

  logic [63:0] data;

  always_ff@(posedge clk or posedge reset) begin
    if (reset) begin
      data <= '0;
    end
    else if (pkt_in.valid) begin
      $display("%t data = %d | addr = %d", $time, pkt_in.data, pkt_in.addr);

      data <= pkt_in.data;
    end
  end

  initial begin
    sync <= '1;
  end

endmodule : template

// taf!
