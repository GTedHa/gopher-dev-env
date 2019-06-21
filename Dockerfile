FROM ubuntu:trusty
MAINTAINER G.Ted <gtha@yujinrobot.com>

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-get install build-essential -y
RUN apt-get install python2.7 -y
RUN apt-get install python-pip -y
RUN apt-get install git -y

### install ROS

# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release

# setup keys
# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO indigo
RUN apt-get update && apt-get install -y \
    ros-indigo-ros-core=1.1.6-0*
RUN apt-get update && apt-get install -y \
    ros-indigo-ros-base=1.1.6-0*

### install yujin_tools

RUN git clone https://github.com/yujinrobot/yujin_tools.git /opt/yujin_tools
RUN cd /opt/yujin_tools && python2.7 setup.py install

RUN mkdir -p /opt/yujin/amd64/indigo-devel
RUN mkdir -p /opt/yujin/amd64/indigo-stable
RUN mkdir -p /opt/yujin/amd64/indigo-continental

VOLUME ["/opt/groot"]

WORKDIR /opt/groot

CMD ["/bin/bash"]
