#ARG IMAGE=intersystemsdc/iris-community:2020.4.0.521.0-zpm
#Replaced with below image as above image has licence error
#ARG IMAGE=intersystemsdc/iris-community:2021.1.0.215.3-zpm
#ARG IMAGE=store/intersystems/irishealth-community:2021.2.0.617.0
ARG IMAGE=intersystemsdc/iris-ml-community:2021.2.0.617.0-zpm
FROM $IMAGE

USER root

WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
USER ${ISC_PACKAGE_MGRUSER}

COPY  Installer.cls .
COPY  src src
COPY iris.script /tmp/iris.script

RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly
