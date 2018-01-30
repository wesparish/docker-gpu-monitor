FROM wesparish/nvidia:384.90

RUN apt-get update && \
    apt-get install python python-elasticsearch lm-sensors vim curl -y && \
    apt-get autoremove -y && \
    apt-get clean

RUN curl -OJL https://pypi.python.org/packages/4e/11/c17454160e80a60587adcb511b760a6ddf8b2d60683bb0edd85919199adf/PySensors-0.0.3.tar.gz && \
    tar -xzvf PySensors-0.0.3.tar.gz && \
    cd PySensors-0.0.3 && \
    python setup.py install && \
    cd / && \
    rm -rf PySensors-0.0.3

ENV ES_HOSTS="elasticsearch.weshouse:9200" \
    LOG_LEVEL="WARN" \
    SLEEP_TIME=60

COPY get-gpu-sensors.py /get-gpu-sensors.py
RUN chown root:root /get-gpu-sensors.py

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/get-gpu-sensors.py"]
