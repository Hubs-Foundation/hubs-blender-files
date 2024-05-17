---
title: "Deploying Mozilla Hubs CE on AWS with Ease: A Guide to the Personal Edition Helm Chart"
slug: deploying-mozilla-hubs-ce-on-aws-with-ease-a-guide-to-the-personal-edition-helm-chart
date_published: 2023-12-27T16:58:38.000Z
date_updated: 2024-02-12T18:17:32.000Z
tags: Advanced, Tutorials
excerpt: In this guide, Alex Griggs shows readers how to deploy his Community Edition Helm Chart: Personal Edition on AWS
---

---

 Welcome! As many of you may already know, Mozilla has launched a successor to Hubs Cloud called [Hubs Community Edition](https://github.com/mozilla/hubs-cloud/tree/master/community-edition) (Hubs CE for short). I was lucky to get into the preview for Hubs CE before the public launch!

 My name is Alex Griggs. I am a Full Stack Software Engineer and have built multiple startups as CTO/CEO with expertise in Kubernetes, cloud computing and AI/ML. 

 In 2021, I started working for a small startup called UtopiaVR as the Lead Developer. They were building some cool tech on top of this new-to-me thing called Mozilla Hubs. The first time I tried the Utopia client, I was hooked, I had always disliked video calls. I went to town ripping apart the Hubs Cloud infrastructure. Within a month or so I had set up a copy of Hubs Cloud on an Ubuntu instance. While at UtopiaVR, I set up and managed multiple Hubs Cloud instances and started modifying everything, deploying our client to many stacks, modifying backend services, etc.

 In this article, we will go over how to prepare and set up a Kubernetes cluster on AWS for a production-ready instance of Hubs CE using the Helm chart! A production-ready instance of Mozilla Hubs CE will consist of a few added services and infrastructure to be ready to host a large event(s), set up custom client pipelines, and persist all user data with persistent volumes and an external database. 

 Now where do I come in with Hubs CE? Well, when I got the preview, I had it up and running on my home lab in a day or so but what Mozilla had and was going to release was a bash script that had many issues which I helped update to get it launched. 

 As I was playing with the scripts and the massive yaml file that their scripts produced, I quickly realized that the community would greatly benefit from a Helm chart. I have set up and managed multiple Kubernetes clusters before and built Helm charts from scratch so I knew I was up to this task. Helm has always been a great tool, it makes installing and updating super easy. So I set out to build the [Hubs CE Helm chart.](https://github.com/hubs-community/mozilla-hubs-ce-chart)

 We are going to go over a lot in this article; the first being how to prepare Elastic Kubernetes Service (Amazon EKS) for the helm deployment(s) and then we will deploy our first Hub CE stack. Bear with me!

## **Introducing Helm!**

[Helm](https://helm.sh/) is a very useful deployment tool for Kubernetes, it allows us to install services and manipulate the environment from a simple-to-read value.yaml file. We will look into these files deeply in the coming article. 

 By modifying the builder files from Community Edition and then creating the Helm charts, I have made each service in the Hubs stack more extensible, scalable and maintainable for the long run. Using a Helm chart to set up Mozilla Hubs CE offers us several advantages over using a complex bash script. Here are a few reasons why we should deploy using the chart:

- **Ease of Use**: Helm charts are like packages or templates that make it easy to install and manage applications on Kubernetes. They package all the necessary components and configurations into a single, easy-to-use format. In contrast, a bash script can be complex, and harder to understand or modify for the end user.
- **Customization and Flexibility**: Helm charts are highly customizable. You can easily change settings or configurations without having to edit the entire script. With a bash script, making changes often requires understanding and modifying the script’s code or templates (yml), which can be error-prone and time-consuming.
- **Consistency and Reliability**: Helm ensures that applications are deployed consistently every time. It manages all the dependencies and configurations, reducing the risk of errors that can happen with manual installations using bash scripts.
- **Version Control and Updates**: Helm charts can be versioned, making it easy to roll back to a previous version if something goes wrong. This is harder to manage with bash scripts, especially if changes are made without proper versioning on our side.
- **Community Support**: This open-sourced Helm chart is developed and maintained by the community. We will try to keep this chart updated regularly and will be free forever.

 I hope that this Helm chart for Mozilla Hubs simplifies the deployment process, makes it easier to manage and customize the stack, and reduces the likelihood of errors compared to using the bash script.

 Are you looking for an easy way to set up a 200+ person event? We have [an article](__GHOST_URL__/deploying-mozilla-hubs-ce-on-aws-with-ease-a-guide-to-the-scale-edition-helm-chart/) and a `value.scale.yaml` file just for you! With a simple set of commands, it scales the Hubs system to the ideal size (customizable) to allow for your event to run smoothly and then downscale it afterwards!

## **Introducing the Mozilla Hubs CE Helm Chart!**

> If you have a Kubernetes cluster or are just playing around on minikube look at the readme in the repo for a quick start. 
> **Source: **[Mozilla Hubs CE Helm Chart](https://github.com/hubs-community/mozilla-hubs-ce-chart)

 Imagine your magic recipe (Helm Chart) for setting up toys but it is a book with different pages, each page having specific instructions or information:

- **`Chart.yaml`:** This is like the cover page of your book. It tells you the name of your magic recipe (Helm Chart), the version of the recipe, and a little description of what kind of toy setup it creates.
- **`Values.yaml`:** Think of this as a page where you can write down your preferences, like choosing the colour of your race track or the size of your castle. In Helm, this file lets you customize your setup without changing the main instructions.
- **`Templates/`**: This is like a collection of magic spells. Each spell (file) in this folder is a specific instruction on how to set up a part of your toy setup. For example, one spell might be for setting up the race track, another for building the castle walls, and so on.
- **`Charts/`**: Sometimes, your magic recipe book might need smaller recipe books to work. This folder contains those smaller books (other Helm Charts) that your main recipe might depend on. In our case, it's the backend services needed to launch the Hubs CE stack.

 Within the Hubs CE chart root directory, we have the Hubs client; The image and tag are in the root values.yaml file. We will go into how to build and deploy a custom client later in this article, once we have a setup chart. But for now, know that all other services are located in the `charts/` directory. We can configure these sub-charts from the main `values.yaml`.

 Okay enough talk, let's get deploying!

## Prerequisites

 First, we need to set up a few dependencies. We need kubectl, eksctl, awscli, helm to install:

**Kubectl**: [Install Tools | Kubernetes](https://kubernetes.io/docs/tasks/tools/)

> kubectl is used to access, configure and admin your Kubernetes clusters from the command line.

**Awscli**: [Command Line Interface - AWS CLI](https://aws.amazon.com/cli/)

> Command line tool to access AWS

**Eksctl**: [Installation - eksctl](https://eksctl.io/installation/)

> Command line tool to create and upgrade EKS clusters and services

**Helm**: [Installing Helm](https://helm.sh/docs/intro/install/)

> Helm is a command line tool that automates the creation, packaging, configuration, and deployment of Kubernetes applications.

Extra reading: [Helm | Quickstart Guide](https://helm.sh/docs/intro/quickstart/)

## Configure EKS

> This guide assumes you have a fully set up AWS account. [Create an account on AWS](https://aws.amazon.com/resources/create-account/)

1. Let's create the `eks-cluster-config.yaml`. This is to configure the cluster with the desired instance type (c5.large is the default). 

    apiVersion: eksctl.io/v1alpha5
    kind: ClusterConfig
    
    metadata:
      name: hubs-ce
      region: us-east-1
    
    nodeGroups:
      - name: ng-1
        instanceType: c5.large
        desiredCapacity: 3

To change the instance size, replace the `instanceType` below. You can also customize `hubs-ce`
2.  Run the following command to create your cluster.

    eksctl create cluster -f eks-cluster-config.yaml --kubeconfig=./kubeconfig.hubs-ce.yaml

To make it easier to remember which cluster these credentials match, use the same name as from Step 2 (`hubs-ce`)
This may take a few minutes and will save the kubeconfig to your current directory.

## Setting Up The Node Workers Security Group For Audio

1. Find the AWS security group for your node workers in the EKS cluster console (under networking) on the AWS console to allow the required ports for communication.

2.  We need to add a few ports to this newly created group:

    aws ec2 authorize-security-group-ingress --group-id sgID --protocol tcp --port 4443 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id sgID --protocol tcp --port 5349 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id sgID --protocol udp --port 35000-60000 --cidr 0.0.0.0/0

**Replace `sgID` with your actual security group identifier.**
## Configure Database

At this point, to be production-ready, we need to create a Postgres instance on RDS. When creating this instance, we need to make sure it is in the same VPC as the EKS cluster. We will follow this guide: [Creating an Amazon RDS DB instance - Amazon Relational Database Service](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreateDBInstance.html)

Once your RDS instance is live, we need to update the security groups for both the EKS node workers and RDS to allow port 5432 or Postgresql traffic between the groups.

We need to update these values with the correct ones from RDS in  render_helm.sh

    DB_USER="postgres"
    DB_PASS="123456"
    DB_NAME="retdb"
    DB_HOST="pgbouncer"

While we wait for your EKS cluster and RDS instances to become available, we should set up kubectl to access the cluster using either their guide or running on Mac or Linux `export KUBECONFIG=path/to/kubeconfig`

## Installing Hubs CE Helm Chart

We will need to request a few SSL certificates. If you use Hubs CE, you will see a second bash script called `render_cbb.sh`. This shell script is the default method made available in vanilla CE to create the needed setup to have a one-off SSL certificate generated by Let’s Encrypt. These certificates are only valid for a short time (90 days). With Hubs CE, you must run `render_cbb.sh` every few months to ensure your SSL certificates are valid. 

### Cert-manager to the rescue!

Cert-manager allows us to automate the SSL certificate requests and will automatically keep them up to date. Cert-manager and Certbotbot both store the certificates and private keys as Kubernetes secrets but the cert-manager will run in the background and make sure the certificates are up-to-date and valid when needed. By automating this process we will not need to worry about an expired SSL certificate(s) again.

Let’s install it!

1. Create a new namespace:

    kubectl create ns security

2. Add the jetstack repo to helm and then install cert-manager into the security namespace

    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager \
    --namespace security \
    --set ingressShim.defaultIssuerName=letsencrypt-issuer \
    --set ingressShim.defaultIssuerKind=ClusterIssuer \
    --set installCRDs=true

`--set installCRDs=true` is how I installed it, you may follow either direction below from cert-manager
Cert-Manager requires several Custom Resource Definitions (CRD) resources, which can be installed manually using kubectl, or using the installCRDs option when installing the Helm chart. Both options are described below and will achieve the same result but with varying consequences. You should consult the [CRD Considerations](https://cert-manager.io/docs/installation/helm//#crd-considerations) section below for details on each method.

**Option 1: installing CRDs with kubectl**
> Recommended for production installations

    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.crds.yaml

**Option 2: install CRDs as part of the Helm release **
(How we did it above)
> Recommended for ease of use & compatibility
To automatically install and manage the CRDs as part of your Helm release, you must add the --set installCRDs=true flag to your Helm installation command.

Source: [Helm - cert-manager Documentation](https://cert-manager.io/docs/installation/helm/)

1. To use Let's Encrypt, we need to set up a Cluster Issuer on Kubernetes. Below is the needed file to use Let's Encrypt.

Create cluster-issuer.yaml:

    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-issuer
    spec:
      acme:
        # You must replace this email address with your own.
        # Let's Encrypt will use this to contact you about expiring
        # certificates, and issues related to your account.
        email: '{YOUR_EMAIL_ADDRESS}'
        server: https://acme-v02.api.letsencrypt.org/directory
        privateKeySecretRef:
          # Secret resource that will be used to store the account's private key.
          name: letsencrypt-issuer
        # Add a single challenge solver, HTTP01 using nginx
        solvers:
          - http01:
              ingress:
                class: haproxy
    

Replacing {YOUR_EMAIL_ADDRESS} with your email
2. Then run

    kubectl apply -f 'PATH_TO/cluster-issuer.yaml'

### Configure Mozilla Hubs CE Helm Chart

1. Clone the repo & create a copy of the `values.yaml` file for your stack:

    git clone git@github.com:hubs-community/mozilla-hubs-ce-chart.git
    cd mozilla-hubs-ce-chart
    cp values.yaml values-eks.yaml

2. We have to configure some environment variables to ensure Hubs CE will deploy correctly and become accessible to the internet.

3. Copy and paste the configs data output of `render_helm.sh` into our `values-eks.yaml`

    ./render_helm.sh {YOUR_HUBS_DOMAIN} {ADMIN_EMAIL_ADDRESS}

> You need the default cert to allow cert-manager to request certificates.
> `render_helm.sh` will create a new file `config.yaml` 

For SMTP setup, see the next two sections!

### How to set up SES for SMTP

1. Open up SES

2. Click Setup SMTP credentials.

3. You need the SMTP credentials not the secret for your AWS user[ https://docs.aws.amazon.com/ses/latest/dg/smtp-credentials.html](https://docs.aws.amazon.com/ses/latest/dg/smtp-credentials.html)

4. Change SMTP variables in render_helm.sh

    SMTP_USER="{YOUR_SMTP_USER}"
    SMTP_PASS="{YOUR_SMTP_PASS}"

5. Run the render_helm.sh and follow the instructions

### How to set up Gmail for SMTP

1. Open render_helm.sh

2. Change to have your email and password 

    SMTP_USER="{YOUR_SMTP_USER}"
    SMTP_PASS="{YOUR_SMTP_PASS}"

If you have 2fa enabled use an app password for the SMTP_PASS
3. Save and run ./render_helm.sh and follow the instructions

4. Modify the `values-eks.yaml` with your domain and email, and replace what's inside the string.

    global:
      domain: &HUBS_DOMAIN "{YOUR_HUBS_DOMAIN}"
      adminEmail: &ADMINEMAIL "{ADMIN_EMAIL_ADDRESS}"

### Updating your SMTP settings

> If you have installed the chart already, follow these commands to update your SMTP settings

1. Apply the new configs by running: `helm upgrade moz . -n hcce`

2. Then delete the ret pod: 

    kubectl get pods -n hcce 
    kubectl delete pod reticulum_name -n hcce
    

### Install our Chart

Now we can deploy the Hubs stack onto our Kubernetes cluster!

    kubectl create ns {YOUR_NAMESPACE}
    helm install moz -f path/to/values-eks.yaml . --namespace={YOUR_NAMESPACE}

Follow the instructions output of the chart and your stack should be online in 10-15 minutes!

A successful install should output this:

    DNS: Replace the values of all four records with your instance's external IP address. These should be:
    <HUB_DOMAIN>
    assets.<HUB_DOMAIN>
    stream.<HUB_DOMAIN>
    cors.<HUB_DOMAIN>
    
    Ports:
    Ensure these ports are open to the worker nodes:
    * TCP: 80, 443, 4443, 5349
    * UDP: 35000 -> 60000
    
    Get the application URL by running these commands:
    You can watch the status of by running "kubectl get --namespace {{ .Release.Namespace }} svc -w haproxy-lb"
    NOTE: It may take a few minutes for the LoadBalancer IP to be available. Once dns is setup the hub ce stack should come online at your	<HUB_DOMAIN>
    You can get the external-ip by running "kubectl get --namespace {{ .Release.Namespace }} svc -w haproxy-lb --output jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
    Get all pods "kubectl get pods --namespace {{ .Release.Namespace }}'"

## Verify our Install

Once your install is accessible from your Hubs Domain, we now need to test to make sure the system is operating correctly! 

First, let’s log into the hubs/admin panel. This will test whether our SMTP settings are correct. Click sign in, fill in your admin email and hit sign in. 

Check your email for a magic link. If you do not see this email in 5-15 minutes something may have gone wrong with your settings. If so we should check our ret logs with `kubectl logs ret_pod_name -n hcce` scroll up and look for any errors. 

Now that you are in the admin panel, let’s test and make sure your storage is working. Hit import content at the top left nav bar. Find some content you wish to upload and follow the import form. If you have any issues with scenes or avatars uploading then something has gone wrong most likely with your `PERMS_KEY` and you will need to go look at the key in the ret pod to make sure it is valid.

    kubectl exec -it reticulum_pod -n hcce cat ./config.toml

## Configure CORS/Reticulum

So you are done deploying and can get into a room, congrats! 

Unlike Hubs Cloud, Community Edition does not allow you to customize CORS in the admin panel. Let’s customize Reticulum with the settings that used to be located in the admin panel.

Open up your `ret-config` (search for that in `hcce.yam` or open `charts/reticulum/values.yaml`). 

What you are looking at is the `config.toml` for reticulum, all the settings from the admin panel live in this file. Search around this file for the other “missing” settings.

For CORS you want to find and update this block:

    [ret."Elixir.RetWeb.Plugs.AddCSP"]
    child_src = ""
    connect_src = "wss://*.stream.<HUB_DOMAIN>:4443"
    font_src = ""
    form_action = ""
    frame_src = ""
    img_src = "nearspark.reticulum.io"
    manifest_src = ""
    media_src = ""
    script_src = ""
    style_src = ""
    worker_src = ""

Once you are happy with your configuration, run:

    helm upgrade moz . -n hcce
    kubectl delete pod {reticulum_name} -n hcce

## Deploying a Custom Client

So we have our Hubs CE stack set up and running on AWS, we now want to deploy a custom client but we want to keep our client code private. The below process is similar to Mozilla Hubs custom client deployment, the main difference is the use of Amazon Elastic Container Registry (ECR) instead of using Docker Hub.

1. Create a new private Amazon Elastic Container Registry (ECR) on your AWS account of choice

2. Build your custom client’s docker image by running the following command in the root of your custom client:

    docker build \
    -t https://{aws_account_id}.dkr.ecr.{region-code}.amazonaws.com/hubs-client-registry:{your_tag} \
    -f ./RetPageOriginDockerfile . 

Replace {aws_account_id}, {region-code}, and {your_tag}
3. Push your new docker image to ECR

    docker push \
    -t https://{aws_account_id}.dkr.ecr.{region-code}.amazonaws.com/hubs-client-registry:{your_tag}

Replace {aws_account_id}, {region-code}, and {your_tag}
4. Update the helm `values.yaml`

    image:
      repository: mozillareality/hubs
      pullPolicy: IfNotPresent
      # Overrides the image tag whose default is the chart appVersion.
      tag: "stable-latest"

To

    image:
      repository: https://{aws_account_id}.dkr.ecr.{region-code}.amazonaws.com/hubs-client-registry
      pullPolicy: IfNotPresent
      # Overrides the image tag whose default is the chart appVersion.
      tag: "{your_tag}"

Replace {aws_account_id}, {region-code}, and {your_tag}
5. Update your helm deployment 

    helm upgrade -f values.yaml -n hcce

## Setting up Amazon Elastic File System (EFS) for Persistent Volume Claims & Persistent Volumes

At the time of writing, the Hubs CE bash scripts do not have a way to persist data storage. To help solve this we are going to set up an Amazon Elastic File System (EFS) filesystem that can be shared across our pods. 

1. We need to set up the EFS driver in the EKS Control Panel under addons. Search for EFS and click enable.

2. Now we need to create the EFS filesystem following this guide [Step 1: Create your Amazon EFS file system](https://docs.aws.amazon.com/efs/latest/ug/gs-step-two-create-efs-resources.html).

3. Once the EFS drive has come online, we will need to allow traffic from EKS by updating our EFS inbound security group.

4. Open up the EFS filesystem you just created and click on networking note down the security group in us-east-1, you should see the same security group for all regions.

5. Go to EC2, open up the security group tab and search for the EFS security group.

6. Add an inbound rule to allow EKS’s node workers access to EFS. Add an inbound rule for all traffic and the source should be the EKS node workers security group. This group can be found in the EKS control panel under networking (Additional Security Groups).

7. Copy and paste its filesystem ID to `values.yaml`

    global:
      aws:
        efs:
          enabled: true
          isDynamicProvisioning: false
          fileSystemId: fs-000000000000

8. Run these commands to set up the needed Trust Policy and Role needed to access EFS from EKS.

9. Setup your cluster name

    export cluster_name={YOUR_CLUSTER_NAME}
    export role_name=AmazonEKS_EFS_CSI_DriverRole

10. Create an IAM Service Account for EFS-CSI-controller

    eksctl create iamserviceaccount \
    --name efs-csi-controller-sa \
    --namespace kube-system \
    --cluster $cluster_name \
    --role-name $role_name \
    --profile hubs-ce \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy \
    --approve

11. Get and update the trust policy for this new role.

    TRUST_POLICY=$(aws iam get-role --role-name $role_name --query 'Role.AssumeRolePolicyDocument' | \
    sed -e 's/efs-csi-controller-sa/efs-csi-*/' -e 's/StringEquals/StringLike/')
    
    aws iam update-assume-role-policy --role-name $role_name --policy-document "$TRUST_POLICY"

12. Now we need to grab the OIDC id from the below command:

    aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text

The output should look like this: https://oidc.eks.us-east-1.amazonaws.com/id/0CXXXXXXXXXXXXXXXXXXXXX
13. Copy the id after the slash and add it to the `default-aws-efs-csi-driver-trust-policy.json`

14. Now create and attach the role with awscli:

    aws iam create-role \
    --role-name AmazonEKS_EFS_CSI_DriverRole \
    --assume-role-policy-document file://"default-aws-efs-csi-driver-trust-policy.json"
    
    aws iam attach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy \
    --role-name AmazonEKS_EFS_CSI_DriverRole

15. Now go update your `values.yaml` to enable EFS (values.aws.yaml), and upgrade helm and you are good to go!

Once upgraded, Reticulum and Postgres (pgsql) will use a static Persistent Volume Claims and Persistent Volumes with an EFS backend to share their storage directories across pods. Restarting the reticulum pod(s) should no longer cause data loss but there is always a risk when deleting your pods. Use at your own risk!

## Cleanup

If you followed this article to test out Hubs CE and would like to remove the cluster after your testing. Run the following command:

    helm delete moz . -n hcce
    eksctl delete cluster -f cluster.yaml

If you used the EFS filesystem (PVC/PV) and RDS instance, you will want to manually delete those and remove the 4 DNS records we created.

I hope this article/helm chart helps simplify your deployments and helps you scale your hubs system to new levels! If you have questions or feedback about this article drop me a DM on Hubs Discord! 

Thanks for reading, can’t wait to see what you build!
Alex Griggs
