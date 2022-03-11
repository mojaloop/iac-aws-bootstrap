FROM ubuntu:18.04
ARG TERRAFORM_VERSION=1.0.5


# Update apt and Install dependencies
RUN add-apt-repository ppa:ansible/ansible && apt-get update && apt-get install -y \
    curl \
    dnsutils \
    git \
    jq \
    libssl-dev \
    openvpn \
    python3 \
    python3-pip \
    screen \
    vim \
    wget \
    zip \
    mysql-client \
    ansible \
    && rm -rf /var/lib/apt/lists/*

# Install tools and configure the environment
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin/ \
    && rm /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN pip3 install --upgrade pip \
    && mkdir /workdir && cd /workdir \
    && mkdir keys \
    && python3 -m pip install netaddr awscli

RUN pip3 install "openshift>=0.6" "setuptools>=40.3.0" \
     && ansible-galaxy collection install community.kubernetes

RUN pip3 install "openshift>=0.6" "setuptools>=40.3.0"

COPY . iac-run-dir