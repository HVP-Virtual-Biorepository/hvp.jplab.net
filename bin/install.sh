
apt-get update

ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
apt-get install -y apache2 libapache2-mod-r-base mysql-server libcurl4-openssl-dev

a2dissite 000-default
a2enmod md
a2enmod ssl

git clone https://github.com/HVP-Virtual-Biorepository/hvp.jplab.net.git /var/www/hvp
ln -s /var/www/hvp/config/httpd.conf /etc/apache2/sites-enabled/hvp.conf
mysql -u root < /var/www/hvp/config/database.sql
Rscript --vanilla /var/www/hvp/config/packages.r

systemctl restart apache2
