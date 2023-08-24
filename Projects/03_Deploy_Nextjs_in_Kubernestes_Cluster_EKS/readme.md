# DevOps Project: EKS Cluster Deployment with CI/CD

This project aims to demonstrate the process of building an Amazon Elastic Kubernetes Service (EKS) cluster, deploying pods using Kubernetes Deployments, setting up a LoadBalancer for accessing pods, and implementing Continuous Integration and Continuous Deployment (CI/CD) using GitHub Actions.

## Project Structure

-   `github_actions_cicd.yaml`: GitHub Actions workflow configuration for CI/CD.
-   `kubernetes/`: Contains Kubernetes manifests for deploying pods and services.
    -   `deployment.yaml`: Kubernetes Deployment configuration for pods.
    -   `service-lb.yaml`: Kubernetes Service configuration for LoadBalancer.
-   `README.md` (this file): Provides an overview of the project and instructions.
-  `eks-cluster.yaml`: Create the kubernetes cluster in AWS EKS.

## CI/CD Workflow

The CI/CD workflow is automated using GitHub Actions. It triggers on every commit to the repository, builds a Docker image of the application, and deploys it to the EKS cluster.

## Steps to Configure AWS, Install kubectl and eksctl, and Create EKS Cluster

1.  **Configure AWS:**
    
    -   Install the AWS Command Line Interface (CLI) and configure it with your AWS credentials.
    -   Run `aws configure` and provide your AWS Access Key ID, Secret Access Key, default region, and output format.
2.  **Install kubectl:**
    
    -   Kubectl is a command-line tool used to interact with Kubernetes clusters.
    -   Install kubectl by following the instructions for your specific operating system: [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
3.  **Install eksctl:**
    
    -   Eksctl is a command-line tool for creating and managing EKS clusters.
    -   Install eksctl by following the instructions here: [Installing eksctl](https://eksctl.io/introduction/installation/).
4.  **Create EKS Cluster using eksctl:**
  
    -   Run the following command to create the EKS cluster:
        
        
        `eksctl create cluster -f eks-cluster.yaml` 
        
 5.  **Create Kubernetes Resources:**
		
		- Create Deployment resource by running:
			`kubectl  apply -f ./kubernetes/deployment.yaml`
			
			that will create 4 pods with **env:testing** lable
		- Create LoadBalancer Service by running:
			`kubectl apply -f ./kubernetes/service-lb.yaml`
				
			that will provide the external IP through which we can access our pods, 			Also manage the traffic on all pods.

5. **Setup CICD Pipeline Using Github Actions:**

		
	- Add  AWS, Docker Hub and KubeConfig file to your repo secrets.
	-  Add the file `github-actions-cicd.yaml` to your workflow and setup according to your branch




## Usage

1.  Commit your application code and changes to the repository.
    
2.  GitHub Actions will automatically trigger the workflow defined in `.github/workflows/github-action-cicd.yml`.
    
3.  The workflow will build a Docker image of your application, push it to a container registry, and update the Kubernetes Deployment.
    
4.  The LoadBalancer service will distribute traffic to the pods.
    

## Follow Me 🌐

-   Connect with me on [LinkedIn](https://www.linkedin.com/in/aslamsarfraz)
-   Visit my personal website: [https://www.aslamsarfraz.com](https://www.aslamsarfraz.vercel.app/)

## Tutorial Video 🎥

For a detailed walkthrough of the project setup and deployment process, check out the tutorial video on YouTube:

[![Tutorial Video](https://i9.ytimg.com/vi_webp/R_dS7YH6F3A/mq1.webp?sqp=CKTbnKcG-oaymwEmCMACELQB8quKqQMa8AEB-AH-CIAC0AWKAgwIABABGE4gYShlMA8=&rs=AOn4CLDwDfe-M8VnBgPNshNIdp2mTG4z1w)](https://youtu.be/R_dS7YH6F3A?feature=shared)

In this video, you'll find step-by-step instructions, explanations, and visual demonstrations of each stage of the project.

Feel free to like, subscribe, and leave any comments or questions on the video!