#!/bin/bash

time_req=10 #put Time in Minute
a=60 #time for 1 minute
b=10 #for every 10 sec
val=`expr $time_req \* $a`
final_time=`expr $val / $b` #final_time 

#deploy_state=$(aws ecs describe-services --cluster $CLUSTER_NAME --services $SERVICE_NAME | jq -r '.services[].deployments[0]' | grep -w "rolloutState" | awk -F":" '{ print $2 }' | tr -d '"')
#deploy=$(aws ecs describe-services --cluster $CLUSTER_NAME --services $SERVICE_NAME | jq -r '.services[].deployments[0]')


#Starting of While Loop
count=0
while [ $count -lt $final_time ]
do
deploy_state=$(aws ecs describe-services --cluster $CLUSTER_NAME --services $SERVICE_NAME | jq -r '.services[].deployments[0]' | grep -w "rolloutState" | awk -F":" '{ print $2 }' | tr -d '"')
deploy=$(aws ecs describe-services --cluster $CLUSTER_NAME --services $SERVICE_NAME | jq -r '.services[].deployments[0]')
if [ $deploy_state == "COMPLETED," ]
then
        echo "Deployment SucessFull"
        echo "$deploy_state"
        echo "$deploy"
        break
fi
echo "Sleep for 10 Sec"
sleep 10
echo "$deploy_state"
count=`expr $count + 1`
done
#End of While loop



if [ $count -eq $final_time ]
then
        echo "Time Out"
        exit 1
fi
