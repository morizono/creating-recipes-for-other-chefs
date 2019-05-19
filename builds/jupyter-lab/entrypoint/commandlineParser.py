import argparse

def parse():
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("jupyter", nargs='?', help="Calling jupyter lab directly")
    parser.add_argument("lab", nargs='?', help="Calling jupyter lab directly")
    parser.add_argument("--help", action="store_true", dest="help", help="show this help message and exit")
    parser.add_argument("--help-all", action="store_true", dest="helpAll", help="To see all available configurables")
    parser.add_argument("--debug", action="store_true", dest="debug", help="set log level to logging.DEBUG (maximize logging output)")
    parser.add_argument("--generate-config", action="store_true", dest="generateConfig", help="generate default config file")
    parser.add_argument("-y", action="store_true", dest="yes", help="Answer yes to any questions instead of prompting.")
    parser.add_argument("--no-browser", action="store_true", dest="noBrowser", help="Don't open the notebook in a browser after startup.")
    parser.add_argument("--pylab", default=None, dest="pylab", help="Defaulted to 'disabled'. Use %pylab or %matplotlib in the notebook to enable matplotlib.")
    parser.add_argument("--no-mathjax", action="store_true", dest="noMathJax", help="Disable MathJax")
    parser.add_argument("--allow-root", action="store_true", dest="allowRoot", help="Allow the notebook to be run from root user.")
    parser.add_argument("--core-mode", action="store_true", dest="coreMode", help="Start the app in core mode.")
    parser.add_argument("--dev-mode", action="store_true", dest="devMode", help="Start the app in dev mode for running from source.")
    parser.add_argument("--watch", action="store_true", dest="watch", help="Start the app in watch mode.")
    parser.add_argument("--log-level", default=None, dest="logLevel", help="Set the log level by value or name.")
    parser.add_argument("--config", default=None, dest="config", help="Full path of a config file.")
    parser.add_argument("--ip", default="0.0.0.0", dest="ip", help="The IP address the notebook server will listen on.")
    parser.add_argument("--port", default="8888", dest="port", help="The port the notebook server will listen on.")
    parser.add_argument("--port-retries", default=None, dest="portRetries", help="The number of additional ports to try if the specified port is not available.")
    parser.add_argument("--transport", default=None, dest="transport", help="transportation protocol")
    parser.add_argument("--keyfile", default=None, dest="keyFile", help="The full path to a private key file for usage with SSL/TLS.")
    parser.add_argument("--certfile", default=None, dest="certFile", help="The full path to an SSL/TLS certificate file.")
    parser.add_argument("--client-ca", default=None, dest="clientCa", help="The full path to a certificate authority certificate for SSL/TLS client authentication.")
    parser.add_argument("--notebook-dir", default=None, dest="notebookDir", help="The directory to use for notebooks and kernels.")
    parser.add_argument("--browser", default=None, dest="browser", help="Specify what command to use to invoke a web browser when opening the notebook.")
    parser.add_argument("--app-dir", default=None, dest="appDir", help="The app directory to launch JupyterLab from.")
    parser.add_argument("--disable-notebook-app-token", action="store_true", dest="disableNotebookAppToken", help="Disable needing a notebook app token to access jupyter lab workspace")

    return parser.parse_args()






