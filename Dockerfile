ARG GROUP_ID=1001
ARG USER_ID=1001

ARG ARCH_BASE_IMAGE

FROM docker.io/${ARCH_BASE_IMAGE} AS x11_arch

RUN pacman -Sy --disable-download-timeout --noconfirm \
    base-devel \
    python \
    tar \
    which

ARG GROUP_ID
ARG USER_ID
ARG USER_NAME

RUN groupadd -g $GROUP_ID $USER_NAME \
    && useradd -u $USER_ID -g $GROUP_ID -m $USER_NAME

USER $USER_NAME

# codex adds to .bashrc
RUN cd /tmp \
    && curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_HOME=/home/$USER_NAME/.codex.bin sh

ENV PATH="/home/$USER_NAME/.local/bin:$PATH"

ENTRYPOINT ["/bin/bash", "-cl"]
CMD ["codex"]
