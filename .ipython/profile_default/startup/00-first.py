import os, sys, logging, traceback
from base64 import b64encode, b64decode

def debug():
    logging.basicConfig(level=logging.DEBUG)

sys.path.insert(0, os.path.abspath('.'))

