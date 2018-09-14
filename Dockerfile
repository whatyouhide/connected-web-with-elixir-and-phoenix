FROM renra/phoenix-node:1.3.2_elx1.7_erlang19_node10.10.0

ENV dir /usr/src/app

RUN mkdir -p ${dir}
WORKDIR ${dir}

COPY ./ ${dir}

WORKDIR ${dir}/chat/assets
RUN npm install

WORKDIR ${dir}
