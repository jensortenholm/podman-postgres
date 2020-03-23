export LD_PRELOAD='/usr/lib64/libnss_wrapper.so'
export NSS_WRAPPER_PASSWD="$(mktemp)"
export NSS_WRAPPER_GROUP="$(mktemp)"
echo "postgres:x:$(id -u):$(id -g):PostgreSQL:/var/lib/pgsql/data:/bin/false" > "$NSS_WRAPPER_PASSWD"
echo "postgres:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
