#!/bin/bash

script_folder=/home/morta/monitoring/

STORAGE_LIMIT=50

storage_alarm_state=0

storage_check(){
    current_date=$(date)
    for mnt_path in $MOUNTPATHS; do
        findmnt $mnt_path > /dev/null 2>&1
       	echo $mnt_path
	 
        if [[ $? -ne 0 ]]; then
            echo "$current_date | $mnt_path path not exist" >> $script_folder/storage.log
        else
            storage_used_percentage=$(df -h | grep $mnt_path | awk '{ print $(NF-1)}' | tr -d '%')
	    echo $storage_used_percentage
            if [[ $storage_used_percentage -ge 40 ]]; then
		    echo "alarm"
		    message="🔥️️️️🔥️️️️ Alert 🔥️️️️🔥️️️️ %0A%0AHostname: ${HOSTNAME} %0A%0AStorage is almost full please check: ${storage_used_percentage}%"
		    curl -s -X POST https://api.telegram.org/bot${BOT_TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d text="alarm"  > /dev/null 2>&1
		    storage_alarm_state=1
            fi
            if [[ $storage_used_percentage -lt $STORAGE_LIMIT && $storage_alarm_state -eq 1 ]]; then
                echo "${$storage_used_percentage} katta 50 % dan"
				message="✅️️✅️️ Resolved ✅️️✅️️%0A%0AHostname: ${HOSTNAME} %0A%0AMountpath: $mnt_path %0A%0AUsed: ${storage_used_percentage}%"
                curl -s -X POST https://api.telegram.org/bot${BOT_TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d "text=${message}" > /dev/null 2>&1
                storage_alarm_state=0
	    fi    
        fi
    done
}

storage_check
