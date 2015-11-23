FROM thewtex/opengl:latest
MAINTAINER Insight Software Consortium <community@itk.org>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  cmake \
  libX11-dev \
  libgl1-mesa-dev \
  libglu1-mesa-dev \
  libfreetype6-dev \
  libxt-dev \
  subversion \
  x11proto-core-dev \
  x11proto-gl-dev \
  x11proto-damage-dev \
  x11proto-dri2-dev \
  x11proto-fixes-dev \
  x11proto-input-dev \
  x11proto-kb-dev \
  x11proto-render-dev

USER user
WORKDIR /home/user
RUN mkdir -p src && cd src && \
  git clone http://itk.org/ITKApps.git && \
  cd ITKApps && \
  git checkout 2754058c006ec168868d5232df1a0f113470d182

RUN mkdir -p bin/ITKApps && cd bin/ITKApps && \
  cmake \
    -DCMAKE_BUILD_TYPE:STRING=MinSizeRel \
      ~/src/ITKApps/Superbuild && \
  make -j$(nproc) && \
  cd ITKApps-build && ctest && cd .. && \
  find . -name '*.o' -delete
