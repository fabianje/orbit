FROM nvidia/cuda:12.3.1-runtime-ubuntu20.04

# Nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
LABEL maintainer="Fabian Jenelten" mail="fabianje@ethz.ch"
SHELL ["/bin/bash", "--login", "-c"]

# To avoid tzdata asking for geographic location.
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_frontend noninteractive

# Conda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

# Clear cuda list and install tools.
RUN rm /etc/apt/sources.list.d/cuda.list \
&& apt-get -y update \
&& apt-get install -y apt-utils git ninja-build python3-pip libtbb-dev lsb-release gnupg2 ca-certificates curl wget

# Required for legged gym
# RUN pip3 install --no-cache-dir torch==1.12.0 torchvision==0.13.0 torchaudio==0.12.0 --extra-index-url https://download.pytorch.org/whl/cu116

# Install miniconda
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

# Copy Isaac Sim
COPY ./isaac.tar /home
RUN cd /home && tar -xf isaac.tar && rm -rf isaac.tar

# Copy git
COPY ./git.tar /home
RUN cd /home && tar -xf git.tar && rm -rf git.tar

# Installation
RUN cd /home/git/orbit \
&& rm -rf _isaac_sim \ 
&& cp -r /home/isaac_sim-2023.1.1 /home/git/orbit/_isaac_sim

# Isaac Sim root directory and Sim python executable
RUN export ISAACSIM_PATH="/home/git/orbit/_isaac_sim"
RUN export ISAACSIM_PYTHON_EXE="${ISAACSIM_PATH}/python.sh"

# Conda environment
RUN ./home/git/orbit/orbit.sh --conda
SHELL ["conda", "run", "-n", "orbit", "/bin/bash", "-c"]


RUN ./home/git/orbit/orbit.sh --install
RUN pip3 install -e /home/git/rsl_rl

RUN pip3 list

# Cleanup
RUN cd /home && rm -rf git/*  && rm -rf isaac_sim-2023.1.1

# Activate orbit when starting the container
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "orbit"]



