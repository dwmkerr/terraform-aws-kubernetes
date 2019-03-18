infrastructure:
	# Get the modules, create the infrastructure.
	terraform init && terraform get && terraform apply -auto-approve

# Installs Kubernetes on the cluster.
kubernetes:
	# Add our identity for ssh, add the host key to avoid having to accept the
	# the host key manually. Also add the identity of each node to the bastion.
	ssh-add ~/.ssh/id_rsa
	ssh-keyscan -t rsa -H $$(terraform output bastion-public_ip) >> ~/.ssh/known_hosts

	# Copy our inventory to the master and run the install script.
	scp -r ./inventory ubuntu@$$(terraform output bastion-public_ip):~
	cat install-from-bastion.sh | ssh -o StrictHostKeyChecking=no -A ubuntu@$$(terraform output bastion-public_ip)

# Destroy the infrastructure.
destroy:
	terraform init && terraform destroy -auto-approve

# SSH onto the bastion.
ssh-bastion:
	ssh -t -A ubuntu@$$(terraform output bastion-public_ip)

# Lint the terraform files. Don't forget to provide the 'region' var, as it is
# not provided by default. Error on issues, suitable for CI.
lint:
	terraform get
	TF_VAR_region="us-east-1" tflint --error-with-issues

# Run the CircleCI build locally.
circleci:
	circleci config validate -c .circleci/config.yml
	circleci build --job lint
