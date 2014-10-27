#!/bin/bash
scp -r "$1" kanin@blay.se:www/pix.juarez.se/www/
echo 'http://pix.juarez.se/'$1 | pbcopy
