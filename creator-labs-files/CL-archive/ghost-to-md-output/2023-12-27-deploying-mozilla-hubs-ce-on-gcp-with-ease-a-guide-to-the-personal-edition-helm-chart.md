---
title: "Deploying Mozilla Hubs CE on GCP with Ease: A Guide to the Personal Edition Helm Chart"
slug: deploying-mozilla-hubs-ce-on-gcp-with-ease-a-guide-to-the-personal-edition-helm-chart
date_published: 2023-12-27T16:59:17.000Z
date_updated: 2023-12-27T16:59:17.000Z
tags: Advanced, Tutorials
excerpt: In this guide, Alex Griggs shows readers how to deploy his Community Edition Helm Chart: Personal Edition on GCP
---

> In my other article, Deploying Mozilla Hubs CE on AWS with Ease: A Guide to the Personal Edition Helm Chart, I described how to set up a personal edition of my Hubs CE Helm Chart on AWS. The steps in this article will look very similar, but look closely at the deployment process for how to deploy CE with Helm for Google Cloud Platform.

 Welcome! As many of you may already know, Mozilla has launched a successor to Hubs Cloud called [Hubs Community Edition](https://github.com/mozilla/hubs-cloud/tree/master/community-edition) (Hubs CE for short). I was lucky to get into the preview for Hubs CE before the public launch! 

 My name is Alex Griggs. I am a Full Stack Software Engineer and have built multiple startups as CTO/CEO with expertise in kubernetes, cloud computing and AI/ML. 

 In 2021, I started working for a small startup called UtopiaVR as the Lead Developer. They were building some cool tech on top of this new-to-me thing called Mozilla Hubs. The first time I tried the Utopia client, I was hooked, I had always disliked video calls. I went to town ripping apart the Hubs Cloud infrastructure. Within a month or so I had set up a copy of Hubs Cloud on an Ubuntu instance. While at UtopiaVR, I set up and managed multiple Hubs Cloud instances and started modifying everything, deploying our client to many stacks, modifying backend services, etc.

 In this article, we will go over how to prepare and set up a Kubernetes cluster on Google Cloud Platform for a production-ready instance of Hubs CE using the Helm chart! A production-ready instance of Mozilla Hubs CE will consist of a few added services and infrastructure to be ready to host a large event(s), set up custom client pipelines, and persist all user data with persistent volumes and an external database. 

 Now where do I come in with Hubs CE? Well, when I got the preview I had it up and running on my home lab in a day or so but what Mozilla had and was going to release was a bash script that had many issues which I helped update to get it launched. 

 As I was playing with the scripts and the massive yaml file that their scripts produced, I quickly realized that the community would greatly benefit from a helm chart. I have set up and managed multiple kubernetes clusters before and built Helm charts from scratch so I knew I was up to this task. Helm has always been a great tool, it makes installing and updating super easy. So I set out to build the [Hubs CE Helm chart.](https://github.com/hubs-community/mozilla-hubs-ce-chart)

 We are going to go over a lot in this article; the first is how to prepare [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine) for the helm deployment(s) and then we will deploy our first Hub CE stack. Bear with me!

## **Introducing Helm!**

[Helm](https://helm.sh/) is a very useful deployment tool for kubernetes, it allows us to install services and manipulate the environment from a simple-to-read value.yaml file. We will look into these files deeply in the coming article. 

 By modifying the builder files from Community Edition and then creating the Helm charts, I have made each service in the Hubs stack more extensible, scalable and maintainable for the long run. Using a Helm chart to set up Mozilla Hubs CE offers us several advantages over using a complex bash script. Here are a few reasons why we should deploy using the chart:

- **Ease of Use**: Helm charts are like packages or templates that make it easy to install and manage applications on Kubernetes. They package all the necessary components and configurations into a single, easy-to-use format. In contrast, a bash script can be complex, and harder to understand or modify for the end user.
- **Customization and Flexibility**: Helm charts are highly customizable. You can easily change settings or configurations without having to edit the entire script. With a bash script, making changes often requires understanding and modifying the script’s code or templates (yml), which can be error-prone and time-consuming.
- **Consistency and Reliability**: Helm ensures that applications are deployed consistently every time. It manages all the dependencies and configurations, reducing the risk of errors that can happen with manual installations using bash scripts.
- **Version Control and Updates**: Helm charts can be versioned, making it easy to roll back to a previous version if something goes wrong. This is harder to manage with bash scripts, especially if changes are made without proper versioning on our side.
- **Community Support**: This open-sourced Helm chart is developed and maintained by the community. We will try to keep this chart updated regularly and will be free forever.

 I hope that this Helm chart for Mozilla Hubs simplifies the deployment process, makes it easier to manage and customize the stack, and reduces the likelihood of errors compared to using the bash script.

## **Introducing the Mozilla Hubs CE Helm Chart!**

> If you have a Kubernetes cluster or are just playing around on minikube look at the readme in the repo for a quick start. 
> **Source: **[Mozilla Hubs CE Helm Chart](https://github.com/hubs-community/mozilla-hubs-ce-chart)

 Imagine your magic recipe (Helm Chart) for setting up toys but it is a book with different pages, each page having specific instructions or information:

- **`Chart.yaml`:** This is like the cover page of your book. It tells you the name of your magic recipe (Helm Chart), the version of the recipe, and a little description of what kind of toy setup it creates.
- **`Values.yaml`:** Think of this as a page where you can write down your preferences, like choosing the colour of your race track or the size of your castle. In Helm, this file lets you customize your setup without changing the main instructions.
- **`Templates/`**: This is like a collection of magic spells. Each spell (file) in this folder is a specific instruction on how to set up a part of your toy setup. For example, one spell might be for setting up the race track, another for building the castle walls, and so on.
- **`Charts/`**: Sometimes, your magic recipe book might need smaller recipe books to work. This folder contains those smaller books (other Helm Charts) that your main recipe might depend on. In our case, it's the backend services needed to launch the Hubs CE stack.

 Within the Hubs CE chart root directory, we have the Hubs client; The image and tag are in the root values.yaml file. We will go into how to build and deploy a custom client later in this article, once we have a setup chart. But for now, know that all other services are located in the `charts/` directory. We can configure these subcharts from the main values.yaml.

Okay enough talk, let's get deploying!

## Prerequisites

 First, we need to set up a few dependencies. We need gcloud/kubectl, helm and optional awscli to be installed:

**Gcloud**: [Installation and Setup | Cloud Deployment Manager Documentation](https://cloud.google.com/deployment-manager/docs/step-by-step-guide/installation-and-setup#install)

> The Google way to configure and access Kubernetes Clusters

**Helm**: [Installing Helm](https://helm.sh/docs/intro/install/)

> Helm is a command line tool that automates the creation, packaging, configuration, and deployment of Kubernetes applications.

**(Optional) Awscli**: [Command Line Interface - AWS CLI](https://aws.amazon.com/cli/)

> Command line tool to access AWS

Extra reading: [Helm | Quickstart Guide](https://helm.sh/docs/intro/quickstart/)

## Setup Google Cloud Platform (GKE)

> This guide assumes you have a fully set up Google Cloud Platform account. [Getting started – Google Cloud console](https://console.cloud.google.com/getting-started?pli=1)

### Setup a GKE with gcloud

We will need to check the components installed

1. Get a list of the gcloud components

    gcloud components list

2. We need kubectl installed

    gcloud components install kubectl

> You may need to run:
> `gcloud components update`

3. Now we will create a cloud cluster by running the following command:

    gcloud container clusters create hubs-ce-cluster --machine-type n1-standard-2 --num-nodes 3 --zone={YOUR_DESIRED_ZONE}

Replace {YOUR_DESIRED_ZONE} with the zone you would like to deploy in. You must have the Kubernetes Engine API enabled on your account. Add `--addons=GcpFilestoreCsiDriver` if you want to use Persistent Volumes
 This command will bring up 3x n1-standard-2 which each node has 2x CPU, 7GB of RAM and a 10 Gbps network card.

> You may change these to whatever value you would like ie; n1-standard-1. 
> For an event I would recommend a minimum of 3x n1-standard-4

4. To verify our kubernetes GKE Cluster details run:

    gcloud container clusters list

5. If you are managing multiple clusters from your machine then to switch context for kubectl to our new cluster we can run the following command:

    gcloud container clusters get-credentials hubs-ce-cluster --zone={YOUR_DESIRED_ZONE} --project {PROJECT_NAME}

Replace {YOUR_DESIRED_ZONE} and {PROJECT_NAME} with the zone and project you would like to deploy in.
> By default above command will copy kubeconfig file details in your HOME/.kube directory. It’s a context to connect a kubernetes cluster. To view all your contexts run `kubectl config get-contexts`

5. We need to open some ports on our network before the audio will work. Run the following commands to open port 4443, 5439, 35000-60000

    For TCP port 4443:
    gcloud compute firewall-rules create rule-name-1 --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:4443 --source-ranges=0.0.0.0/0
    
    For TCP port 5349:
    gcloud compute firewall-rules create rule-name-2 --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:5349 --source-ranges=0.0.0.0/0
    
    For UDP ports 35000 to 60000:
    gcloud compute firewall-rules create rule-name-3 --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=udp:35000-60000 --source-ranges=0.0.0.0/0

You may customize the rule names.
6. To verify that the nodes have come online use the following command:

    kubectl get nodes -o wide
    kubectl config view
    kubectl config current-context

When you see the nodes change to a ready state we are ready to set up the Helm chart!

## Configure Your Database

1. At this point, we need to create a Postgresql instance on Cloud SQL. [Quickstart: Connect to Cloud SQL for PostgreSQL from Cloud Shell | Google Cloud](https://cloud.google.com/sql/docs/postgres/connect-instance-cloud-shell#before-you-begin)

We need to update these values with the correct ones from Cloud SQL in render_helm.sh

    DB_USER="postgres"
    DB_PASS="123456"
    DB_NAME="retdb"
    DB_HOST="pgbouncer"

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
To automatically install and manage the CRDs as part of your Helm release, you must add the `--set installCRDs=true` flag to your Helm installation command.

**Source**: [Helm - cert-manager Documentation](https://cert-manager.io/docs/installation/helm/)

1. To use Let's Encrypt, we need to set up a Cluster Issuer on Kubernetes. Below is the needed file to use Let's Encrypt.

Create cluster-issuer.yaml

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

### Configure The Mozilla Hubs CE Helm Chart

1. Create a copy of the `values.yaml` file for your stack

    cp values-gcp.yaml values-my-gke.yaml

2. We have to configure some environment variables to ensure Hubs CE will deploy correctly and become accessible to the internet.

3. Copy and paste the configs data output of `render_helm.sh` into the `values-my-gke.yaml`

    ./render_helm.sh {YOUR_HUBS_DOMAIN} {ADMIN_EMAIL_ADDRESS}

> You need the default cert to allow cert-manager to request certificates.
> `render_helm.sh` will create a new file `config.yaml` 

For SMTP setup, see the next two sections.

### How to set up SES for SMTP

1. Open up SES

2. Click Setup SMTP credentials.

3. You need the SMTP credentials not the secret for your AWS user[ https://docs.aws.amazon.com/ses/latest/dg/smtp-credentials.html](https://docs.aws.amazon.com/ses/latest/dg/smtp-credentials.html)

4. Change SMTP variables in `render_helm.sh`

    SMTP_USER="{YOUR_SMTP_USER}"
    SMTP_PASS="{YOUR_SMTP_PASS}"

5. Run the `render_helm.sh` copy over the configs

6. First-time install, proceed to the next step.

7. Apply the new configs by running: `helm upgrade moz  -f values-my-gke.yaml . -n hcce`

8. Then delete the ret pod: 

    kubectl get pods -n hcce 
    kubectl delete pod reticulum_name -n hcce
    

### How to set up Gmail for SMTP

1. Open render_helm.sh

2. Change to have your email and password 

    SMTP_USER="{YOUR_SMTP_USER}"
    SMTP_PASS="{YOUR_SMTP_PASS}"

If you have 2fa enabled use an app password for the SMTP_PASS
3. Save and run `./render_helm.sh` and follow the instructions

4. First-time install, proceed to the next step.

5. Apply the new configs by running: `helm upgrade moz -f values-my-gke.yaml . -n hcce`

6. Then delete the ret pod: 

    kubectl get pods -n hcce 
    kubectl delete pod reticulum_name -n hcce
    

## Install The Chart!

1. Modify the `values-my-gke.yaml` with your domain and email, and replace what's inside the string.

    global:
      domain: &HUBS_DOMAIN "{YOUR_HUBS_DOMAIN}"
      adminEmail: &ADMINEMAIL "{ADMIN_EMAIL_ADDRESS}"

2. Now we can deploy the Hubs stack onto our Kubernetes cluster!

    git clone git@github.com:hubs-community/mozilla-hubs-ce-chart.git
    cd mozilla-hubs-ce-chart
    kubectl create ns {YOUR_NAMESPACE}
    helm install moz -f path/to/values-my-gke.yaml . --namespace={YOUR_NAMESPACE}

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

    helm upgrade moz -f values-my-gke.yaml . -n hcce
    kubectl delete pod {reticulum_name} -n hcce

## Deploying a Custom Client

1. Create a new Google Artifact Registry Repositories on your GCP account.

2. Build your custom client’s docker image by running the following command in the root of your custom client:

    docker build \
    -t {YOUR_ZONE}-docker.pkg.dev/{YOUR_PROJECT}:{your_tag} \
    -f ./RetPageOriginDockerfile . 

3. Push your new docker image to ECR

    docker push {YOUR_ZONE}-docker.pkg.dev/{YOUR_PROJECT}:{your_tag}

4. Update the helm `values.yaml`

    image:
      repository: mozillareality/hubs
      pullPolicy: IfNotPresent
      tag: "stable-latest"

To

    image:
      repository: {YOUR_ZONE}-docker.pkg.dev/{YOUR_PROJECT}
      pullPolicy: IfNotPresent
      tag: "{your_tag}"

Update your helm deployment

    helm upgrade -f values.yaml -n hcce

## Setup Filestore Filesystem for Persistent Volume Claims & Persistent Volumes

As of writing the Hubs CE bash scripts do not create a way to persist data storage. To help solve this we are going to set up a Filestore filesystem that can be shared across our pods. 

1. If we enabled the addon at creation time we can move on if not run the following command to update your cluster:

    gcloud container clusters update hubs-ce-cluster \
    --update-addons=GcpFilestoreCsiDriver=ENABLED

2. We need to enable a few services to get this to work.

    gcloud services enable filestore.googleapis.com
    gcloud services enable file.googleapis.com

3. Once we have these services enabled, let’s create some storage!

    gcloud filestore instances create hubs-storage --zone={YOUR_ZONE} --tier=BASIC_HDD --file-share=name="{FILESTORE_SHARE_NAME}",capacity=1Ti --network=name="default"

4. After the operation finishes, run this command to get the needed parameters

    gcloud filestore instances describe hubs-storage --zone={YOUR_ZONE}

You should get an output like the one below:

    fileShares:
    - capacityGb: '1024'
      name: vol1
    name: projects/hubs-ce/locations/{YOUR_ZONE}/instances/hubs-storage
    networks:
    - connectMode: DIRECT_PEERING
      ipAddresses:
      - 10.91.45.122
      network: default
      reservedIpRange: 10.91.45.122/29
    state: READY
    tier: BASIC_HDD

5. Update your `values-my-gcp.yaml` by replacing `FILESTORE_INSTANCE_IP` with your `ipAddresses`, `FILESTORE_INSTANCE_LOCATION` with `{YOUR_ZONE}` and `FILESTORE_SHARE_NAME` with the value you input above. (we used `vol1`)

    gcp:
       persistent:
         enabled: true
         storage: 50Gi
         volumeHandle: "modeInstance/FILESTORE_INSTANCE_LOCATION/FILESTORE_INSTANCE_NAME/FILESTORE_SHARE_NAME"
         volumeAttributes:
           ip: FILESTORE_INSTANCE_IP
           volumeName: FILESTORE_SHARE_NAME
    

You may have to enable GCP persistent.
6. Now upgrade helm and roll over your Reticulum pod with the commands below and you are good to go!

    helm upgrade moz -f path/to/values-my-gcp.yaml . -n hcce
    kubectl get pods -n hcce 
    kubectl delete pod reticulum_name -n hcce

Once upgraded, Reticulum and Postgres (pgsql) will use a static Persistent Volume Claims and Persistent Volumes with a Filestore backend to share their storage directories across pods. Restarting the reticulum pod(s) should no longer cause data loss but can't guarantee that. Use at your own risk!

## Cleanup

If you followed this article to test out Hubs CE and would like to remove the cluster after your testing. Run the following command:

    helm delete moz . -n hcce
    eksctl delete cluster -f cluster.yaml
    kubectl delete ns hcce
    kubectl delete ns security

If you used a persistent filesystem (PVC/PV) and Cloud SQL instance, you will want to manually delete those and remove the 4 DNS records we created. 

I hope this article/helm chart helps simplify your deployments and helps you scale your hubs system to new levels! If you have questions or feedback about this article drop me a DM on Hubs Discord! 

Thanks for reading, can’t wait to see what you build!
Alex Griggs
