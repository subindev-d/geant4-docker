FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV G4_VERSION=11.3.0

#install prerequisites
RUN apt-get update && apt-get install -y  build-essential \
                    cmake \
                    libexpat1-dev \
                    libxerces-c-dev \ 
                    libcurl4-openssl-dev \ 
                    qtbase5-dev libqt5opengl5-dev \
                    libvtk9-dev libvtk9-qt-dev libx11-dev libxmu-dev libmotif-dev \
                    mesa-common-dev libmotif-dev \
                    wget

#Get geant4
RUN mkdir -p /geant4/source; \
            cd /geant4/source; \
            wget "https://gitlab.cern.ch/geant4/geant4/-/archive/v11.3.0/geant4-v11.3.0.tar.gz"; \
            tar -xzf geant4-v11.3.0.tar.gz;

#Install Geant4
RUN mkdir -p /geant4/build; \
    cd /geant4/build; \
    cmake -DCMAKE_INSTALL_PREFIX=/geant4/install /geant4/source/geant4-v11.3.0 \
    -DGEANT4_USE_QT=ON -DGEANT4_USE_XM=ON -DGEANT4_USE_OPENGL_X11=ON \
    -DGEANT4_USE_RAYTRACER_X11=ON -DGEANT4_INSTALL_DATA=ON \
    -DGEANT4_USE_GDML=ON 

RUN cd /geant4/build; \
    make -j$(nproc)
    
RUN cd /geant4/build; \
    make install

RUN echo "source /geant4/install/bin/geant4.sh" >> ~/.bashrc

# Define the command to run within the container
CMD ["/bin/bash"]


