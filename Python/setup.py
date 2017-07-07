#!/usr/bin/env python

"""
setup.py file for BlurHash
"""

from distutils.core import setup, Extension

module = Extension('_BlurHash', sources=['BlurHash.c'])

setup (name = 'BlurHash',
       version = '1.0',
       author      = "Dag Agren",
       description = """Create tiny image placeholders encoded as strings""",
       ext_modules = [module],
       py_modules = ["BlurHash"],
       )
