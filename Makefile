
CFLAGS = -w -O3 -qopenmp -DARCH="Linux" -DMATRIXSTORAGE -DUSE_MT=1 -DARPACK -DPARDISO_MPI  -mkl=parallel -DMKL_ILP64 -DLONGLONG
FFLAGS = -w -O3 -qopenmp -mkl=parallel -i8

CC=mpiicc
FC=mpiifort

.c.o :
	$(CC) $(CFLAGS) -c $<
.f.o :
	$(FC) $(FFLAGS) -c $<

include Makefile.inc

SCCXMAIN = ccx_2.16.c

OCCXF = $(SCCXF:.f=.o)
OCCXC = $(SCCXC:.c=.o)
OCCXMAIN = $(SCCXMAIN:.c=.o)

#DIR=/home/export/online1/systest/swrh/dzj/calculix2/spooles

LIBS = -lpthread -lm /home/export/online1/amd_app/dzj/calculix/ARPACK/libarpack_INTEL.a

ccx_2.16: $(OCCXMAIN) ccx_2.16.a  $(LIBS)
	./date.pl; $(CC) $(CFLAGS) -c ccx_2.16.c; $(FC) $(FFLAGS) -nofor-main -o $@ $(OCCXMAIN) ccx_2.16.a $(LIBS) -lmkl_blacs_intelmpi_ilp64 -lpthread -lm -ldl

ccx_2.16.a: $(OCCXF) $(OCCXC)
	ar vr $@ $?
