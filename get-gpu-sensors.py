#!/usr/bin/env python

import sensors
import json
import os
from elasticsearch import Elasticsearch
from datetime import datetime
import socket
import logging
import sys
import signal
import time

class GracefulKiller:
  kill_now = False
  def __init__(self):
    signal.signal(signal.SIGINT, self.exit_gracefully)
    signal.signal(signal.SIGTERM, self.exit_gracefully)

  def exit_gracefully(self,signum, frame):
    self.kill_now = True

if __name__ == '__main__':
  killer = GracefulKiller()
  es = Elasticsearch(os.environ.get("ES_HOSTS","172.16.1.17:9200").split(","))
  logging.basicConfig(stream=sys.stdout,
                      level=os.environ.get("LOG_LEVEL","WARN").upper())

  logging.warn("%s starting..." % (os.path.basename(__file__)))
  while True:
    try:
      curr_index = 'gpu-sensors-%s' % (datetime.now().strftime('%Y%m%d'))
      logging.info("curr_index: %s" % (curr_index))
      sensors.init()
      for chip in sensors.iter_detected_chips("amdgpu-*"):
        chip_dict = {}
        chip_dict['name'] = str(chip)
        chip_dict['date'] = datetime.now()
        chip_dict['hostname'] = os.environ.get("HOSTNAME", socket.gethostname())
        for feature in chip:
          chip_dict[feature.label] = feature.get_value()
        logging.info("chip_dict: %s" % (chip_dict))
        es.index(index=curr_index,
                 doc_type="gpu-sensors",
                 body=chip_dict)
    except Exception as inst:
      logging.error("Caught exception: %s, %s" % (type(inst), inst))
    finally:
      sensors.cleanup()
    if killer.kill_now:
      break
    time.sleep(float(os.environ.get("SLEEP_TIME", 60)))

  logging.warn("%s exiting gracefully..." % (os.path.basename(__file__)))

