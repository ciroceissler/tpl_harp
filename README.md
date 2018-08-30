# tpl_harp: template Intel HARP

- install Mentor Graphics ModelSim 10.5c
- install opae-sdk
- install intel-fpga-bbb MPF
- configure scripts/setup.env

## terminal 1

```
$ source scripts/setup.env
$ cd ase/
$ make
$ make sim
```

## terminal 2

```
$ source scripts/setup.env
$ cd sw/
$ mkdir build/
$ cd build/
$ cmake ..
$ make
$ ./template
```

