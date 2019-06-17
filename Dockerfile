FROM python:3
ADD . /tvnamer
WORKDIR /tvnamer
RUN pip install .
ENTRYPOINT ["tvnamer"]
