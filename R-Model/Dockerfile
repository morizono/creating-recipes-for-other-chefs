FROM python:3.7.2-stretch

RUN apt-get -y update && \
    apt-get -y install \
        r-base \
        r-base-dev \
        pandoc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN R -e "install.packages(c('randomForest','lubridate','timeDate'), dependencies=T, repos='http://cran.us.r-project.org')"

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p /data
COPY r-files /r-files
COPY entrypoint /entrypoint

RUN chmod u+x /r-files/*.R /entrypoint/entrypoint.py

WORKDIR /entrypoint

ENTRYPOINT ["python3", "-u", "entrypoint.py"]
