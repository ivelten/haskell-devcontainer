# Build direnv from source so its embedded Go stdlib is patched (prebuilt binaries bundle the
# Go version used at release time and cannot be updated independently).
# Update DIRENV_VERSION and the golang tag together when upgrading.
FROM golang:1.26.3-bookworm AS direnv-builder
ARG DIRENV_VERSION=2.37.1
RUN go install github.com/direnv/direnv/v2@v${DIRENV_VERSION}

FROM mcr.microsoft.com/devcontainers/base:debian

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install System Dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libffi-dev \
    libgmp-dev \
    libssl-dev \
    libtinfo-dev \
    pkg-config \
    zlib1g-dev \
    socat \
    procps \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install Node.js 22 LTS from NodeSource, then upgrade npm to get patched picomatch (>=4.0.4)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    npm install -g npm@latest

# 3. Install direnv (compiled with patched Go stdlib — see builder stage above)
COPY --from=direnv-builder /go/bin/direnv /usr/local/bin/direnv

# Switch to the non-root 'vscode' user provided by the base image
USER vscode
SHELL ["/bin/bash", "-c"]

# 4. Configure Haskell Environment Path
# Ensures ghcup, cabal, and stack binaries are prioritized in the PATH
ENV PATH="/home/vscode/.cabal/bin:/home/vscode/.local/bin:/home/vscode/.ghcup/bin:$PATH"

# 5. Install Haskell Toolchain (GHCup, GHC, Cabal, HLS, Stack)
# Using GHC 9.10.3 as the primary compiler version
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | \
    BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
    BOOTSTRAP_HASKELL_GHC_VERSION=9.10.3 \
    BOOTSTRAP_HASKELL_CABAL_VERSION=3.12.1.0 \
    BOOTSTRAP_HASKELL_INSTALL_STACK=1 \
    BOOTSTRAP_HASKELL_INSTALL_HLS=1 sh && \
    ghcup set ghc 9.10.3

# 6. Install Haskell Tools (Hoogle, Ormolu, Fast-Tags, DAP Adapters)
RUN cabal update && \
    cabal install hoogle fast-tags ormolu cabal-gild \
    haskell-dap ghci-dap haskell-debug-adapter \
    --overwrite-policy=always && \
    hoogle generate

# 7. Cabal Performance Tuning
RUN mkdir -p ~/.cabal && \
    echo "jobs: \$ncpus" >> ~/.cabal/config && \
    echo "documentation: False" >> ~/.cabal/config

# 8. Shell Integration (Direnv & Welcome Message)
RUN echo 'eval "$(direnv hook bash)"' >> ~/.bashrc && \
    echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc && \
    echo -e "🖥️ Haskell Dev Env Ready!\n- GHC 9.10.3\n- Tools: Hoogle, Ormolu, HLS" > /home/vscode/.welcome_message && \
    echo 'cat /home/vscode/.welcome_message' >> ~/.bashrc

WORKDIR /workspaces/haskell

# Re-enable interactive prompts
ENV DEBIAN_FRONTEND=dialog
