MXMLC=bin/fcsh.py

SRC_DIR:=src
APP_NAME:=net/jazz/TMain.as
MAPS_SRC:=${SRC_DIR}/net/jazz/game/map/*
DATA_SRC:=${SRC_DIR}/net/jazz/game/data/*
CORE_SRC:=${SRC_DIR}/net/jazz/game/core/*
CORE_GRAPHIC_SRC:=${SRC_DIR}/net/jazz/game/core/graphic/*

CONFIG_NAME:=build.xml

CLASSPATH_DIR=../flashpunk/lib/

APP_WIDTH:=640
APP_HEIGHT:=480

BG_COLOR:=0xffffff

DEST_DIR:=dest
DEST_NAME:=jazz-jackrabbit-2.swf

TEST_DIR:=test

TEST_APP_NAME:=TestRunner.mxml
TEST_RUNNER_SRC:=${TEST_DIR}/TestSuite.as
TEST_CASES_SRC:=${TEST_DIR}/cases/*.as
TEST_APP:=test.swf

TEST_WIDTH:=800
TEST_HEIGHT:=600

APP_LIBS:=lib/picoContainer.swc
TEST_LIBS:=lib/flexunit-uilistener.swc:lib/flexunit4.swc

DEBUG:=true

.PHONY: clean

all: ${DEST_DIR}/${DEST_NAME}

test: ${DEST_DIR}/${TEST_APP}

${DEST_DIR}/${TEST_APP}: ${TEST_DIR}/${TEST_APP_NAME} ${TEST_RUNNER_SRC} ${TEST_CASES_SRC}
	${MXMLC} -source-path ${SRC_DIR} ${CLASSPATH_DIR} \
           --output ${DEST_DIR}/${TEST_APP} \
           --default-size ${APP_WIDTH} ${APP_HEIGHT} \
           --default-background-color ${BG_COLOR} \
           --load-config+=${CONFIG_NAME} \
           --debug=${DEBUG} \
           --library-path+=${TEST_LIBS}:${APP_LIBS} \
           ${TEST_DIR}/${TEST_APP_NAME}

${DEST_DIR}/${DEST_NAME}: ${SRC_DIR}/${APP_NAME} Makefile ${MAPS_SRC} ${DATA_SRC} ${CORE_SRC} ${CORE_GRAPHIC_SRC}
	${MXMLC} -source-path ${SRC_DIR} ${CLASSPATH_DIR} \
           --output ${DEST_DIR}/${DEST_NAME} \
           --default-size ${TEST_WIDTH} ${TEST_HEIGHT} \
           --default-background-color ${BG_COLOR} \
           --library-path+=${APP_LIBS} \
           --load-config+=${CONFIG_NAME} \
           --debug=${DEBUG} \
           ${SRC_DIR}/${APP_NAME}

clean:
	-rm -f ${DEST_DIR}/${DEST_NAME}
	-rm -f ${DEST_DIR}/${TEST_APP}
