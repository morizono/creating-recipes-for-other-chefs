#!/usr/bin/env python

import sys
import os
import config
import logging
import commandlineparser

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG, format="%(message)s")

try:
    arguments = commandlineparser.parse()
    setup = config.Setup(arguments)
    setup.arguments()
    os.system(os.environ["R_SCRIPT"])
except:
    logging.exception('failed!')
