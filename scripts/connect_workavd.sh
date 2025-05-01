read -p "Client: " client
VIVA_RDPW_LOCATION="VivaVm.rdpw"
OTR_RDPW_LOCATION="OTRVm.rdpw"
FREERDP="xfreerdp"
if grep -q '^ID=arch$' /etc/os-release; then
    FREERDP="xfreerdp3" #for arch use the xfreerdp3 cli
fi

if [ "$client" = "viva" ]; then
    $FREERDP $VIVA_RDPW_LOCATION /gateway:type:arm /sec:aad /floatbar +auto-reconnect +dynamic-resolution
fi

if [ "$client" = "otr" ]; then
    read -p "User:" user
    read -s -p "Password:" pass
    $FREERDP $OTR_RDPW_LOCATION /gateway:type:arm /u:$user /p:$pass /d:peregrine.local /sec:tls /cert:ignore /floatbar +auto-reconnect +dynamic-resolution
fi
