# docker-bastillion
Docker image for [Bastillion.io](https://www.bastillion.io/)

## What is Bastillion?

Bastillion is an open-source web-based SSH console that centrally manages administrative access to systems.

A bastion host for administrators with features that promote infrastructure security, including key management and auditing.

For more information visit the [Bastillion website](https://www.bastillion.io/) or the [GitHub page](https://github.com/bastillion-io/Bastillion)

## Quick start

Create a directory where you want to store the Bastillion data: 

`mkdir keydb/`

Docker-Bastillion runs as user 1001. Not as root. You must change ownership of the keydb directory to 1001. Chown the directory to 1001: 

`chown -R 1001:1001 keydb/`

Run the docker image. The below example runs the image detached. Update the path to the keydb directory as required: 

`
sudo docker run -d -p 8080:8080 -p 8443:8443 -v /PATH/TO/keydb:/opt/bastillion/jetty/bastillion/WEB-INF/classes/keydb ecosi/bastillion
`

## Persistent storage
_Currently not configurable using environment (need confirmation)_

This means that any volume must be mounted to the following path in the container: `/opt/bastillion/jetty/bastillion/WEB-INF/classes/keydb`

## Environment
_Dockerize is used to generate a configuration file for the application_

* **set to true to regenerate and import SSH keys**

   `RESET_APPLICATION_SSH_KEY` 

   _Default: "false"_


* **SSH key type 'dsa', 'rsa', or 'ecdsa' for generated keys**

   `SSH_KEY_TYPE` 

   Default: "rsa"


* **SSH key length for generated keys**

   2048 => 'rsa','dsa'; 521 => 'ecdsa'
   
   `SSH_KEY_LENGTH` 
   
   _Default: "2048"_

* **private ssh key**
   Provide **path** to private keyfile

   leave blank to generate key pair

   `SSH_PRIVATE_KEY` 

   _Default: ""_


* **public ssh key**
   Provide **path** to public keyfile

   leave blank to generate key pair

   `SSH_PUBLIC_KEY` 

   _Default: ""_

* **default passphrase** 

   leave blank for key without passphrase

   `defaultSSHPassphrase=${randomPassphrase}` 


* **enable audit**

   `ENABLE_INTERNAL_AUDIT`

   _Default: "false"_


* **keep audit logs for in days**

   `DELETE_AUDIT_LOG_AFTER`

   _Default:  "90"_

* **The number of seconds that the client will wait before sending a null packet to the server to keep the connection alive**

   `SERVER_ALIVE_INTERVAL` 

   _Default: "60"_


* **enable SSH agent forwarding**

   `AGENT_FORWARDING` 

   _Default: "false"_

* **enable two-factor authentication with a one-time password**

   'required', 'optional', or 'disabled'

   `ONE_TIME_PASSWORD` 

   _Default: "optional"_

* **set to false to disable key management**
   
   If false, the Bastillion public key will be appended to the authorized_keys file (instead of it being overwritten completely).
   
   `KEY_MANAGEMENT_ENABLED`
   
   _Default: "true"_

* **set to true to generate keys when added/managed by users and enforce strong passphrases set to false to allow users to set their own public key**

   `FORCE_USER_KEY_GENERATION` 

   _Default: "true"_

* **authorized_keys refresh interval in minutes**
   
   (no refresh for <=0)
   
   `AUTH_KEYS_REFRESH_INTERVAL` 
   
   _Default: "120"_


* **HTTP header to identify client IP Address**
  
  ('X-FORWARDED-FOR')
  
  `CLIENT_IP_HEADER` 

* **The session time out value of application in minutes**

   `SESSION_TIMEOUT`
   
   _Default: "15"_

#### Database and connection pool settings

* **Database user**

   `DB_USER` 
   
   _Default: "bastillion"_

* **Database password**

   `DB_PASSWORD`

* **Connection URL to the DB**

   `DB_CONNECTION_URL` 

   _Default: "jdbc:h2:keydb/bastillion;CIPHER=AES"_
