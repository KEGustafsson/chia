FROM ubuntu:20.04

RUN apt-get update
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3.8-venv python3.8-distutils python3-pip git nano build-essential lsb-core sudo libatk-bridge2.0-0 libgtk2.0-0 libgtk-3-0 libgbm1 libasound2

RUN useradd -mrs /bin/bash -u 1000 chia && \
    echo "chia ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/chia && \
    chmod 0440 /etc/sudoers.d/chia && \
    usermod -aG sudo chia

USER chia
WORKDIR /home/chia/

RUN git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules \
&& cd chia-blockchain \
&& chmod +x install.sh \
&& /usr/bin/sh ./install.sh

WORKDIR /home/chia/chia-blockchain

RUN . ./activate \
&& chia init
RUN chmod +x install-gui.sh \
&& /usr/bin/sh ./install-gui.sh

ADD ./entrypoint.sh entrypoint.sh

CMD ["bash"]
