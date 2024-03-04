## Dockerfile that builds MPICH to run MPI parallel programs
## Can build with OSU benchmarks ( uncomment section if desired ) for profiling HPC systems
## Add a simple MPI script and compile


FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install the necessary packages (from repo)
RUN apt-get update && apt-get install -y --no-install-recommends \
 apt-utils \
 build-essential \
 curl \
 libcurl4-openssl-dev \
 libzmq3-dev \
 pkg-config \
 software-properties-common
RUN apt-get clean
RUN apt-get install -y dkms
RUN apt-get install -y autoconf automake build-essential numactl libnuma-dev autoconf automake gcc g++ git libtool

# Download and build an ABI compatible MPICH
RUN curl -sSLO http://www.mpich.org/static/downloads/3.4.2/mpich-3.4.2.tar.gz \
   && tar -xzf mpich-3.4.2.tar.gz -C /root \
   && cd /root/mpich-3.4.2 \
   && ./configure --prefix=/usr --with-device=ch4:ofi --disable-fortran \
   && make -j8 install \
   && rm -rf /root/mpich-3.4.2 \
   && rm /mpich-3.4.2.tar.gz

# # OSU benchmarks
# RUN curl -sSLO http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.4.1.tar.gz \
#    && tar -xzf osu-micro-benchmarks-5.4.1.tar.gz -C /root \
#    && cd /root/osu-micro-benchmarks-5.4.1 \
#    && ./configure --prefix=/usr/local CC=/usr/bin/mpicc CXX=/usr/bin/mpicxx \
#    && cd mpi \
#    && make -j8 install \
#    && rm -rf /root/osu-micro-benchmarks-5.4.1 \
#    && rm /osu-micro-benchmarks-5.4.1.tar.gz

# # Add the OSU benchmark executables to the PATH
# ENV PATH=/usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt:$PATH
# ENV PATH=/usr/local/libexec/osu-micro-benchmarks/mpi/collective:$PATH

# path to mlx libraries in Ubuntu
ENV LD_LIBRARY_PATH=/usr/lib/libibverbs:$LD_LIBRARY_PATH


# copy my mpi file into the Docker image
COPY msgTest.cc /root/msgTest.cc

# swith to directory where msgTest.cc is
WORKDIR /root

# compile program
RUN mpicxx -o msgTest msgTest.cc

# set entrypoint to container to run myTest
ENTRYPOINT [ "mpirun", "-np", "4", "./msgTest" ]

