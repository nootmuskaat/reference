#!/bin/bash
exec i3 -V >> /var/log/i3/i3log_$(date +'%F-%H-%M-%S') 2>&1
