set -e

adduser --system --shell /sbin/nologin --user-group --no-create-home www-data

mkdir -p /var/lib/nginx
mkdir -p /var/lock
mkdir -p /run

mkdir -p /opt/nginx && cd /opt/nginx
yum update -y
yum install zlib-devel -y
yum groupinstall -y 'Development Tools'
yum install -y vim wget GeoIP-devel


wget http://nginx.org/download/nginx-1.21.6.tar.gz && tar -xzf nginx-1.21.6.tar.gz
wget https://ftp.exim.org/pub/pcre/pcre-8.45.tar.gz && tar -xzf pcre-8.45.tar.gz
wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz && tar -xzf openssl-1.1.1d.tar.gz
wget https://zlib.net/fossils/zlib-1.2.12.tar.gz && tar -xzvf zlib-1.2.12.tar.gz
wget https://github.com/ivmai/libatomic_ops/releases/download/v7.2i/libatomic_ops-7.2i.tar.gz && tar -xzf libatomic_ops-7.2i.tar.gz

git clone https://github.com/vozlt/nginx-module-vts.git

cd nginx-1.21.6

./configure \
--prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--modules-path=/etc/nginx/modules \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--lock-path=/var/lock/nginx.lock \
--pid-path=/run/nginx.pid \
--user=www-data \
--group=www-data \
--http-client-body-temp-path=/var/lib/nginx/body \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-proxy-temp-path=/var/lib/nginx/proxy \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
--without-http_scgi_module \
--without-http_autoindex_module \
--without-http_browser_module \
--without-http_ssi_module \
--without-mail_pop3_module \
--without-mail_smtp_module \
--without-mail_imap_module \
--with-pcre-jit \
--with-openssl=../openssl-1.1.1d \
--with-pcre=../pcre-8.45 \
--with-zlib=../zlib-1.2.12 \
--with-http_auth_request_module \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_sub_module \
--with-http_gzip_static_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_geoip_module \
--with-libatomic=../libatomic_ops-7.2 \
--with-file-aio \
--with-http_v2_module \
--with-stream \
--with-stream_ssl_module \
--with-threads \
--add-module=../nginx-module-vts

make
make install

update-alternatives --install /usr/bin/nginx nginx /etc/nginx/sbin/nginx 1

rm -rf /opt/*
