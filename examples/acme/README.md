# How To Configure Bootstrap

For a working example see the [acme example](main.tf). 

You can run the follwing commands inside the docker container produced by the release of this repo.  Run the image with the following command (which will mount your ~/.aws/credentials into the docker container):

docker run -it -v ~/.aws:/root/.aws ghcr.io/mojaloop/iac-aws-bootstrap:currentver

You need to create the backend.hcl file by using the [iac-aws-backend repo](https://github.com/mojaloop/iac-aws-backend) and setting the appropriate variables when prompted.

Copy the backend.hcl file into the same dir as the primary main.tf file.  

Edit the main.tf file to set the version of the bootstrap iac in the module call, the appropriate domain variable (base domain) and the tenancy variable.  This will create a zone for tenancy.domain so you will have hosts with FQDNs such as gitlab.tenancy.domain and wireguard.tenancy.domain, etc.

You can also change the number of zones to use if you wish to have the switch create worker nodes in different zones and have the load balancers balance accross those different zones.  Or leave it at 1 and everything will be in the same zone.

You need to create an IAM group that has administator access and that group name must be set here:

iac_group_name = ....

After you finish modifying the settings in main.tf you will need to run the following commands:

1. export AWS_PROFILE=profilename
2. terraform init --backend-config=backend.hcl
3. terraform apply -var-file=backend.hcl
4. cd post-config
5. terraform init --backend-config=../backend.hcl
6. terraform apply -var-file=../backend.hcl

Now you can log in to gitlab.tenancy.domain using root and the result of running this command from the main directory:

terraform output gitlab_root_pw

Use google authenticator or other appropriate app to configure MFA on gitlab for the root user.

To destroy, go to main dir and type:
1. terraform init --backend-config=backend.hcl
2. terraform destroy -var-file=backend.hcl