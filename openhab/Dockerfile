FROM openhab/openhab:2.5.3-armhf-debian

# add the entrypoint modification
COPY entrypoint_addon.sh /entrypoint_addon.sh

# add entrypoint modification at the begining
RUN sed -i -e "s/#!\/bin\/bash -x/ /g" /entrypoint.sh ; \
    cat /entrypoint_addon.sh /entrypoint.sh > /new_entrypoint.sh ; \
    rm /entrypoint.sh ; \
    mv /new_entrypoint.sh /entrypoint.sh ; \
    chmod +x /entrypoint.sh
