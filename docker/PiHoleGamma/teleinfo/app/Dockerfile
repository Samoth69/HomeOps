FROM python:3.13-slim-bullseye

COPY . /app

RUN pip install pyserial 'paho-mqtt<2.0.0'

CMD ["python", "/app/Main.py"]