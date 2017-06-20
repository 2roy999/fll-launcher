FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

ARG DOCKER_VERSION
ARG VBOX_VERSION
ARG VBOX_REV
ARG NWJS_VERSION

RUN dpkg --add-architecture i386

RUN sed -i "s/main/main contrib non-free/" etc/apt/sources.list

RUN apt-get update && apt-get install -yq \
    curl \
    unrar \
    unzip \
    wine

# innosetup
RUN mkdir innosetup && \
    cd innosetup && \
    curl -fsSL -o innounp045.rar "https://downloads.sourceforge.net/project/innounp/innounp/innounp%200.45/innounp045.rar?r=&ts=1439566551&use_mirror=skylineservers" && \
    unrar e innounp045.rar

RUN cd innosetup && \
    curl -fsSL -o is-unicode.exe http://files.jrsoftware.org/is/5/isetup-5.5.8-unicode.exe && \
    wine "./innounp.exe" -e "is-unicode.exe"

WORKDIR /bundle

RUN curl -fsSL -o boot2docker.iso https://github.com/boot2docker/boot2docker/releases/download/v$DOCKER_VERSION/boot2docker.iso

RUN curl -fsSL -o virtualbox.exe "http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VirtualBox-$VBOX_VERSION-$VBOX_REV-Win.exe" && \
    echo "$(curl -fsSL 'https://virtualbox.org/download/hashes/'"$VBOX_VERSION"'/SHA256SUMS' | awk '$2 ~ /-Win.exe$/ { print $1 }') *virtualbox.exe" | sha256sum -c -

RUN wine virtualbox.exe -extract -silent -path . && \
    rm virtualbox.exe && \
    rm *x86.msi && \
    mv *_amd64.msi VirtualBox_amd64.msi

RUN curl -fsSL -o nwjs.zip "https://dl.nwjs.io/v$NWJS_VERSION/nwjs-v$NWJS_VERSION-win-x64.zip" && \
    unzip nwjs.zip -d . && \
    rm nwjs.zip && \
    mv nwjs-* app

COPY package.json app/package.nw/
COPY index.html app/package.nw/

COPY windows/setup/* /installer/

WORKDIR /installer

RUN rm -rf /tmp/.wine-0/
RUN ls -la /bundle/app/package.nw
RUN wine ../innosetup/ISCC.exe main.iss