FROM ubuntu:16.04

RUN apt-get update && apt-get install -y sudo wget curl git cmake \
    libreadline-dev libprotobuf-dev protobuf-compiler

RUN groupadd -g 1000 user && \
    useradd -u 1000 -g 1000 -m -s /bin/bash user && \
    echo 'user:changeme' | chpasswd && \
    echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

USER user
ENV HOME /home/user
WORKDIR /home/user

RUN curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps -o install-deps && \
    sed -i 's/libqt4-core //; s/libqt4-gui //; s/libqt4-dev //' install-deps && \
    bash ./install-deps && rm install-deps && \
    git clone https://github.com/torch/distro.git ~/torch --recursive --depth 1 && \
    cd ~/torch && ./install.sh && cd ~ && . ~/torch/install/bin/torch-activate && \
    luarocks install loadcaffe && \
    git clone https://github.com/jcjohnson/neural-style.git --depth 1 && \
    cd ~/neural-style && sh models/download_models.sh

CMD /bin/bash
