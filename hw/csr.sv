// csr.sv

import ccip_if_pkg::*;
import internal_pkg::*;

module csr
(
  input  logic          clk,
  input  logic          reset,
  input  logic          sync,
  output t_if_internal  pkt_out,
  cci_mpf_if.to_fiu     fiu,
  cci_mpf_if.to_afu     afu
);

  // register map to HardCloud
  localparam DEVICE_HEADER = 16'h000; // 64b - RO  Constant: 0x1000010000000000.
  localparam AFU_ID_LOW    = 16'h008; // 64b - RO  Constant: 0xC000C9660D824272.
  localparam AFU_ID_HIGH   = 16'h010; // 64b - RO  Constant: 0x9AEFFE5F84570612.
  localparam ADDR_SYNC     = 16'h300;

  t_if_ccip_c0_Rx rx_mmio_channel;
  t_if_ccip_c2_Tx tx_mmio_channel;

  t_ccip_c0_ReqMmioHdr mmio_req_hdr;

  logic is_csr_read;

  logic [63:0] data_sync;

  logic [127:0] afu_id = 128'hC000C966_0D82_4272_9AEF_FE5F84570612;

  assign afu.reset = fiu.reset;

  assign fiu.c0Tx = afu.c0Tx;
  assign afu.c0TxAlmFull = fiu.c0TxAlmFull;
  assign fiu.c1Tx = afu.c1Tx;
  assign afu.c1TxAlmFull = fiu.c1TxAlmFull;

  assign afu.c0Rx = fiu.c0Rx;
  assign afu.c1Rx = fiu.c1Rx;

  assign is_csr_read = rx_mmio_channel.mmioRdValid & (mmio_req_hdr.address < 'h400);

  assign mmio_req_hdr = t_ccip_c0_ReqMmioHdr'(rx_mmio_channel.hdr);

  // Register incoming messages
  always_ff @(posedge clk)
  begin
      rx_mmio_channel <= fiu.c0Rx;
  end

  // CSR reads
  always_ff @(posedge clk) begin
      fiu.c2Tx <= afu.c2Tx;

      if (tx_mmio_channel.mmioRdValid) begin
          fiu.c2Tx <= tx_mmio_channel;
      end
  end

  //
  // Implement the device feature list by responding to MMIO reads.
  //

  always_ff @(posedge clk) begin
    if (reset) begin
      tx_mmio_channel.mmioRdValid <= 1'b0;
    end
    else begin
      tx_mmio_channel.mmioRdValid <= is_csr_read;
      tx_mmio_channel.hdr.tid     <= mmio_req_hdr.tid;

      case (mmio_req_hdr.address)
        // AFU DFH (device feature header)
        DEVICE_HEADER: tx_mmio_channel.data <= 'h1000000010000000;

        // AFU_ID_L
        (AFU_ID_LOW >> 2): tx_mmio_channel.data <= afu_id[63:0];

        // AFU_ID_H
        (AFU_ID_HIGH >> 2): tx_mmio_channel.data <= afu_id[127:64];

        // DFH_RSVD0
        6: tx_mmio_channel.data <= t_ccip_mmioData'(0);

        // DFH_RSVD1
        8: tx_mmio_channel.data <= t_ccip_mmioData'(0);

        (ADDR_SYNC >> 2): tx_mmio_channel.data <= data_sync;

        default: tx_mmio_channel.data <= t_ccip_mmioData'('0);
      endcase
    end
  end

  //
  // transfer to template.sv
  //

  always_ff@(posedge clk) begin
    if (reset) begin
      pkt_out   <= '0;
      data_sync <= '0;
    end
    else begin
      pkt_out.valid <= '0;

      if (rx_mmio_channel.mmioWrValid) begin
        t_ccip_c0_ReqMmioHdr mmio_req_hdr;

        mmio_req_hdr = t_ccip_c0_ReqMmioHdr'(rx_mmio_channel.hdr);

        pkt_out.data  <= rx_mmio_channel.data;
        pkt_out.addr  <= mmio_req_hdr.address;
        pkt_out.valid <= 1'b1;
      end

      data_sync <= sync;
    end
  end

endmodule : csr

