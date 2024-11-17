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
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID --create-home --shell /bin/bash $USERNAME

# Set up .bashrc
RUN \
    # Add terminal coloring for the new user
    echo 'PS1="(container) ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/${USERNAME}/.bashrc && \
    # Disable "EasyInstallDeprecationWarning: easy_install command is deprecated"
    echo 'PYTHONWARNINGS="ignore:easy_install command is deprecated,ignore:setup.py install is deprecated"' >> /home/$USERNAME/.bashrc  && \
    echo 'export PYTHONWARNINGS' >> /home/$USERNAME/.bashrc && \
    # Source ROS 2 setup
    echo "source /opt/ros/jazzy/setup.bash" >> /home/$USERNAME/.bashrc && \
    echo "source install/setup.bash" >> /home/$USERNAME/.bashrc

# Switch to the non-root user
USER $USERNAME

# Set entry point
CMD ["/bin/bash"]
