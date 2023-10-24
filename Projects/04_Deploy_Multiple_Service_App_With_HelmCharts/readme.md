# Campus-Hub Deployment on Kubernetes with Helm

Welcome to our project repository! Here, you'll find everything you need to deploy a modern MERN stack application on a Kubernetes cluster using Helm charts. Our application is composed of three core components: a frontend, a backend, and a Redis cache.

The main objective of this project is to harness the power of Redis caching. We've designed the system to optimize data retrieval and storage. How does it work? Well, your application fetches data from MongoDB, but instead of hitting the database every time, it stores frequently accessed data in Redis. This not only saves network traffic but also dramatically speeds up data retrieval, making your application lightning-fast.

But that's not all – we've also set up this system to support multiple services. This means you can run a variety of services within the same application. Whether you're building a blog, an e-commerce platform, or a social networking site, our setup can handle it all.

So, dive into our repository and unlock the potential of efficient data management and versatile service deployment with our MERN stack application on Kubernetes using Helm charts. Happy coding!

## Prerequisites

Before getting started, make sure you have the following prerequisites installed on your local machine:

- [Docker](https://www.docker.com/get-started)
- [Kubernetes](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [Helm Charts (Tiller) installed in your Kubernetes cluster](https://helm.sh/docs/using_helm/#installing-tiller)

## Application Structure

- `frontend/`: The Next.js frontend application.
- `backend/`: The Node.js and Express.js backend application.
- `redis/`: The Redis cache service.

## Running Up Campus-Hub Resources

If you haven't already installed Helm, follow these steps:

1. Download Helm from the Helm GitHub releases page:
https://github.com/helm/helm/releases
2. Run Resources with Helm Charts
```
cd 04_Deploy_Multiple_Service_App_With_HelmCharts/
helm install campus-hub .
```