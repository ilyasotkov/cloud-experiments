FROM python:3.7.4-slim-stretch

WORKDIR /app
COPY ./requirements.txt .
RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends \
                build-essential \
        && pip3 install --no-cache-dir --quiet -r requirements.txt \
        && apt-get -qq purge -y build-essential && apt-get autoremove -y
COPY . .
EXPOSE 5000
ENTRYPOINT ["uwsgi"]
CMD ["uwsgi.ini"]
