AWS Cloud Resume Challenge

blog: 

The github actions file in this repo (front-end-cicd.yml) carries out a workflow with a series of actions.
Actions are the following:
Uploads the contents of the website folder in this repo (index.html and index.js) to AWS S3 Bucket. There is caching using AWS Cloudfront.
The bucket acts a static website that shows the number of times the page has been visited. 
The website javascript code executes a lambda function that retrieves the view count from a AWS DynamoDB table and also increments it by 1 on each page load.

More info here:
https://cloudresumechallenge.dev/docs/the-challenge/aws/

Future improvements:
Implementing Github Actions workflow (.github/workflows/terraform.yml currently not working) that creates the dynamodb table, lambda function, s3 bucket and other cloud infrastructure instead of creating it from Terraform on my laptop.
Adding Testing for the lambda function, javascript code and other files.
