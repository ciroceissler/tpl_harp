// internal_pkg.sv

package internal_pkg;
  import ccip_if_pkg::*;

  typedef struct packed {
    t_ccip_mmioData data;
    t_ccip_mmioAddr addr;
    logic           valid;
  } t_if_internal;

endpackage : internal_pkg
