# ARN of StepFunction

#!/bin/bash

state_machine_arn="PutTheARN_StepFunctionHere"

# Check if at least two arguments are provided

	if [ "$#" -lt 2 ]; then
		echo "Usage: $0 <start_date> <end_date>"
		exit 1
	fi

# Loop through each day in the range

start_date=$(date -d "$1" "+%Y%m%d")
end_date=$(date -d "$2" "+%Y%m%d")

	current_date="$start_date"
		while [ "$current_date" -le "$end_date" ]; do
			formatted_date=$(date -d "$current_date" "+%d%m%Y")

# Construct the payload

			payload='{
				"day": "'$(expr "$formatted_date" : '\(..\)')'",
				"month": "'$(expr "$formatted_date" : '..\(..\)')'",      
				"year": "'$(expr "$formatted_date" : '....\(....\)')'"
					}'

# Start the execution

execution_arn=$(aws stepfunctions start-execution --state-machine-arn "$state_machine_arn" --input "$payload" --query 'executionArn' --output text)     

		echo "Started Step Function execution for $formatted_date with ARN: $execution_arn"

# Move to the next day

	current_date=$(date -d "$current_date + 1 day" "+%Y%m%d")
		done
