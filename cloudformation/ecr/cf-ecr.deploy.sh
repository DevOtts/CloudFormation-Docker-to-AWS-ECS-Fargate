STACK_NAME=simple-cf-ecr

if ! aws cloudformation describe-stacks --stack-name $STACK_NAME > /dev/null 2>&1; then
    aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://cf-ecr.yml --parameters file://cf-ecr.params.json --capabilities CAPABILITY_NAMED_IAM 
else
    aws cloudformation update-stack --stack-name $STACK_NAME --template-body file://cf-ecr.yml --parameters file://cf-ecr.params.json --capabilities CAPABILITY_NAMED_IAM 
fi