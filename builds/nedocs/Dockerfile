FROM python:3.7.2-stretch

ENV R_PACKAGES "'randomforest','lubridate', 'timedata'"
#this limits how many layers of packages needed in your image
#makes it easier to audit what packages used.

RUN apt-get -y update && \
    apt-get -y install \
        r-base \
        r-base-dev \
        pandoc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    #is written this way as blocks to make it easier to see when things fail

RUN R -e "install.packages(c(${R_PACKAGES}), dependencies=T, repos='http://cran.us.r-project.org')"

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p /r-files
COPY nedocsRandomForestForecast.R /r-files/nedocsRandomForestForecast.R
COPY two_hour_call_need_rf_v2_b.RData /r-files/two_hour_call_need_rf_v2_b.RData
COPY entrypoint /entrypoint

RUN chmod u+x /r-files/*.R /entrypoint/entrypoint.py

WORKDIR /entrypoint

ENTRYPOINT ["python3", "-u", "entrypoint.py"]
