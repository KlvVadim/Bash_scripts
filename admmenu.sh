
#!/bin/bash
#demo script of administration menu

echo 'Select a task: '
select TASK in 'Check mounts' 'Check disk space' 'check Memory usage'

do
  
	case $REPLY in
		1) TASK=mount;;
		2) TASK="df -h";;
		3) TASK="free -m";;
		*) echo ERROR && exit 2;;
	esac
        if [ -n "$TASK" ]
	then
		clear
		$TASK
		break
	else
	      echo invalid choice && exit 3
	fi

done

