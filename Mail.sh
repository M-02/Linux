#!/usr/bin
yum install -y mailx
mkdir -p /root/.certs
echo "# mail config
set from=#############                         #你的电子邮件地址 
set smtp=smtps://smtp.163.com:465  
set smtp-auth-user=###############             #你的电子邮件地址 
set smtp-auth-password=#############           #你的电子邮件密码
set smtp-auth=login 
set nss-config-dir=/root/.certs  
set ssl-verify=ignore " >>/etc/mail.rc
echo -n | openssl s_client -connect smtp.163.com:465 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ~/.certs/163.crt
certutil -A -n "GeoTrust SSL CA" -t "C,," -d ~/.certs -i ~/.certs/163.crt
certutil -A -n "GeoTrust Global CA" -t "C,," -d ~/.certs -i ~/.certs/163.crt
cd /root/.certs/
certutil -A -n "GeoTrust SSL CA - G3" -t "Pu,Pu,Pu" -d ./ -i 163.crt
echo "hello" | mail -v -s "this is Test Mail" ################    #你想要发送测试邮件的电子邮箱地址。
