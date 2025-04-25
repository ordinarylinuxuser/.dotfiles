read -p "Client: " client
VIVA_RDPW_LOCATION="VivaVm.rdpw"
OTR_RDPW_LOCATION="OTRVm.rdpw"
if [ "$client" = "viva" ]; then
    xfreerdp $VIVA_RDPW_LOCATION /gateway:type:arm /sec:aad /floatbar /f +auto-reconnect +dynamic-resolution
fi

if [ "$client" = "otr" ]; then
    read -p "User:" user
    read -s -p "Password:" pass
    xfreerdp $OTR_RDPW_LOCATION /gateway:type:arm /u:$user /p:$pass /d:peregrine.local /sec:tls /cert:ignore /floatbar /f +auto-reconnect +dynamic-resolution
fi
