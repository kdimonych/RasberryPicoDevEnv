# syntax=docker/dockerfile:1
FROM debian:stable

USER root
WORKDIR /root

# Install needed packages. Use a separate RUN statement to add your own dependencies.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install bash wget \
    && apt-get -y install --no-install-recommends openssh-client build-essential cmake cppcheck valgrind clang lldb llvm gdb git meson sudo \
    build-essential python3 mono-complete tar gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib g++ \
    libusb-1.0-0-dev binutils-multiarch gdb-multiarch \
    && sudo ln -s /usr/bin/objdump /usr/bin/objdump-multiarch \
    && sudo ln -s /usr/bin/nm /usr/bin/nm-multiarch \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

# Create developer user
ARG USER_NAME=developer
ARG USER_WORKDIR_PATH=/home/${USER_NAME}

RUN useradd -m ${USER_NAME} -d ${USER_WORKDIR_PATH} \
    && usermod -aG sudo ${USER_NAME} \
    && getent group sudo \
    && su - ${USER_NAME} \
    && passwd -d ${USER_NAME}

USER ${USER_NAME}
WORKDIR ${USER_WORKDIR_PATH}

# # Install Dev environment
# RUN sudo apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && sudo apt-get -y install --no-install-recommends build-essential python3 mono-complete tar\
#     gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib g++ \
#     && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo rm -rf /var/lib/apt/lists/*

# Setup ssh config for GitHub
COPY --chown=${USER_NAME}:sudo --chmod=600 ./SshKeys/DevContainer ${USER_WORKDIR_PATH}/.ssh/DevContainer
COPY --chown=${USER_NAME}:sudo --chmod=600 ./SshKeys/config ${USER_WORKDIR_PATH}/.ssh/config
RUN eval "$(ssh-agent -s)" \
    && ssh-add ${USER_WORKDIR_PATH}/.ssh/DevContainer \
    && ssh-keyscan -t ssh-ed25519 -H github.com >> ${USER_WORKDIR_PATH}/.ssh/known_hosts

# Start install script
COPY --chown=${USER_NAME}:sudo --chmod=777 ./install.sh ${USER_WORKDIR_PATH}/install.sh 
RUN ${USER_WORKDIR_PATH}/install.sh > install.log 2>&1 \
    && rm -f ${USER_WORKDIR_PATH}/install.sh

EXPOSE 3333
