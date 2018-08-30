# tpl_harp: template Intel HARP

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

