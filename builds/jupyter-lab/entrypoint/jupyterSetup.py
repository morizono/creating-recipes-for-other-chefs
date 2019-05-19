import subprocess
import logging
import os

class Setup:
    def __init__(self, arguments):
        self._help = arguments.help
        self._helpAll = arguments.helpAll
        self._debug = arguments.debug
        self._generateConfig = arguments.generateConfig
        self._yes = arguments.yes
        self._noBrowser = arguments.noBrowser
        self._pylab = arguments.pylab
        self._noMathJax = arguments.noMathJax
        self._allowRoot = arguments.allowRoot
        self._coreMode = arguments.coreMode
        self._devMode = arguments.devMode
        self._watch = arguments.watch
        self._logLevel = arguments.logLevel
        self._config = arguments.config
        self._ip = arguments.ip
        self._port = arguments.port
        self._portRetries = arguments.portRetries
        self._transport = arguments.transport
        self._keyFile = arguments.keyFile
        self._certFile = arguments.certFile
        self._clientCa = arguments.clientCa
        self._notebookDir = arguments.notebookDir
        self._browser = arguments.browser
        self._appDir = arguments.appDir
        self._disableNotebookAppToken = arguments.disableNotebookAppToken

    def _run(self, *args, **kwargs):
        logging.info('running: {}'.format(args))
        subprocess.check_call(*args, **kwargs)

    def arguments(self):
        args = []
        args += ["jupyter lab"]
        if self._help:
            args += [ "--help"]
        if self._helpAll:
            args += [ "--help-all"]
        if self._debug:
            args += [ "--debug"]
        if self._generateConfig:
            args += [ "--generate-config"]
        if self._yes:
            args += [ "-y"]
        if self._noBrowser:
            args += [ "--no-browser"]
        if self._pylab is not None:
            args += [ "--pylab=%s" % self._pylab]
        if self._noMathJax:
            args += [ "--no-mathjax"]
        if self._allowRoot:
            args += [ "--allow-root"]
        if self._coreMode:
            args += [ "--core-mode"]
        if self._devMode:
            args += [ "--dev-mode"]
        if self._watch:
            args += [ "--watch"]
        if self._logLevel is not None:
            args += [ "--log-level=%s" % self._logLevel]
        if self._config is not None:
            args += [ "--config=%s" % self._config]
        if self._ip is not None:
            args += [ "--ip=%s" % self._ip]
        if self._port is not None:
            args += [ "--port=%s" % self._port]
        if self._portRetries is not None:
            args += [ "--port-retries=%s" % self._portRetries]
        if self._transport is not None:
            args += [ "--transport=%s" % self._transport]
        if self._keyFile is not None:
            args += [ "--keyfile=%s" % self._keyFile]
        if self._certFile is not None:
            args += [ "--certfile=%s" % self._certFile]
        if self._clientCa is not None:
            args += [ "--client-ca=%s" % self._clientCa]
        if self._notebookDir is not None:
            args += [ "--notebook-dir=%s" % self._notebookDir]
        if self._browser is not None:
            args += [ "--browser=%s" % self._browser]
        if self._appDir is not None:
            args += [ "--app-dir=%s" % self._appDir]
        if self._disableNotebookAppToken:
            args += [ "--NotebookApp.token=''"]

        os.environ["JUPYTER_ARGS"] = " ".join(args)
