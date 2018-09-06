#include <iostream>
#include <uuid/uuid.h>
#include <opae/fpga.h>
#include <unistd.h>

#define ADDR_BUF_SIZE 0x0200
#define ADDR_BUF_INCR 0x0208
#define ADDR_SYNC 0x0300

#define AFU_UUID "C000C966-0D82-4272-9AEF-FE5F84570612"

#include "opae_svc_wrapper.h"

int main() {

  OPAE_SVC_WRAPPER* fpga = new OPAE_SVC_WRAPPER(AFU_UUID);

  fpga->mmioWrite64(ADDR_BUF_SIZE, 100);

  for (int i = 0; i < 100; i++) {
    fpga->mmioWrite64(ADDR_BUF_INCR, 0);

    std::cout << "incr = " << i << std::endl;
  }

  uint64_t status = 0;

  while (0 == status) {
    status = fpga->mmioRead64(ADDR_SYNC);

    std::cout << "status = " << status << std::endl;
  }

  delete fpga;

  return 0;
}

