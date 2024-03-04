//
//  Program in which processes pass their rank to the next process
//

#include <mpi.h>
#include <iostream>


int main(int argc, char* argv[]){
    int rank, size, msg, src, count;
    int tag,dest;
    tag = 0;
    count = 1;

    MPI_Comm comm;
    MPI_Status status;

    comm = MPI_COMM_WORLD;

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(comm, &rank);
    MPI_Comm_size(comm, &size);

    if (rank == 0){
        printf("World size = %d\n",size );
    }
    msg = rank;
    
    dest = (rank +1) % size;
    src = (rank -1 + size)%size;
    // Debugging:
    //printf("rank:  %d-- src: %d-- dest: %d\n",rank, src, dest); 
    MPI_Send(&msg, count, MPI_INT, dest, tag, comm);
    MPI_Recv(&msg,count, MPI_INT, src, tag, comm, &status );

    if (msg == (rank -1 +size)%size){
        printf("Success: msg on rank %d is %d\n", rank, msg);
    }else{
        printf("Failure: msg on rank %d is %d\n", rank, msg);
    }
    MPI_Finalize();
}