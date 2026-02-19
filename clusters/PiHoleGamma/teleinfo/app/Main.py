import json
import logging
import os
import time

import paho.mqtt.client as mqtt

from Parser import Parser


def on_log(client, userdata, level, buff):
    logging.info(f"level:{level} buff:{buff}")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    logging.info("starting")

    ti = Parser()
    client = mqtt.Client("teleinfo")

    # client.enable_logger()
    # client.on_log = on_log
    client.username_pw_set(os.environ.get("MQTT_USER", None), os.environ.get("MQTT_PASSWORD", None))

    client.connect("192.168.0.31")
    client.loop_start()
    # print(json.dumps(ti.get_frame(), indent=2, separators=(',', ':')))
    while True:
        dic = ti.get_frame()
        dic["_time"] = int(time.time())  # epoch
        client.publish("homeassistant/sensor/teleinfo/linky", payload=json.dumps(dic), retain=True)