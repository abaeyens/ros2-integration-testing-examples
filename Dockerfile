FROM ros:jazzy-ros-base
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu


# Additional packages
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ros-dev-tools \
    ros-jazzy-turtlesim \
    ros-jazzy-ros-testing \
    && rm -rf /var/lib/apt/lists/*

# Install xUnit viewer
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nodejs npm \
    && rm -rf /var/lib/apt/lists/* \
    && npm i -g xunit-viewer


# Create a non-root user
ARG USER
ARG USER_ID
ARG GROUP_ID
RUN groupadd --gid $GROUP_ID $USER && \
    useradd --uid $USER_ID --gid $GROUP_ID --create-home --shell /bin/bash $USER

# Set up .bashrc
RUN \
    # Add terminal coloring for the new user
    echo 'PS1="(container) ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/$USER/.bashrc && \
    # Disable "EasyInstallDeprecationWarning: easy_install command is deprecated"
    echo 'PYTHONWARNINGS="ignore:easy_install command is deprecated,ignore:setup.py install is deprecated"' >> /home/$USER/.bashrc  && \
    echo 'export PYTHONWARNINGS' >> /home/$USER/.bashrc && \
    # Source ROS 2 setup
    echo "source /opt/ros/jazzy/setup.bash" >> /home/$USER/.bashrc && \
    echo "source install/setup.bash" >> /home/$USER/.bashrc

# Switch to the non-root user
USER $USER

# Set entry point
CMD ["/bin/bash"]
