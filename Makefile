TERRAFORM = terraform

#Add a region variable
create-cluster:
	@echo "creating cluster "

	cd ./cluster-generation
	${TERRAFORM} plan
