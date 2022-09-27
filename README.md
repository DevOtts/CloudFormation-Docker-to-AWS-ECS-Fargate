# CloudFormation-CodeBuild-Docker-to-AWS-ECS-Fargate
 
In this POC, we'll automatize all the all the infrastructure of creating AWS ECS Resources using CloudFormation.

We already did some steps in the previous video:
1. Create a dotnet project
2. Create a dockerfile
3. Create an image and container in Docket to test.

In last video we also deployed the app in AWS but we had to do this manually using the AWS dashboard.

Now we'll automatize all the resources that we need to create in AWS Dashboard in the previous video using CloudFormation.
What we'll do then:
4. CloudFormation File for us to create a ECR
5. Run the docker command line to:
    4.1. Get our credentials from AWS
    4.2. Send our Image to ECR
6. Create a CloudFormation file with instructions to:
    6.1. Create a Task Definition
    6.2. Create a Cluster on ECS
    6.3. Attach our Task to the Cluster
    6.4. Open the port on EC2 - Security Group
    6.5. Add the Image URI to the Task Definition
8. Voilà

## Watch the previous video on Youtube

[![Watch Step by Step on how to Deploying Docker App to AWS ECS](https://img.youtube.com/vi/vxrO7Vs4EPA/0.jpg)](https://youtu.be/vxrO7Vs4EPA)

## 1 to 3 Steps

The first steps we already did in our [first video](https://youtu.be/vxrO7Vs4EPA).


## 4. Creating and Run CloudFunction file for ECR

Add a ecs.yml where we will specify every resource that we need to create in order to deploy our container.

To create or update the stack in CloudFormation run:
```bash

#to create a new stack
aws cloudformation create-stack --stack-name simple-cf --template-body ecs.yml --parameters 'ParameterKey=SubnetID,ParameterValue=subnet-12345678' --capabilities CAPABILITY_NAMED_IAM 
```

**TIP**: But let's do something a little bit more fancy by adding this code in a .sh file and store the parameters in a different json file.

To pass the parameters via file, we use `--parameters file://my.params.json`:

```bash
#to create a new stack
aws cloudformation create-stack --stack-name simple-cf --template-body file://mycloudformation.yaml --parameters file://my.params.json  --capabilities CAPABILITY_NAMED_IAM 

```

After your .sh created, just run in your terminal
```bash
#to create a new stack
cd ecr/
sh cf-ecr.deploy.sh
```

We should be able to see your Image repository created in ECR AWS dashboard.

## 5. Push Image to ECR

We already have our Docker image created locally from our last video. 
You can find how we do that [reading this README here](https://github.com/DevOtts/dotnet-docker-to-aws-ecs)

So, now we will just have to push our docker image to ECR Repository:
```bash
#tag 
docker tag devotts/simpleapi:latest [AccountId].dkr.ecr.us-east-1.amazonaws.com/simple-cf-repo:latest

#push
docker push [AccountId].dkr.ecr.us-east-1.amazonaws.com/simple-cf-repo:latest
```

## 6. Creating the CloudFunction file for ECS

In the previous video you saw how time consuming is to set all the infrastructure to setup ECS. Imagine if you have to do this for different environments like dev, uat, prod. 

Even worth if you need to delete what you did. How do we make sure that we deleted everything that we had to create?

CloudFormation is here to help us with. Take a look at the `cf-ecs.yml` file and compare with the step-by-step in the [previous video](https://youtu.be/vxrO7Vs4EPA) where we did it all manually. You'll notice that we are doing exactly the same, but now though coding.

We are also using a separated file to store the parms and again using a .sh file to run the aws cloudformation command line.

So, let's run it:
```bash
cd ecs/
sh cf-ecs.deploy.sh
```

This will create the resources above:
- Cluster
- TaskDefinition
- Service
- LogGroup
- SecurityGroup
- IAM Role

You can follow the creation of all these resources in [CloudFormation > Stack](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks).

**Notice** something importante in this yaml file. 

-  To make our code clear and easy to change, we create a PrefixName parameter that let us have a normalize names for all the resources that we create. We use `!Join`to concatenate the string. Take a look at the [documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-join.html)

- We weren'table to use the same port as we did in the previous video, so I kept the port as 5000 without mapping it. You can understand more about this bug that CloudFunction have here in [this issue](https://github.com/aws/aws-cdk/issues/8762). Also the [StackOverflow thread](https://stackoverflow.com/questions/62498346/ecs-taskdefinition-creation-fails-with-error-invalid-containerport).

## Voilà 🎉

Everything is ready! Now go to you Cluster > Tasks and in the details of this task, get the Public IP number and just open in your browser:
```http://the-ip:5000/WeatherForecast ```


## Bonus

- One of the best parts of using CloudFormation is how easy it is to delete all resources. Basically you just have to delete the Stack in CloudFormation. 

Just make sure that you delete the image in ECR before you do that.

- Did you notice that we didn't have to add an Input Rule in Security Group? Other beauty of using this code!

## How can improve it?

After finishing this I'm still not happy because. Some of the questions that I ask myself.

1. How can I automatize the push of our Image to ECR process?

2. CloudFunction is nice, but to be honest, kind of intimidating to have to know all this properties and possible configurations for each resource. Can it be easier?

3. I don't want to have to run everytime the bash commands everytime I make a change in my code. How can I automatize that?

The questions for that is Codebuild, CDK and CodePipeline in this same order, and that will be our improvements in the next videos.
 
