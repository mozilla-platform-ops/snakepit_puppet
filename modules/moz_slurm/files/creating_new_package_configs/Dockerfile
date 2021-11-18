FROM ubuntu:18.04

COPY install_metapackage.sh /tmp/install_metapackage.sh
COPY generate_install_command.py /tmp/generate_install_command.py
RUN chmod 755 /tmp/*.sh

# get baseline package configuration
RUN dpkg --list > /tmp/base_bom.txt

# install metapackage
# - we need to know what packages we should include... metapackage is easiest
RUN /tmp/install_metapackage.sh

# record new package configuration
# for some reason the output wasn't updating... see if sleep works?
RUN sleep 10 && dpkg --list > /tmp/final_bom.txt

# RUN diff /tmp/base_bom.txt /tmp/final_bom.txt
# - ignore nvidia-prime as it's providied by ubuntu? right?
# RUN diff /tmp/base_bom.txt /tmp/final_bom.txt  | grep -E 'cuda|nvidia'
RUN /tmp/generate_install_command.py
