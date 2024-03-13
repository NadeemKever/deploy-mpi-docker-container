# deploy-mpi-docker-container
Uploads a docker container image to AWS ECR.

This repository automates the process of deploying a Docker container image to Amazon's Elastic Container Registry (ECR). The included Dockerfile builds MPICH—implementing the Message Passing Interface (MPI) standard for high-performance computing—and compiles the `msgTest.cc` MPI program using `mpicxx`. When run, the container by default executes the MPI program with `mpirun -np 4 ./msgTest`, showcasing parallel computing capabilities.

The workflow, utilizing GitHub Actions, automates the steps required to package the application in a Docker image and upload it to AWS ECR, ensuring that the latest version of the application is readily available for deployment or further development testing.
