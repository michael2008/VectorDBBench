FROM python:3.11-buster as builder-image

RUN echo 'deb http://mirrors.volces.com/debian/ buster main non-free contrib \
deb http://mirrors.volces.com/debian-security buster/updates main \
deb http://mirrors.volces.com/debian/ buster-updates main non-free contrib \
deb http://mirrors.volces.com/debian/ buster-backports main non-free contrib' > /etc/apt/sources.list

# for APT source: see https://developer.volcengine.com/articles/7275535526869155859
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    vim \
    wget \
    procps \
    net-tools \
    iputils-ping \
    iproute2 \
    lsof \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://tos-tools.tos-cn-beijing.volces.com/linux/amd64/tosutil -O /usr/local/bin/tosutil \
    && chmod +x /usr/local/bin/tosutil

COPY install/requirements_py3.11.txt .
RUN pip3 install -U pip && pip3 install --no-cache-dir -r requirements_py3.11.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

#FROM python:3.11-slim-buster

#COPY --from=builder-image /usr/local/bin /usr/local/bin
#COPY --from=builder-image /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

WORKDIR /opt/code
COPY . .
ENV PYTHONPATH /opt/code

ENTRYPOINT ["python3", "-m", "vectordb_bench"]
