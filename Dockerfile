FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common && \
    add-apt-repository -y universe && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        qtbase5-dev \
        qttools5-dev \
        qttools5-dev-tools \
        libqt5svg5-dev \
        libqt5x11extras5-dev \
        libqt5opengl5-dev \
        libglu1-mesa-dev \
        freeglut3-dev \
        libgl1-mesa-dev \
        libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# https://github.com/niftools/nifskope.git /opt/nifskope
RUN git clone --recursive https://github.com/trentapple/nifskope.git /opt/nifskope && \
    cd /opt/nifskope && \
    git fetch --tags && \
    git checkout tags/v2.0.dev7 -b v2.0.dev7

# Patches
RUN sed -i '/^QT \+=/s/$/ widgets/' /opt/nifskope/NifSkope.pro
RUN sed -i '1i #include <QAction>' /opt/nifskope/src/ui/widgets/lightingwidget.cpp

WORKDIR /opt/nifskope
RUN qmake && \
    make -j$(nproc) && \
    make install

CMD ["/opt/nifskope/release/NifSkope"]
