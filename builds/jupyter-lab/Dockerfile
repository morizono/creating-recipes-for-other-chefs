FROM python:3.7.3-stretch

# Install Container Requirements
RUN apt-get -y update && \
    apt-get -y install \
        apt-transport-https \
        lsb-release \
        software-properties-common \
        libzmq3-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        gdebi-core \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        r-base \
        r-base-dev \
        pandoc \
        procps \
        python \
        python-pip \
        unixodbc-dev \
        jq \
        sshpass

# Install node
RUN curl -L https://git.io/n-install | N_PREFIX=/usr/n-install bash -s -- -yq
ENV PATH=/usr/n-install/bin:$PATH

# Install Jupyter Notebook and lab
RUN python3 -m pip install \
        jupyter \
        jupyterlab \
        pandas \
        qgrid

RUN jupyter labextension install \
        @jupyter-widgets/jupyterlab-manager \
        qgrid; \
    jupyter nbextension enable --py widgetsnbextension; \
    jupyter lab clean

# Install Bash Kernel
RUN pip3 install bash_kernel && \
    python3 -m bash_kernel.install

# Go Kernel
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

# install gophernotes
RUN go get -u github.com/gopherdata/gophernotes && \
    mkdir -p ~/.local/share/jupyter/kernels/gophernotes && \
    cp $GOPATH/src/github.com/gopherdata/gophernotes/kernel/* ~/.local/share/jupyter/kernels/gophernotes

# Install R Kernel
RUN R -e "install.packages(c('IRkernel'), dependencies=T, repos='http://cran.us.r-project.org'); IRkernel::installspec()"

# Pip install ODBC packages
RUN pip3 install \
        pyodbc \
        sqlalchemy \
        cx_Oracle \
        RISE

# Adding presentation plugin
RUN jupyter-nbextension install rise --py --sys-prefix && \
    jupyter nbextension enable rise --py --sys-prefix && \
    pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --system && \
    jupyter labextension install jupyterlab-drawio

# Copy entrypoint files
RUN mkdir -p /entrypoint
COPY entrypoint /entrypoint
RUN chmod u+x /entrypoint/entrypoint.py

WORKDIR /root
ENTRYPOINT ["/entrypoint/entrypoint.py"]