#!/bin/bash +x
#laser focus group
#this script is training ground for members of the group

#verify if you are root user 

IDENTIFICATION=$(id  | awk -F "(" '{print $2}'|  awk -F ")" '{print $1}'
)

if 
	[[ "${IDENTIFICATION}" == root ]]
then
echo "you are ROOT"
else
echo "Error you don't have proper credentials to run this script"
exit 1
fi

sleep 2
#verify which  OS and version is running 
OS=$(cat /etc/*release |grep ubuntu | head -1|awk -F "=" '{print $2}')
VERSION=$(cat /etc/*release | grep -i  version | head -1 | awk -F=  '{print $2}' | awk -F "LTS"  '{print $1}'>file222 && sed -i 's/"/laser=/g' file222 && awk -F= '{print $2}' file222)

echo "You are running a(n) $OS server with release version $VERSION"
#creating a user
echo 'enter the user name: ' 
read USERNAME
echo 'enter the user first name: '
read FIRSTNAME
echo 'enter the user last name: '
read LASTNAME
echo 'enter the last your DOB with only number: '
read DATEOFBIRTH
 sleep 2
 echo 'checking for a macth user'

id $USERNAME &> /dev/null
if 
	[[ "${?}" -eq 0 ]]
then 
	echo "user $USERNAME  already exist"
else
echo 'creating user $USERNAME with home directory'
useradd -m -d /home/$USERNAME  -c "${FIRSTNAME} ${LASTNAME} " -u $DATEOFBIRTH  $USERNAME
sleep 2

if 
       	[[ "${?}" -eq 0 ]]
then 
	echo 'the user has been added successfully'
else
	echo 'ERROR the user has not been created'
 exit 1
fi 
fi 
sleep 2
echo 'adding groups'
groupadd linuxstudent  && groupadd devopsteam

# verify if firewall and sshd are up and running
echo 'checking the status  sshd'
sleep 2
echo 'checking if sshd is installed'
ssh -V &> /dev/null
if 
[[ "${?}" -eq 0 ]]
then 
systemctl  start sshd 
else
echo 'sshd is not installed'
echo 'installing sshd'
if [[ "${OS}" == ubuntu ]]
 then
	 apt install -y openssh-server
echo 'starting sshd'
systemctl  start sshd 
sleep 2
echo 'sshd is up and running'

elif
	[[ "${OS}" == centos ]]
then 
yum  install -y openssh-server
echo 'starting sshd'
systemctl  start sshd && systemctl enable sshd
sleep 2
echo 'sshd is up and running'

fi
fi


# checking and installing apache
echo 'checking if apache is installing'

httpd -V &> /dev/null
apache2  -V &> /dev/null


                    if [[ "${OS}" == ubuntu ]]
                     then
                     apache2  -V &> /dev/null
 if
  [[ "${?}" -eq 0 ]]
  then
    echo 'apache is installed'
    systemctl start apache2
else
	echo 'apache is not install'
	echo 'installing apache'
	apt install -y apache2  
	echo 'starting apache'
	systemctl start apache2
	echo 'apache2  is up and running'
fi
                     elif
	              [[ "${OS}" == centos ]]

                     then
                     httpd   -V &> /dev/null
 if
  [[ "${?}" -eq 0 ]]
  then
    echo 'httpd  is installed'
    systemctl start httpd
else
        echo 'httpd  is not install'
        echo 'installing httpd'
        yum   install -y httpd  
        echo 'starting apache'
        systemctl start httpd
	echo 'httpd is up and running'
 fi


		     fi 
# opening ports


                    if [[ "${OS}" == ubuntu ]]
                     then
		     apt upgrade -y ufw 
                     

 if
  [[ "${?}" -eq 0 ]]
  then
    echo 'ufw  is installed'
    systemctl start ufw
    systemctl enable ufw  
     sleep 2
        echo 'opening  ports'
        ufw allow 8000:9000/tcp &> /dev/null
        ufw allow 70:100/tcp    &> /dev/null
	 echo 'ports have been enabled'


else
        echo 'ufw  is not install'
        echo 'installing ufw'
        apt install -y ufw   
        echo 'starting ufw'
        systemctl start ufw
	systemctl enable ufw  
        echo 'ufw is up and running'
	sleep 2
	echo 'opening  ports'
	ufw allow 8000:9000/tcp &> /dev/null
	ufw allow 70:100/tcp    &> /dev/null
	echo 'ports have been enabled'
fi

                        elif
                      [[ "${OS}" == centos ]]
                     then
                     yum  upgrade -y firewalld  


if
  [[ "${?}" -eq 0 ]]
  then
    echo 'firewalld  is installed'
    systemctl start firewalld
    systemctl enable firewalld 
     sleep 2
        echo 'opening  ports'
        firewall-cmd --add-port=7000-9000/udp --permanent 
        firewall-cmd --add-port=70-80/udp --permanent    
         echo 'ports have been enabled'


else
        echo 'firewall   is not install'
        echo 'installing firewall'
        apt install -y ufw  
        echo 'starting firewall'
        systemctl start firewalld
        systemctl enable firewalld  
        echo 'ufw is up and running'
        sleep 2
        echo 'opening  ports'
        firewall-cmd --add-port=7000-9000/tcp --permanent 
        firewall-cmd --add-port=70-80/tcp --permanent   
         echo 'ports have been enabled'

       
fi
		    fi


#addign user
sleep 3
echo "adding $USERNAME to groups"
usermod -aG devopsteam    $USERNAME
usermod -g  linuxstudent   $USERNAME 
sleep 2
echo 'user $USERNAME added to groups devopsteam  and linuxstudent'
sleep 2
echo "generating a password"
PASSWD=abc123
echo 'done'
sleep 2 
echo 'assigning password to user $USERNAME'
echo $USERNAME:$PASSWD | chpasswd
sleep 2
echo 'status: DONE' 



#docker
echo 'cleaning docker environment'

echo 'stopping all running containers'
docker stop $(docker ps -aq) &> /dev/null
echo "successfull"
echo 'removing all containers'
docker rm -f  $(docker ps -aq) &> /dev/null
docker rmi -f  $(docker images -aq) &> /dev/null


echo 'creating a dockerfile'
echo 'FROM ubuntu' > Dockerfile
echo 'RUN apt update -y' >> Dockerfile




echo 'CMD [ echo valette loves scripting ]'  >> Dockerfile
sleep 3
echo 'building the image'
read -p 'enter your image name: ' IMAGE
docker build -t $IMAGE .

echo 'checking if the image has been built'
docker images | grep -i $IMAGE

               
if
        [[ "${?}" -eq 0 ]]
then
echo "the image has been built with success"
else
echo "Error no matching image availabale"
exit 1
fi

sleep 3
 echo 'Are you ready to build contianers'

read -p 'enter the container name: ' NAME
read -p 'enter the external port: ' PORT1
read -p 'enter the internal port: ' PORT2
read -p 'enter your dockerhub name: ' LOGIN
sleep 3
echo 'generating your container'
docker run -itd --name=$NAME  -p ${PORT1}:${PORT2}  $IMAGE
echo 'here is your container'
docker ps -a | grep $NAME
sleep 2
echo 'tagging the image'
docker tag $IMAGE $LOGIN/$IMAGE
docker push $LOGIN/$IMAGE







