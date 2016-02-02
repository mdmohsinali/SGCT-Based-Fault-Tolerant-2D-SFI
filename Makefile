
.SUFFIXES:
.PRECIOUS: %.o

# include CPP object files in CPP_OBJS variable, and set some 
# switches (TAU_PROFILE, NON_FT)
include cpp_objs_switches.mk

HDRS=Advect3D.h HaloArray3D.h ProcGrid3D.h Vec3D.h GridCombine3D.h \
	LinGrid3D.h Timer.h
OBJS=Advect3D.o Advect2D.o GridCombine3D.o
PROG=ex5f90
CCFLAGS=-O3 -fopenmp -std=gnu++0x

# MPI CPP compiler
ifndef MPICPP
  MPICPP := $(shell which mpic++)
endif

# MPI Fortran compiler
ifndef MPIFORTRAN
  MPIFORTRAN := $(shell which mpif90)
endif

# flags related to non-ft mpi
ifeq ($(NON_FT),yes)
  CPPFLAGS += -DNON_FT
  FFLAGS += -DNON_FT
endif

# CPP flags
CPPFLAGS += -I$(CPP_INCLUDE_DIR) -O3 -fopenmp -std=gnu++0x

# CPP link libs
CPP_LINK_LIBS = -L$(PETSC_DIR)/lib -lglpk -lmpi_cxx -lstdc++ -lgomp

CPP_INCLUDE_DIR = ${PETSC_DIR}/include

FORTRAN_OBJS = AppWrap.o \
	       AppWrapPassField.o

all: FORTRAN CPP LINK

FORTRAN:
	$(MPIFORTRAN) $(FFLAGS) -c  -fPIC -Wall -Wno-unused-variable -ffree-line-length-0 -Wno-unused-dummy-argument -g -O0   -I$(CPP_INCLUDE_DIR) -I$(CPP_INCLUDE_DIR)/openmpi/opal/mca/hwloc/hwloc132/hwloc/include -I$(CPP_INCLUDE_DIR)/openmpi/opal/mca/event/libevent2013/libevent -I$(CPP_INCLUDE_DIR)/openmpi/opal/mca/event/libevent2013/libevent/include -I$(CPP_INCLUDE_DIR)/openmpi    -o AppWrap.o AppWrap.F90
	
	$(MPIFORTRAN) $(FFLAGS) -c  -fPIC -Wall -Wno-unused-variable -ffree-line-length-0 -Wno-unused-dummy-argument -g -O0   -I$(CPP_INCLUDE_DIR) -I$(CPP_INCLUDE_DIR)/openmpi/opal/mca/hwloc/hwloc132/hwloc/include -I$(CPP_INCLUDE_DIR)/openmpi/opal/mca/event/libevent2013/libevent -I$(CPP_INCLUDE_DIR)/openmpi/opal/mca/event/libevent2013/libevent/include -I$(CPP_INCLUDE_DIR)/openmpi    -o AppWrapPassField.o AppWrapPassField.F90

CPP: $(CPP_OBJS)

%.o: %.cpp $(HDRS)
	$(MPICPP) $(CPPFLAGS) -c $*.cpp	

LINK:
	$(MPIFORTRAN) -fPIC -Wall -Wno-unused-variable -ffree-line-length-0 -Wno-unused-dummy-argument -g -O0   -o app_raijin_cluster $(FORTRAN_OBJS)  $(CPP_OBJS) -Wl,-rpath,/home/mohsin/lib -L/home/mohsin/lib  -lpetsc -Wl,-rpath,/home/mohsin/lib -L/home/mohsin/lib -lflapack -lfblas -lssl -lcrypto -lX11 -lpthread -lhwloc -Wl,-rpath,/usr/lib/gcc/i686-linux-gnu/4.6 -L/usr/lib/gcc/i686-linux-gnu/4.6 -Wl,-rpath,/usr/lib/i386-linux-gnu -L/usr/lib/i386-linux-gnu -Wl,-rpath,/lib/i386-linux-gnu -L/lib/i386-linux-gnu -lmpi_f90 -lmpi_f77 -lgfortran -lm -lgfortran -lm -lgfortran -lm -lgfortran -lm -lquadmath -lm -lmpi_cxx -lstdc++ -Wl,-rpath,/home/mohsin/lib -L/home/mohsin/lib -Wl,-rpath,/usr/lib/gcc/i686-linux-gnu/4.6 -L/usr/lib/gcc/i686-linux-gnu/4.6 -Wl,-rpath,/usr/lib/i386-linux-gnu -L/usr/lib/i386-linux-gnu -Wl,-rpath,/lib/i386-linux-gnu -L/lib/i386-linux-gnu -Wl,-rpath,/usr/lib/i386-linux-gnu -L/usr/lib/i386-linux-gnu -ldl -lmpi -lrt -lnsl -lutil -lgcc_s -lpthread -ldl $(CPP_LINK_LIBS)

clean:
	rm -f *.o $(PROG)
run2d:
	./run3dAdvectRaijin -v 0 -2 -p 8 -q 4 -r 2 -l 5 11 11 0

include ${PETSC_DIR}/conf/test
