ARG GROUP_ID=1001
ARG USER_ID=1001

ARG ARCH_BASE_IMAGE

FROM docker.io/${ARCH_BASE_IMAGE} AS x11_arch

RUN pacman -Sy --disable-download-timeout --noconfirm \
    awk \
    base-devel \
    curl \
    flake8 \
    git \
    gzip \
    htop \
    httpie \
    jq \
    lsof \
    mypy \
    neovim \
    openssh \
    procps-ng \
    python \
    python-dotenv \
    python-pip \
    python-virtualenv \
    python-beautifulsoup4 \
    python-black \
    python-click \
    python-cryptography \
    python-dotenv \
    python-flake8 \
    python-httpx \
    python-numpy \
    python-openpyxl \
    python-pandas \
    python-psutil \
    python-pytest \
    python-requests \
    python-rich \
    python-ruff \
    python-watchdog \
    python-yaml \
    ripgrep \
    ruff \
    sed \
    shellcheck \
    sqlite \
    strace \
    tar \
    tree \
    unzip \
    wget \
    which \
    yq \
    && pacman -Scc --noconfirm

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
