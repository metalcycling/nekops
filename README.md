# NekOps: Nek5000 everywhere

[Nek5000](https://nek5000.mcs.anl.gov/) is a highly scalable spectral element computational fluid dynamics code for solving the incompressible Navier-Stokes equations in 2 and 3 dimensions ([Wikipedia](https://en.wikipedia.org/wiki/Nek5000)). This repository provides an easy-to-use bash utility that builds a `docker` image to expose all the capabilities of Nek5000 without having to worry about installing all the dependencies needed to run the code. A `Dockerfile` is provided that can be used to build the `NekOps` image to be used for the simulations.

## Running the code

The easiest way to use this repository is through the utility `nekops`. The utility takes care of building the image and can be used to run the simulations directly without having to explicitely call `docker` commands.

```
$ ./nekops -h
USAGE: ./nekops [-n simulation_name] [-d simulation_directory] [-p number_of_processors]
```

A set of examples is given here that can be run easily and output visualization files that can be opened with [VisIt](https://visit-dav.github.io/visit-website/) or [Paraview](https://www.paraview.org/). For example, to run the `eddy_uv` case with a single processor run the following command:

```
$ ./nekops -n eddy_uv -d ./examples/eddy_uv
...
mpif77  -O2 -cpp -fdefault-real-8 -fdefault-double-8 -std=legacy  -DMPI -DUNDERSCORE -DGLOBAL_LONG_LONG -DTIMER -I/simulation -I/programs/Nek5000-19.0/core -I./ -I /programs/Nek5000-19.0/core/experimental  -c /simulation/eddy_uv.f
building libnek5000.a ... ar: `u' modifier ignored since `D' is the default (see `U')
done
mpif77  -O2 -cpp -fdefault-real-8 -fdefault-double-8 -std=legacy  -DMPI -DUNDERSCORE -DGLOBAL_LONG_LONG -DTIMER -I/simulation -I/programs/Nek5000-19.0/core -I./ -I /programs/Nek5000-19.0/core/experimental -o nek5000 /programs/Nek5000-19.0/core/drive.f /simulation/eddy_uv.o libnek5000.a -L/programs/Nek5000-19.0/3rd_party/blasLapack -lblasLapack -L/programs/Nek5000-19.0/3rd_party/gslib/lib -lgs -Wl,--allow-multiple-definition


#############################################################
#                  Compilation successful!                  #
#############################################################
   text	   data	    bss	    dec	    hex	filename
1660407	  17544	155024736	156702687	95717df	nek5000

/----------------------------------------------------------\\
|      _   __ ______ __ __  ______  ____   ____   ____     |
|     / | / // ____// //_/ / ____/ / __ \\/ __ \\/ __ \\   |
|    /  |/ // __/  / ,<   /___ \\ / / / // / / // / / /    |
|   / /|  // /___ / /| | ____/ / / /_/ // /_/ // /_/ /     |
|  /_/ |_//_____//_/ |_|/_____/  \\___/ \\___/ \\___/      |
|                                                          |
|----------------------------------------------------------|
|                                                          |
| COPYRIGHT (c) 2008-2019 UCHICAGO ARGONNE, LLC            |
| Version:  19.0                                           |
| Web:      https://nek5000.mcs.anl.gov                    |
|                                                          |
\\----------------------------------------------------------/

 Number of MPI ranks :           1

...

run successful: dying ...
  
  
total elapsed time             :   1.66177E+01 sec
total solver time w/o IO       :   1.65353E+01 sec
time/timestep                  :   1.65353E-02 sec
avg throughput per timestep    :   7.58621E+05 gridpts/CPUs
total max memory usage         :   1.12755E-01 GB

 Found 11 field file(s)
 Generating metadata file eddy_uv.nek5000 ...

 Now run visit -o eddy_uv.nek5000 or paraview --data=eddy_uv.nek5000
```

By default, the code runs with a single rank. It is also possible to run the code with multiple ranks to speedup the execution like this:

```
$ ./nekops -n eddy_uv -d ./examples/eddy_uv -p 8
...
total elapsed time             :   3.51062E+00 sec
total solver time w/o IO       :   3.44853E+00 sec
time/timestep                  :   3.44853E-03 sec
avg throughput per timestep    :   4.54686E+05 gridpts/CPUs
total max memory usage         :   9.04622E-01 GB

 Found 11 field file(s)
 Generating metadata file eddy_uv.nek5000 ...

 Now run visit -o eddy_uv.nek5000 or paraview --data=eddy_uv.nek5000
```

Notice that the `total elapsed time` went from 16.6 seconds to 3.51 seconds when using 8 ranks. The `pipe` example can be run using the same utility, and more examples can be found in the [NekExamples](https://github.com/Nek5000/NekExamples) repository demonstrating more physics simulations using Nek5000.
