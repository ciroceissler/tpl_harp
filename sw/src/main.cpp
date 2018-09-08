#include <iostream>
#include <uuid/uuid.h>
#include <opae/fpga.h>
#include <unistd.h>
#include <chrono>

#define ADDR_BUF_SIZE 0x0200
#define ADDR_BUF_INCR 0x0208
#define ADDR_SYNC 0x0300

#define AFU_UUID "C000C966-0D82-4272-9AEF-FE5F84570612"

#include "opae_svc_wrapper.h"

int main(int argc, char* argv[]) {

  OPAE_SVC_WRAPPER* fpga = new OPAE_SVC_WRAPPER(AFU_UUID);

  for (int j = 0; j < 100; j++) {
    uint64_t status = 1;
    uint64_t num_transaction = atoi(argv[1]);

    fpga->mmioWrite64(ADDR_BUF_SIZE, num_transaction);

    while (1 == status) {
      status = fpga->mmioRead64(ADDR_SYNC);
    }

    auto start = std::chrono::high_resolution_clock::now();

    for (int i = 0; i < num_transaction; i++) {
      fpga->mmioWrite64(ADDR_BUF_INCR, 0);
    }

    while (0 == status) {
      status = fpga->mmioRead64(ADDR_SYNC);
    }

    auto finish = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double> elapsed = finish - start;

    std::cout << "Time: " << elapsed.count() << " s\n";
  }

  delete fpga;

  return 0;
}

