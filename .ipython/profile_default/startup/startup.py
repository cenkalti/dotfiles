import os, sys, logging, traceback
from base64 import b64encode, b64decode

logger = logging.getLogger("root")

sys.path.insert(0, os.path.abspath('.'))

def l_debug():
    logging.basicConfig(level=logging.DEBUG)

def l_info():
    logging.basicConfig(level=logging.INFO)

def l_warning():
    logging.basicConfig(level=logging.WARNING)

def l_error():
    logging.basicConfig(level=logging.ERROR)
