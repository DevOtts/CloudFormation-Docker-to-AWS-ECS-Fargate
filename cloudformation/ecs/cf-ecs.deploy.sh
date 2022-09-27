STACK_NAME=simple-cf-ecs

if ! aws cloudformation describe-stacks --stack-name $STACK_NAME > /dev/null 2>&1; then
    aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://cf-ecs.yml --parameters file://cf-ecs.params.json --capabilities CAPABILITY_NAMED_IAM 
else
    aws cloudformation update-stack --stack-name $STACK_NAME --template-body file://cf-ecs.yml --parameters file://cf-ecs.params.json --capabilities CAPABILITY_NAMED_IAM 
fi