import subprocess
import logging
import os

class Setup:
    def __init__(self, arguments):
        self._rScript = arguments.rScript
        self._inputDataFile = arguments.inputDataFile
        self._outputDataFile = arguments.outputDataFile

    def _run(self, *args, **kwargs):
        logging.info('running: {}'.format(args))
        subprocess.check_call(*args, **kwargs)

    def arguments(self):
        if self._rScript is not None:
            os.environ["R_SCRIPT"] = self._rScript
        if self._inputDataFile is not None:
            os.environ["INPUT_DATA_FILE"] = self._inputDataFile
        if self._outputDataFile is not None:
            os.environ["OUTPUT_DATA_FILE"] = self._outputDataFile