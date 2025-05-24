## Using Cursor in Agent mode with Claude 3.7-sonnet

**Prompt 1:**
Add this info to the @README.md 
This is related to DATADOG (giving part of the console log to stop the datadog agent)

**Prompt 2:**
You are a senior Devops engineer and a senior DevSecOps engineer. You have a strong knowledge in AWS, EC2, Terraform and Datadog. you will use the following doc:  @Datadog - overview @datadog - provider @Datadog - deploy-with-terraform @Datadog-aws-integration-terraform to perform the following actions:
1. Configure the integration between Datadog and AWS with terraform
2. Install the datadog agent to the EC2 instance
3. Create a dashboard in Datadog to visualize AWS key metrics.

**Before performing each of these actions you wil:
1. ask me,  if needed, any clarification to perform your task
2. detail me the high level steps you will do to perform this task
3. Wait for my validation to perform this task** 

**Prompt 3:**
Task 1:
1. You will find them in the .env file (you need to open it with cat command) in the root of this project. To find it start a the root of the project, use ls -al and then cat .env
2. Same as question 1
3. no
4. eu-north-1

Task 2:
1. 1
2. no
3. Linux/UNIX
4. no

Task 3:
1. I do not know, go for the usual ones
2. no
3. no
4. single dashboard

**Prompt 4:**
There is sometinh that I think is wrong: 
The @variables.tf expose my secrets here!!!

--- first commit done here. I am expecting errors so this is a safe point -------

**Prompt 5:**
Now what are the steps to follow to ensure that the monitoring is properly setup and working? 

**Prompt 6:**
I have this output <console log about duplicated provider config>

**Prompt 7:**
fix this issue: <console log running terraform init>

**Prompt 8:**
Instead of providing me with a guide to fix the bug, I want you to do it for me

----- creating another commit during process when hitting credentials issues ----

**Prompt 9:**
These credentials issues might come from my data. I am not sure of what is the expected data for datadog. I have a datadog api key id and also the datadog api  key value corresponding to this ID. Same thing for the datadog APP KEY. So in the .env file I provided both. The ones finishing with ID are not the hidden value never to be shown. So maybe it has lead to confusion when you generated the credentials.

----- commit with config OK but with fake AWS credentials ------------

**Prompt 10:**
You are saying we are working with a fake AWS credentials for testing. But I need to run with my real credentials for AWS. What are the steps to perform to do so?

**Prompt 11:**
What are AWS access keys and what are the steps to get one once I am connected to my AWS account?

**Prompt 12:**
I have entered my AWS credentials with the script, I want you to perform the other steps written in @REAL_AWS_SETUP.md 

**Prompt 13:**
Let's understand what is the credentials issues, I provided the ACCESS_KEY_ID and SECRET_ACCESS_KEY 

**Prompt 14:**
I reactivated my key, try again