#!/bin/bash

drush="drush -y "

$drush si && \
  $drush en master && \
  $drush master-exec && \
  $drush updb && \
  $drush fra
