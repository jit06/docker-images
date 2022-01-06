FROM openhab/openhab:3.1.0

# add the entrypoint modification
COPY entrypoint_addon.sh /entrypoint_addon.sh

# add entrypoint modification at the begining
RUN sed -i -e "s/#!\/bin\/bash -x/ /g" /entrypoint ; \
    cat /entrypoint_addon.sh /entrypoint > /new_entrypoint ; \
    rm /entrypoint ; \
    mv /new_entrypoint /entrypoint ; \
    chmod +x /entrypoint
