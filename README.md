# terraform-aws-kubernetes

NOTE: This project is work in progress, based on:

[github.com/dwmkerr/terraform-aws-openshift](https://github.com/dwmkerr/terraform-aws-openshift)

This project shows you how to set up a Kubernetes cluster on AWS using Terraform and Ansible.


<!-- vim-markdown-toc GFM -->

* [Introduction / Design Goals](#introduction--design-goals)

<!-- vim-markdown-toc -->

## Introduction / Design Goals

Why would you manually create a Kubernetes Cluster on AWS, rather than using a managed service like AKS?

In general, I would recommend a managed service in many cases. However, you might want to perform significant customisations, try features which are not available in managed services, or have more control over configuration.

Another reason I sometimes manually build clusters to create a cluster on the Cloud in an environment which more closes matches a data center which I will later create a cluster on, to allow me to develop a more accurate sense of scaling, network configuration, ingress patterns and so on, without having to experiment on the on-premises hardware (which is often more difficult and time consuming to change and work with).
