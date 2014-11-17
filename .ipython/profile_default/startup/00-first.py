import os, sys, logging, traceback

def debug():
    logging.basicConfig(level=logging.DEBUG)

sys.path.insert(0, os.path.abspath('.'))

