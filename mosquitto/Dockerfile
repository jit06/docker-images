FROM eclipse-mosquitto

RUN sed -i 's/#listener/listener 1883/g' /mosquitto/config/mosquitto.conf
RUN sed -i 's/#allow_anonymous false/allow_anonymous true/g' /mosquitto/config/mosquitto.conf
