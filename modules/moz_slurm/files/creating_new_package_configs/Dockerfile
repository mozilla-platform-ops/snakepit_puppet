FROM ubuntu:18.04

COPY install_packages.sh /tmp/install_packages.sh
RUN dpkg --list > /tmp/base_bom.txt
RUN /tmp/install_packages.sh
RUN dpkg --list > /tmp/final_bom.txt
RUN diff /tmp/base_bom.txt /tmp/final_bom.txt
# diff base_bom.txt final_bom.txt  | grep -E 'cuda|nvidia' | grep -v prime
