#
# MPI image with custom tools
#

# Base image
FROM ubuntu

# Install Ubuntu tools
RUN apt update && apt upgrade -y && apt install -y \
    build-essential libopenmpi-dev vim wget

# Download and build Nek5000's tools
RUN mkdir -p /programs
RUN wget -qO- https://github.com/Nek5000/Nek5000/archive/refs/tags/v19.0.tar.gz | tar xvz -C /programs
WORKDIR /programs/Nek5000-19.0/tools
RUN ./maketools genmap gencon genbox reatore2
ENV PATH="/programs/Nek5000-19.0/bin:$PATH"
ENV NEK_SOURCE_ROOT="/programs/Nek5000-19.0"
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

# Build 3rd party tools
WORKDIR /programs/Nek5000-19.0/bin
RUN ./nekconfig -build-dep

# Create simulation directory to be use as mount
RUN mkdir -p /simulation
WORKDIR /simulation
