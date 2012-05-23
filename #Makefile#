MXMLC=bin/fcsh.py

SRC_DIR:=src
APP_NAME:=net/jazz/TMain.as

CONFIG_NAME:=build.xml

CLASSPATH_DIR=../flashpunk/lib/

APP_WIDTH:=640
APP_HEIGHT:=480

BG_COLOR:=0xffffff

DEST_DIR:=dest
DEST_NAME:=jazz-jackrabbit-2.swf

TEST_APP_NAME:=TestRunner.mxml
TEST_APP:=test.swf

TEST_DIR:=test

TEST_WIDTH:=800
TEST_HEIGHT:=600

TEST_LIBS:=lib/flexunit-uilistener.swc:lib/flexunit4.swc

DEBUG:=false

.PHONY: clean

all: ${DEST_DIR}/${DEST_NAME}

test: ${DEST_DIR}/${TEST_APP}

${DEST_DIR}/${TEST_APP}: ${TEST_DIR}/${TEST_APP_NAME}
	${MXMLC} -source-path ${SRC_DIR} \
           --output ${DEST_DIR}/${TEST_APP} \
           --default-size ${APP_WIDTH} ${APP_HEIGHT} \
           --default-background-color ${BG_COLOR} \
           --load-config+=${CONFIG_NAME} \
           --debug=${DEBUG} \
           --library-path+=${TEST_LIBS} \
           ${TEST_DIR}/${TEST_APP_NAME}

${DEST_DIR}/${DEST_NAME}: ${SRC_DIR}/${APP_NAME} Makefile
	${MXMLC} -source-path ${SRC_DIR} ${CLASSPATH_DIR} \
           --output ${DEST_DIR}/${DEST_NAME} \
           --default-size ${TEST_WIDTH} ${TEST_HEIGHT} \
           --default-background-color ${BG_COLOR} \
           --load-config+=${CONFIG_NAME} \
           --debug=${DEBUG} \
           ${SRC_DIR}/${APP_NAME}

clean:
	-rm ${DEST_DIR}/${DEST_NAME}
	-rm ${DEST_DIR}/${TEST_APP}
