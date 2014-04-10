#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2014 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.

"""
I do media file upload to S3 very often in various projects.
So I thought I ll have a script always ready.
"""

# Settings


AWS_SECRET_KEY = 'secret_key'
AWS_ACCESS_KEY = 'access_key'
AWS_BUCKET = 'bucket'
AWS_BASE_URL = 'https://*.cloudfront.net'
AWS_EXPIRY_TIME = 60 * 30  # Half an hour
AWS_FORCE_HTTP = True
"""
`UPLOAD_TO_S3` flag to tell if the files are needed to be uploaded to S3.
During development, set this to `False`. And set to `True` in production.
"""
UPLOAD_TO_S3 = False
MEDIA_URL = ""

"""
A Wrapper around boto to upload to s3
"""
import os
from boto.s3.connection import S3Connection
from boto.s3.key import Key

from django.conf import settings

if settings.UPLOAD_TO_S3:
    conn = S3Connection(settings.AWS_ACCESS_KEY, settings.AWS_SECRET_KEY)
    bucket = conn.get_bucket(settings.AWS_BUCKET)


def key_for_file(file):
    """
    `key_for_file` generates an s3 key for the given file.
    """
    return '/files/' + file._file.path.split('media/')[1]


def upload(file):
    """
    This guy uploads the file from the given directory
    """
    k = Key(bucket)
    k.key = key_for_file(file)
    k.set_contents_from_filename(file._file.path)


def temp_url(file):
    """
    Function to generate a temproary AWS URL for fiven file object
    """
    k = Key(bucket)
    k.key = key_for_file(file)
    return k.generate_url(
        expires_in=settings.AWS_EXPIRY_TIME,
        force_http=settings.AWS_FORCE_HTTP)


def process_file(file):
    """
    Upload the file to s3
    """
    if not settings.UPLOAD_TO_S3:
        return file
    try:
        if not file.uploaded:
            upload(file)
            os.remove(file._file.path)
            file.uploaded = True
            file.save()
    except Exception:
        print "unable to upload file to s3"
    finally:
        return file

"""
File: myapp/models.py
File Model configuration
"""
from django.db import models

AWS_PREFIX = AWS_BASE_URL + MEDIA_URL


class MyFileModel(models.Model):
    """
    This is the django model that you have file associated with.
    Here I am assuming that `_file` is your FileField
    """

    """
    Add a `uploaded` BooleanField to mark files if they
    are uploaded to S3 or not
    """
    uploaded = models.BooleanField(default=False)

    @property
    def get_url(self):
        if self.uploaded:
            """
            If the file is uploaded, return the temproary URL.
            """
            return temp_url(self)
        """
        Else the file URL or anything that is equivalent
        """
        return self._file.url


"""
Management command to process existing files.
"""
from django.core.management.base import BaseCommand
# from myapp.models import MyFileModel

files = MyFileModel.objects.filter(uploaded=False)


class Command(BaseCommand):
    help = 'Re-process all the files from s3'

    def handle(self, *args, **options):
        for file in files:
            file = process_file(file)
