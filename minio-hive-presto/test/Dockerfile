FROM python:3.7.6-slim-stretch
WORKDIR /testapp
COPY e2e-requirements.txt .
RUN pip3 install -r e2e-requirements.txt
COPY . . 
