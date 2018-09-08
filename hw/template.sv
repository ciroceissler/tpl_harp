// template.sv

import internal_pkg::*;

module template
(
  input logic clk,
  input logic reset,

  input t_if_internal pkt_in,

  output logic sync
);

  logic [63:0] counter;

  always_ff@(posedge clk) begin
    if (reset) begin
      counter <= '1;
    end
    else if (pkt_in.valid) begin
      if (pkt_in.addr == 128) begin
        counter <= pkt_in.data;
      end
      else if (pkt_in.addr == 130) begin
        counter <= counter - 1;
      end
    end
  end

  always_ff@(posedge clk) begin
    if (reset) begin
      sync <= 1'b0;
    end
    else begin
      sync <= (0 == counter) ? 1'b1 : 1'b0;
    end
  end

  initial begin
  end

endmodule : template

// taf!
