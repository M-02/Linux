#!/usr/bin/bash
#cent OS自动配置163邮箱并发送测试邮件
read -p "输入你的邮件地址:" add1
read -p "输入你的邮件密码:" password
yum install -y mailx
mkdir -p /root/.certs
echo "# mail config
set from=$add1
set smtp=smtps://smtp.163.com:465  
set smtp-auth-user=$add1
set smtp-auth-password=$password 
set smtp-auth=login 
set nss-config-dir=/root/.certs  
set ssl-verify=ignore " >>/etc/mail.rc
echo -n | openssl s_client -connect smtp.163.com:465 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ~/.certs/163.crt
certutil -A -n "GeoTrust SSL CA" -t "C,," -d ~/.certs -i ~/.certs/163.crt
certutil -A -n "GeoTrust Global CA" -t "C,," -d ~/.certs -i ~/.certs/163.crt
cd /root/.certs/
certutil -A -n "GeoTrust SSL CA - G3" -t "Pu,Pu,Pu" -d ./ -i 163.crt
read -p "输入你想发送的收件人:" add2
read -p "输入你想发送的信息标题:" title
read -p "输入你想发送的信息:" message
echo $message | mail -v -s $title $add2
