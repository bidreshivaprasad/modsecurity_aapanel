#!/bin/bash
sudo yum update -y
cd /opt
wget https://www.modsecurity.org/tarball/2.9.1/modsecurity-2.9.1.tar.gz
tar xzf modsecurity-2.9.1.tar.gz
rm -f modsecurity-2.9.1.tar.gz
cd modsecurity-2.9.1
./configure --with-apxs=/www/server/apache/bin/apxs --with-apr=/www/server/apache/bin/apr-1-config --with-apu=/www/server/apache/bin/apu-1-config
make
make install
ln -s /usr/local/modsecurity/lib/mod_security2.so /www/server/apache/modules/
mkdir /www/server/apache/modsecurity.d
cd /www/server/apache/modsecurity.d
wget https://github.com/coreruleset/coreruleset/archive/v3.3.0.tar.gz
tar xzf v3.3.0.tar.gz
rm -f v3.3.0.tar.gz
mv coreruleset-3.3.0 owasp-modsecurity-crs
cd owasp-modsecurity-crs
mv rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
mv rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
cd /opt/modsecurity-2.9.1
curl -sL https://raw.githubusercontent.com/danihidayatx/modsecurity_aapanel/main/modsecurity.conf -o modsecurity.conf && rm -f modsecurity.conf-recommended
echo "" >> /www/server/apache/conf/httpd.conf
cd /www/server/apache/conf/
curl https://raw.githubusercontent.com/danihidayatx/modsecurity_aapanel/main/httpd_conf.settings >> httpd.conf
service httpd restart && echo "Installation Complete!"
