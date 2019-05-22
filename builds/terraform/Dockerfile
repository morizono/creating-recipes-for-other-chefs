FROM google/cloud-sdk

ENV BUILD_PACKAGES \
    wget \
    make \
    uuid-runtime

RUN apt-get -y update && \
    apt-get -y install ${BUILD_PACKAGES}

# Install Go
ENV GOLANG_VERSION 1.12.5
ENV goRelArch 'linux-amd64'
ENV goRelSha256 'aea86e3c73495f205929cfebba0d63f1382c8ac59be081b6351681415f4063cf'
ENV url "https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz"
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN wget -O go.tgz "$url" && \
    echo "${goRelSha256} *go.tgz" | sha256sum -c - && \
    tar -C /usr/local -xzf go.tgz && \
    rm go.tgz && \
    mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Install Terraform
ENV TF_DEV=true
ENV TF_RELEASE=true
ENV TERRAFORM_VERSION=0.11.13
WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout v${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh

# Install kfctl
ENV KF_VERSION=0.5.1
ENV KF_URL=https://github.com/kubeflow/kubeflow/releases/download/v${KF_VERSION}/kfctl_v${KF_VERSION}_linux.tar.gz
RUN wget -O kf.tar.gz ${KF_URL} && \
    tar -C /usr/local/bin -xzf kf.tar.gz && \
    rm kf.tar.gz

# Install pachctl
RUN wget -O /tmp/pachctl.deb -L https://github.com/pachyderm/pachyderm/releases/download/v1.9.0rc2/pachctl_1.9.0rc2_amd64.deb \
    && dpkg -i /tmp/pachctl.deb

RUN mkdir -p /deployments
WORKDIR /deployments

CMD ["terraform"]
