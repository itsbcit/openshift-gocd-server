# these 3 vars are used by `/go-server/server.sh`, so we export
export GO_SERVER_SYSTEM_PROPERTIES="${GO_SERVER_SYSTEM_PROPERTIES}${GO_SERVER_SYSTEM_PROPERTIES:+ }-Dgo.console.stdout=true"
export SERVER_WORK_DIR="/go-working-dir"
export GO_CONFIG_DIR="/go-working-dir/config"

VOLUME_DIR="/godata"

for serverdir in artifacts config db logs plugins addons;do
    [ -e "${VOLUME_DIR}/${serverdir}" ] || mkdir -p "${VOLUME_DIR}/${serverdir}"
    [ -e "${SERVER_WORK_DIR}/${serverdir}" ] || ln -s "${VOLUME_DIR}/${serverdir}" "${SERVER_WORK_DIR}/${serverdir}"
done

cp -f "/go-server/config/logback-include.xml" "${SERVER_WORK_DIR}/config/logback-include.xml"
