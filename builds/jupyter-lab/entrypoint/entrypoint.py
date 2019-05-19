#!/usr/bin/env python3
import os
import sys
import jupyterSetup
import logging
import commandlineParser

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG, format="%(message)s")

try:
    arguments = commandlineParser.parse()
    setup = jupyterSetup.Setup(arguments)
    setup.arguments()
    os.system("/usr/local/bin//$JUPYTER_ARGS")
except:
    logging.exception('failed!')
