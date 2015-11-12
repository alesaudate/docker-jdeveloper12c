FROM sciensa2/docker-java8

MAINTAINER Alexandre Saudate "alexandre.saudate@sciensa.com"

RUN apt-get update
RUN apt-get install -y wget unzip libgtk2.0-0:amd64 libxtst6
RUN wget https://s3.amazonaws.com/oracle-installers/jdev_suite_122100_linux64.bin
RUN wget https://s3.amazonaws.com/oracle-installers/jdev_suite_122100_linux64-2.zip

RUN unzip -d jdev_suite_122100_linux64-2 jdev_suite_122100_linux64-2.zip
RUN chmod +x jdev_suite_122100_linux64.bin

RUN useradd -s /bin/false developer

RUN export uid=developer gid=developer && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer


VOLUME /files 
COPY files/response.rsp /files/response.rsp
COPY files/oraInst.loc /etc/oraInst.loc
USER developer
ENV HOME /home/developer
RUN /jdev_suite_122100_linux64.bin -silent -responseFile /files/response.rsp -invPtrLoc /etc/oraInst.loc

CMD /home/developer/Oracle/Middleware/12.1.3/jdeveloper/jdev/bin/jdev

