1.	Create a microservice serving REST API with GET calls returning 100jokes starting from the newest from  bash.org.pl  in JSON format.

2.	Prepare code for an Amazon EKS Cluster creation using Terraform.

3.	Prepare code that creates necessary kubernetes objects to run the created service inside a kubernetes cluster.
It may be done with simple manifests but using Kustomize will result in bonus
points.

4.	Prepare an on-demand deployment of the created application to the cluster inside Github Actions, based on a branch choice.

5.	Create a helm chart for the created application deployment.
