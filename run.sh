#!/bin/sh

export COMPOSE_FILE_PATH="${PWD}/target/classes/docker/docker-compose.yml"

if [ -z "${M2_HOME}" ]; then
  export MVN_EXEC="mvn"
else
  export MVN_EXEC="${M2_HOME}/bin/mvn"
fi

start() {
    docker volume create share-site-creators-acs-volume
    docker volume create share-site-creators-db-volume
    docker volume create share-site-creators-ass-volume
    docker-compose -f "$COMPOSE_FILE_PATH" up --build -d
}

start_share() {
    docker-compose -f "$COMPOSE_FILE_PATH" up --build -d share-site-creators-share
}

start_acs() {
    docker-compose -f "$COMPOSE_FILE_PATH" up --build -d share-site-creators-acs
}

down() {
    if [ -f "$COMPOSE_FILE_PATH" ]; then
        docker-compose -f "$COMPOSE_FILE_PATH" down
    fi
}

purge() {
    docker volume rm -f share-site-creators-acs-volume
    docker volume rm -f share-site-creators-db-volume
    docker volume rm -f share-site-creators-ass-volume
}

build() {
    $MVN_EXEC clean package
    if [ "$?" -ne 0 ] ; then
      echo 'Erreur build Maven'; exit 1
    fi
}

build_share() {
    docker-compose -f "$COMPOSE_FILE_PATH" kill share-site-creators-share
    yes | docker-compose -f "$COMPOSE_FILE_PATH" rm -f share-site-creators-share
    $MVN_EXEC clean package -pl share-site-creators-share,share-site-creators-share-docker
    if [ "$?" -ne 0 ] ; then
      echo 'Erreur build Maven'; exit 1
    fi
}

build_acs() {
    docker-compose -f "$COMPOSE_FILE_PATH" kill share-site-creators-acs
    yes | docker-compose -f "$COMPOSE_FILE_PATH" rm -f share-site-creators-acs
    $MVN_EXEC clean package -pl share-site-creators-integration-tests,share-site-creators-repo,share-site-creators-platform-docker
    if [ "$?" -ne 0 ] ; then
      echo 'Erreur build Maven'; exit 1
    fi
}

tail() {
    docker-compose -f "$COMPOSE_FILE_PATH" logs -f
}

tail_all() {
    docker-compose -f "$COMPOSE_FILE_PATH" logs --tail="all"
}

prepare_test() {
    $MVN_EXEC verify -DskipTests=true -pl share-site-creators-repo,share-site-creators-integration-tests,share-site-creators-platform-docker
}

test() {
    $MVN_EXEC verify -pl share-site-creators-repo,share-site-creators-integration-tests
}

case "$1" in
  build_start)
    down
    build
    start
    tail
    ;;
  build_start_it_supported)
    down
    build
    prepare_test
    start
    tail
    ;;
  start)
    start
    tail
    ;;
  stop)
    down
    ;;
  purge)
    down
    purge
    ;;
  tail)
    tail
    ;;
  reload_share)
    build_share
    start_share
    tail
    ;;
  reload_acs)
    build_acs
    start_acs
    tail
    ;;
  build_test)
    down
    build
    prepare_test
    start
    test
    tail_all
    down
    ;;
  test)
    test
    ;;
  *)
    echo "Usage: $0 {build_start|build_start_it_supported|start|stop|purge|tail|reload_share|reload_acs|build_test|test}"
esac