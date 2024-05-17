---
title: "Community Edition Case Study: Quick Start on Google Cloud with AWS Services"
slug: community-edition-case-study-quick-start-on-gcp-w-aws-services
date_published: 2023-10-16T20:12:51.000Z
date_updated: 2024-05-01T04:03:54.000Z
tags: Code, Advanced
excerpt: This article walks you through one way of setting up a Community Edition instance. For this guide, we are using Kubernetes on Google Cloud with our DNS and SMTP services on AWS. This guide is perfect for those familiar with the Hubs Cloud looking to get started quickly.
---

---

## Introduction

In this step-by-step guide, you will learn how to quickly deploy an instance of [Hubs Community Edition](https://github.com/mozilla/hubs-cloud/tree/feature/ce/community-edition) on Google Cloud using AWS's Route53 and Simple Email Service (SES). This guide is perfect for Hubs Cloud customers who are familiar with navigating AWS services and interested in learning about how to host Hubs on a new platform like Google Cloud.

To begin, it is important to understand some basic information about the technology that makes up Community Edition, Kubernetes, and how they work together. If you are already familiar with this information, you may skip ahead to the start of the tutorial at the subheading "Deployment Prerequisites".

## Understanding the Hubs Community Edition Infrastructure

The product known as "Mozilla Hubs" is composed of several powerful pieces of software. For example, when you visit a Hub with your Web browser, you are interacting with the [Hubs Client](https://github.com/mozilla/hubs/).

The Hubs Client itself interacts with several **other** pieces of software, such as:

- [Reticulum](https://github.com/mozilla/reticulum) | Hubs' networking and API server
- [Dialog](https://zachfox.io/hubs-webrtc-tester/about/) | Hubs' WebRTC voice and video communication server

The Hubs Client, Dialog, and Reticulum are just three components of a larger stack of software. Each of this stack's components are individually configured and networked to other components to make Hubs work properly.

Hubs Community Edition eliminates the need for developers to download, install, configure, connect, and update each of the stack's components individually. Community Edition simplifies and automates most of that complex deployment process using software called **Kubernetes, **which is a **containerized software orchestration system.**

## An Introduction to Containerized Software

Consider the Web browser you are using right now to read this article:

1. Unless that browser was installed onto your device from the factory, you first had to download a version of your browser that corresponds to your device's operating system.
2. Next, you installed the browser, perhaps specifying a directory into which its application files were placed.
3. After that, you opened the browser and may have signed into a Firefox account or a Google account.
4. Then, you may have installed an ad blocker extension or a password manager.
5. Finally, you might have navigated to a website and added it to your favorites bar...

Imagine if you could package up the complete state of your Web browser installation -- including its configuration settings, logged-in accounts, extensions, browser history, favorites, and more -- and make use of that package on any other computer, regardless of operating system.

Similarly, imagine if you could package up the complete state of **any **application -- its dependencies, libraries, configuration files, and application code -- and run that package on any other computer.

**This is possible **using open-source software called Docker. A **Docker Container **is a process executed on a computer running its own packaged and configured software. You can learn more about Docker and Docker Containers here [on the official docs](https://docs.docker.com/get-started/).

💡

It is common for self-hosted software to be distributed as Docker Containers to aid in a swift software deployment with minimal configuration.

Other examples of popular software that is packed as a Docker Container include:
[Wordpress](https://hub.docker.com/_/wordpress) | The blogging website system
[Nextcloud](https://hub.docker.com/_/nextcloud) | A suite of content collaboration software
[Ubuntu](https://hub.docker.com/_/ubuntu) | The entire Linux distribution

**Many components of Hubs Community Edition run inside separate Docker Containers.** By themselves, these containers don't know much about one another. If you were to run a Reticulum container on your computer without also running a Dialog container, anyone who connected to your Hub would be able to see each other, **but not** hear each other.

Therefore, we need a way for these containers to talk to each other. We need a way for people who connect to a Hub to also connect to that Hub's associated Dialog server. We also need a way to update the Dialog container's code without bringing down the Reticulum container. How do we coordinate all of these containers?

**Kubernetes!**

## Kubernetes Introduction

Kubernetes, often shortened to "K8s", acts as an **organizer **for containerized software. A Kubernetes deployment, called a "cluster", consists of two parts:

1. **A control plane** that is responsible for maintaining the state of the cluster as defined by an administrator/developer.
2. **Nodes**, which are virtual or physical computers that run software defined by the control plane. Each node contains a set of one or more **pods, **which share storage and network resources. Each pod runs one or more **containers.**

![](./content/images/2023/10/kubernetes-cluster.webp)
To deploy software built using Kubernetes, a developer must supply a Kubernetes executable with a plain-text configuration file describing the cluster's pods, those pods' containers, the computing resources that a container needs to function, networking information, and more. This configuration file is called a **[deployment spec](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment).**

💡

A Hubs developer might write a configuration file that says "I want my K8s cluster to run version `ret.prod.220712.200` of the Reticulum server on port 9100 and version `dialog.prod.220303.63` of the Dialog server on port 4443."

The control plane would ingest that configuration file and instruct its nodes to download and run that specific, containerized software.

Kubernetes clusters can be deployed on many types of computers, including:

- Your home desktop computer
- [Two $35 Raspberry Pi Computers](https://ubuntu.com/tutorials/how-to-kubernetes-cluster-on-raspberry-pi#1-overview)
- Computers owned by a cloud services provider, such as:
   - [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine?hl=en)
   - [Amazon Elastic Kubernetes Service](https://aws.amazon.com/eks/)
   - [Microsoft Azure Kubernetes Service](https://azure.microsoft.com/en-us/products/kubernetes-service)
   - [DigitalOcean Kubernetes](https://www.digitalocean.com/products/kubernetes)

## Community Edition's Containerized Services

Here is a rundown of each container that makes up Hubs Community Edition:

1. **[Hubs](https://github.com/mozilla/hubs/)** | The Hubs Client for Web browsers.
2. **[Spoke](https://github.com/mozilla/spoke/)**| A web-based content authorizing tool used to create custom 3D environments for Hubs.
3. **[Reticulum](https://github.com/mozilla/reticulum/)** | Hubs' networking and API server. This handles authorization, avatar positioning, object manipulation, and way more.
4. [**Dialog**](https://github.com/mozilla/dialog/) | A WebRTC audio and video communication server. This contains a WebRTC Selective Forwarding Unit. For more information about how Hubs uses WebRTC, check out [this resource](https://zachfox.io/hubs-webrtc-tester/about/).
5. **[Coturn](https://github.com/coturn/coturn)**| A TURN and STUN server used for WebRTC communication. For more information about how Hubs uses WebRTC, check out [this resource](https://zachfox.io/hubs-webrtc-tester/about/).
6. [**Nearspark**](https://github.com/MozillaReality/nearspark)| A service used to generate thumbnails from images.
7. **[Speelycaptor](https://github.com/mozilla/speelycaptor)**| A service used to convert video to a Hubs-compatible format. Uses ffmpeg.
8. **[PgBouncer](https://www.pgbouncer.org/install.html)** | A lightweight connection pooler for PostgreSQL. Rather than making new, expensive PostgreSQL database connections for every client or query, a connection pooler creates a long-lived group of connections to a database, and reuses those connections as necessary. This improves database access performance and availability.
9. **[Photomnemonic](https://github.com/MozillaReality/photomnemonic)**| A service used to take screenshots of websites.

After deploying your own version of Community Edition, you will be able to see these containerized services running in their own individual pod. Now that all of those details are out of the way, let's get to the deployment tutorial!

## Deployment Prerequisites

💡

In the weeks following the release of this guide, we expect that users may encounter unexpected bugs. The most effective way to let us know about these issues is in the #community-edition channel of our Discord server or by creating an issue on the Hubs Cloud repository.

To successfully deploy Community Edition, certain prerequisites must be met. The requirements discussed below are tailored to this case study and do not precisely match those in the Communit Edition codebase. It is important to note that this tutorial was created using a 2021 M1 Macbook Pro running macOS Ventura 13.1 . The individual commands used to deploy Community Edition may depend on your device and operating system.

**Part 1: **Before getting started, we need to configure billing on our Amazon Web Services and Google Cloud Platform accounts. This guide does not go through the individual steps of setting up your account and billing information, but you can find more information about the setup process at the following links: [AWS](https://docs.aws.amazon.com/accounts/latest/reference/welcome-first-time-user.html) | [GCP](https://cloud.google.com/billing/docs/how-to/create-billing-account)

**Part 2: **We will be using the following free, 3rd-party applications:

A.[**VSCode**](https://code.visualstudio.com/) | A code editor for us to configure and deploy Community Edition.
 B. **[Lens](https://k8slens.dev/)** | An interface where we can inspect and manage our K8s cluster.

**Part 3: **We need to make sure our computer has the following software installed. We have included the commands that we ran for installation:

A. [Homebrew](https://brew.sh/)

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

B. [The Google Cloud SDK ](https://cloud.google.com/sdk?hl=en)

    brew install --cask google-cloud-sdk

C. [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"

D. [gettext](https://www.gnu.org/software/gettext/)

    brew install gettext

## Step 1: Configuring your DNS on AWS's Route53

TIf you have set up a Hubs Cloud instance on AWS, you will be familiar with the process of registering a domain on Route53. In fact, you may even have an existing domain that you wish to use for your Community Edition instance. However, unlike Hubs Cloud, you need only **one **registered domain in order to deploy Community Edition.

If you do not already own a domain that you plan to use for this deployment, you will need to purchase on on AWS Route53:

1. Navigate to Route53 on the AWS console.
2. Select the "Registered Domains" tab in the left-hand toolbar.
3. Select the "Register Domain" button, search for your desired domain, and follow the checkout process to purchase your domain.
4. Wait for a confirmation email indicating that your purchase was successful. You will also have to wait for the registration process to complete.
5. Lastly, disable Transfer Lock on your domain. This can be done by selecting your domain in the "Registered Domains" tab and clicking the "disable" hyperlink next to "Transfer Lock".

Once we have registered our desired domain, we need to create four records...

1. Navigate to the "Hosted Zones" tab in the left-hand toolbar and click on your domain.
2. In the domain's details, you will select "Create Record" to create 4 A-records with placeholder values. Don't worry, we will update these later:
   a. **Record Name: **{keep blank}
   **Record Type: **A
   **Value: **0.0.0.0 (placeholder)
   b. **Record Name: **assets
   **Record Type: **A
   **Value: **0.0.0.0 (placeholder)
   c. **Record Name: **stream
   **Record Type: **A
   **Value: **0.0.0.0 (placeholder)
   d. **Record Name: **cors
   **Record Type: **A
   **Value: **0.0.0.0 (placeholder)

After this is complete, we have properly configured our domain for deployment. Once again, we will come back to update those placeholder record values later in the guide.

## Step 2: Configuring your SMTP on AWS's Simple Email Service (SES)

Hubs relies on the ability to associate a user's email address with important account information, such as their Spoke scenes, rooms, avatars, and more. We will need to configure an Simple Mail Transfer Protocol service (SMTP) in order for our instance to send emails to users.

1. Navigate to "Amazon Simple Email Service" in the AWS console.
2. Select "SMTP settings" in the left-hand toolbar.
3. Make note of your **SMTP endpoint URL**, this will be used later.
4. Select the "Create SMTP credentials" button.
5. (Optional) On the "Specify User Details" page, you may customize your assigned IAM user name.
6. Verify that the following keys in "Permissions policy for user" have the corresponding values:
   "Effect": "Allow"
   "Action": "ses:SendRawEmail"
   "Resource": "\*"
7. Select "Create User".
8. Download or copy the **SMTP user name **and **SMTP password**. These will be used when configuring the Community Edition deployment spec later in the guide.

Once this is complete, our email service is properly configured for deployment!

💡

This quick start guide was tested with SES still in sandbox-mode with my hub's domain and admin email address as verified identities (SES prevents unverified recipients and senders in the sandbox). Like Hubs Cloud, we recommend requesting a limit increase from SES as part of making your version of Hubs production-ready.

## Step 3: Create Your Kubernetes Cluster using Google Cloud Kubernetes Engine

Next, we need to create a new Kubernetes cluster to hold our Community Edition containers. We can create this cluster using the command line with google-cloud-sdk installed:

1. Log in to the google cloud sdk.

   gcloud auth login

2. Check that you are working in the project where you would like to create your cluster. If you need to create a project, [follow these steps](https://cloud.google.com/sdk/gcloud/reference/projects/create).

   gcloud config list

3. If you are **not** working in the correct project, run the following command to change to the correct project.

   gcloud config set project <YOUR_PROJECT_ID>

4. Create your K8s cluster. We generally recommend assigning your cluster to the zone nearest to your intended user base. You can find more information on zones [here](https://cloud.google.com/compute/docs/regions-zones).

   gcloud container clusters create <YOUR_DESIRED_NAMESPACE> --zone=<YOUR_DESIRED_ZONE>

5. Wait for your cluster to be configured. This may take several minutes. When completed, you will receive confirmation and information about your cluster.

   Created [https://container.googleapis.com/v1/projects/YOUR_PROJECT_ID/zones/YOUR_DESIRED_ZONE/clusters/YOUR_DESIRED_NAMESPACE].

6. After creating your cluster, you will need to make sure you have the following ports open for connections...

- TCP: 80, 443, 4443, 5349
- UDP: 35000 -> 60000

In GCP, you can do this by going to VPC Network > all > Create Firewall Rule. Make sure you select the network for your cluster.

Our K8s cluster is now ready to receive our deployment spec for Community Edition!

## Step 4: Download, Configure, and Deploy Community Edition

The code that makes up Community Edition currently lives in [this section of the Hubs Cloud GitHub repository](https://github.com/mozilla/hubs-cloud/tree/feature/ce/community-edition). In order to deploy it to our K8s cluster, we must download the repository, edit the deployment scripts with information from our chosen services, and deploy the configuration files.

1. Clone the GitHub repository using the command line in VSCode.

   git clone https://github.com/mozilla/hubs-cloud.git

2. Move into the community-edition directory.

   cd community-edition

3. Editing `render_hcce.sh` in VSCode, replace the following **required** parameters with your chosen services. You will also configure multiple secret passwords that you should save locally on your device:
   ** HUB_DOMAIN** | Your domain from Route53.
   ** ADM_EMAIL** | The email address to be assigned admin privileges on creation.
   **Namespace **| The namespace to use within your Kubernetes cluster.
   **DB_PASS** | A secret password chosen by you.
   **SMTP_SERVER** | The SMTP endpoint URL from SES.
   **SMTP_PORT **| 587
   **SMTP_USER** | The SMTP user name from SES.
   **SMTP_PASS** | The SMTP password from SES.
   **NODE_COOKIE** | A secret password chosen by you.
   **GUARDIAN_KEY** | A secret password chosen by you.
   **PHX_KEY **| A secret password chosen by you.

4. (Optional) Editing `render_hcce.sh` in VSCode, replace the **SKETCHFAB_API_KEY **and **TENOR_API_KEY** with credentials from these services. If you would not like to configure [Sketchfab](https://sketchfab.com/developers) (for searching 3D models) or [Tenor](https://tenor.com/gifapi/documentation) (for searching animated GIFs) you can simply leave these values as they are.

5. Once you have finished configuring the deployment script, run the following command to create the deployment spec and apply it to your cluster.

   bash render_hcce.sh && kubectl apply -f hcce.yaml

6. Wait for the deployment to complete. This may take several minutes.

7. Verify the deployment with the following command. You should see 11 pods listed in the returned value.

   kubectl get deployment -n NAMESPACE_WITHIN_CLUSTER

8. If you would like to look deeper, you can look into the details of each pod to make sure the intended values are present. We recommend verifying the information in the Reticulum pod.

   kubectl describe deployment POD_NAME -n NAMESPACE_WITHIN_CLUSTER

💡

The scripts in the Community Edition codebase may need to be adjusted depending on your device and operating system. For example, lines 58 and 59 of `render_hcce.sh` were edited from `base64 <secret> -w 0` to `base64 -i <secret>` in order to run on M1 macOS 13.1.

## Step 5: Expose Services

Before we can access our Community Edition instance, we need to point our domain to its automatically assigned external IP.

1. Get your instance's external IP address.

   kubectl -n NAMESPACE_WITHIN_CLUSTER get svc lb

2. Navigate back to the "Hosted Zones" tab of AWS Route53 and select your domain.

3. Replace the placeholder values of all four A-records you created previously with your instance's external IP address. These should be:
   **<HUB_DOMAIN>
    assets.<HUB_DOMAIN>
    stream.<HUB_DOMAIN>
    cors.<HUB_DOMAIN>**

4. Save all records and wait a few minutes for the changes to propogate.

## Step 6: Verify and Manage Your Instance with Lens

Once you have exposed your IP to your domain, you should now be able to begin using your Community Edition instance at its intended domain.

**Connecting to your domain for the first time...**

1. Attempt to connect to your domain. Since we have not yet configured certificates for our Hub, we will need to 'self-sign' the certificates. Your Web browser will warn you when joining an domain without certificates and will provide you the option to view the page anyway. On Firefox, this is achieved by clicking "Advanced" and "Accept the Risk and Continue".
2. The first time you join your URL, you should be prompted to sign-in using your email address.

**Looking into Reticulum logs...**

1. It is useful to look into the backend of your K8s cluster using a free interface called Lens. During the setup process, Lens should automatically detect all accessible clusters associated with your Google Cloud account. You can then look into your individual cluster and its pods using the left-hand toolbar.
2. Select the pod for Reticulum and open its logs in the top right-hand corner of the details page. The logs icon is indicated by four horizontal lines with the fourth line shorter than the others.
3. After selecting the Reticulum logs, you should be able to view the processes occurring on the backend of your instance.

**Verify that SMTP is working correctly...**

1. With the Reticulum logs open, attempt to sign-in to your instance in the Web browser with your ADM_EMAIL email address.
2. If successful, Reticulum should register the request and you should receive an email from noreply@<HUB_DOMAIN>. After this, you can begin to create rooms, upload assets, and deploy scenes to your Hub!
3. If unsuccessful, Reticulum should log the reason for the error, which you can then use to troubleshoot.

**Verify your configuration values...**

1. Back in Lens, select the "Pods" tab in the left-hand toolbar and select your Reticulum pod.

2. Open the "Pod Shell" to ssh into your Reticulum pod. This icon should be immediately left of the "Pod Logs" icon.

3. In the Pod Shell, run the following command:

   cat config.toml

4. This will return the values you have used to configure your deployment. Verify the values running match your intended values.

**Update configuration values and redeploy...**

1. You can re-run the command to deploy Community Edition with updated configuration values at any time.
2. After re-deploying your configuration, you will have to cycle your current pods for any changes to take effect. This can be achieved by simply deleting all/individual pods using the Lens interface on the "Pods" tab. Thanks to Kubernetes, Community Edition will automatically attempt to create a new pod containing the latest updates.

💡

Be advised that terminating pods may compromise and delete important data. While useful for troubleshooting during the deployment process, you should not arbitrarily terminate K8s pods in a production environment.

## Step 7: Configure Certificates

The last step of this guide is to configure certificates in order to secure your instance and get rid of the automatic SSL warnings on your Web browser. The Community Edition GitHub README specifies that there are two options for configuring certificates:

A. You can deploy the Hubs team's certbotbot service.
B. You can manually configure certificates using the command line or an interface like Lens.

For this tutorial, we will stick with **Option A.**

1. Editing `cbb.sh` in VSCode, replace the following **required **parameters with your chosen configurations:
   **ADM_EMAIL **| The same email address you specified in `render_hcce.sh`
   **HUB_DOMAIN** | Your domain from Route53.
   **Namespace** | YOUR_DESIRED_NAMESPACE from your K8s cluster.

2. Once you have configured the required parameters, run the following command to add the service to your K8s cluster. The script will step through issuing certificates for <you-domain>, stream.<your-domain>, cors.<your-domain>, and assets.<your-domain>.

   bash cbb.sh

3. After you have issued certificates for all four of your subdomains, you will need to comment out the default certificate user by haproxy on initial deployment. Search for `--default-ssl-certificate={your-namespace}/cert-hcce` and comment out/delete it before re-applying your yaml file with `kubectl apply -f {path to your hcce.yaml file} -n {your-namespace}`.

Once this is complete, you should be able to access your domain without any ssl issues!

## Conclusion

We hope that this guide has been informative about the technology that makes up Hubs Community Edition and helpful as you set up your own instance. As a reminder, this guide is a quick start and there are many upgrades you should consider to make your version of Community Edition production-ready.

- **Scalability** | Instances created with this method can support ~15 concurrent users. You can increase capacity by adding additional services for horizontal and vertical scaling.
- **AWS SMTP sandbox** | Instances created with this method may have limits on the emails they can send to users of their Hub. The process for requesting a limit increase is the same as Hubs Cloud and is [documented here](https://hubs.mozilla.com/docs/hubs-cloud-aws-troubleshooting.html#youre-in-the-aws-sandbox-and-people-dont-receive-magic-link-emails).
- **Dev Ops for Custom Apps** | Instances created with this method will automatically track with the latest version of Hubs codebases. We know that many developers will want to deploy their own versions of the Hubs Client, Reticulum, and Spoke. Doing so will require you to set up your own deployment system. **Stay tuned** for more documentation about this process in the coming months.
- **Migrate Your Hubs Cloud Data** | Existing Hubs Cloud customers may want to migrate their existing data to their Community Edition instance. **Stay tuned **as we release automated tools and documentation over the coming months to make this process fast and easy.

We are so excited to see how the community uses this new technology and can't wait to hear more from you about how to improve Community Edition. The best way to share your thoughts and stay up-to-date on the latest developments is to [join our Discord server](https://discord.gg/v8xTFVNA) and check out the #community-edition channel.

Lastly, if you have experience with Kubernetes or self-hosting Hubs and want to share your own documentation, we are currently accepting applications from capable developers for paid documentation commissions. Complete [this interest form](https://forms.gle/NBnSDdqePUUF74QWA) and we will contact you with more details.

## Update: December 2023

### Hey Readers, I am updating this document with a new section on configuring settings found in Hubs Cloud's version of the admin panel and how to deploy a custom version of any of the services that make up Hubs using the process that the Hubs team uses!

## Configure Admin Settings

Hubs Community Edition uses much of the same code as the Hubs Subscription, including its version of the admin panel. A key difference between this version of the admin panel and Hubs Cloud's version of the admin panel is the difference in fields to configure certain settings, including...

- Extra Content Security Policy Rules, including those which allow developers to access external APIs
- Extra Headers, HTML, and scripts for avatars, rooms, and scenes

With Community Edition, these settings are still configurable when deploying your charts to a K8s cluster. To configure these, look `config.toml.template` and enter your desired values into these portions of the chart:

    [ret."Elixir.RetWeb.Plugs.AddCSP"]
    child_src = ""
    connect_src = "wss://*.stream.<DOMAIN>:4443"
    font_src = ""
    form_action = ""
    frame_src = ""
    img_src = "nearspark.reticulum.io"
    manifest_src = ""
    media_src = ""
    script_src = ""
    style_src = ""
    worker_src = ""

    [ret."Elixir.RetWeb.PageController"]
    skip_cache = false
    extra_avatar_headers = ""
    extra_index_headers = ""
    extra_room_headers = ""
    extra_scene_headers = ""

    extra_avatar_html = ""
    extra_index_html = ""
    extra_room_html = ""
    extra_scene_html = ""

    extra_avatar_script = ""
    extra_index_script = ""
    extra_room_script = ""
    extra_scene_script = ""

For example, if I want to allow my hub to call the OpenAI APIs for prompt moderation and image generation, my code for `script_src` would look like the following with each url separated by a single space:

    script_src = "https://api.openai.com/v1/moderations https://api.openai.com/v1/images/generations"

## Deploy Custom Apps

By default, Community Edition tracks with the latest release of the Hubs code bases contained in our public docker registries. Many developers may wish to deploy their own version of Hubs' various code bases. Here, we'll step through the process that the Hubs teams uses with GitHub Actions to build your own docker registries and how to have your Community Edition instance use this code.

1. First, create a [docker hub ](https://hub.docker.com/)account and, optionally, a registry for your image. By default, docker hub will create a registry with your username.
2. Fork the Hubs code base you would like to customize in GitHub (you must have a GitHub account to do so). For this tutorial, we'll use [the Hubs client](https://github.com/mozilla/hubs) and use the master branch as a starting point for adding our customizations.
3. When you have made your customizations and are ready to deploy, go to `.github/workflows/` and add a file called `ce-build.yml` and populate with [this code](https://github.com/mikemorran/hubs/blob/master/.github/workflows/ce-build.yml) created by Hubs Team member, Brandon Patterson. Once complete, ensure these changes are checked-in and merged with your fork's master branch.
4. Navigate to the Actions section of your GitHub repository. After adding and committing `ce-build.yml`, you should see “ce” listed as an action.
5. Go to the settings tab of your fork, select "Secrets and Variables" and "actions". Create a new repository secret titled "DOCKER_HUB_PWD". In the secret value, either input your docker hub password or create an access token in docker hub and use the password from that secret.
6. After saving the secret, go back to the "Actions" tab, select "ce" and select "Run Workflow." In the pop-up, choose the master branch, leave the "Code path" blank, enter your docker hub username, make sure the dockerfile is `RetPageOriginDockerfile`, and enter your docker hub registry name.
7. Wait for the build to complete successfully. You can check the successful deployment in docker hub.
8. Lastly, we have to update our community edition deployment to use our customized version of the Hubs client. Within `hcce.yaml`, instead of pointing to `mozillareality/hubs:stable-latest`, point to your docker image with the deployed code.

## Update: March 2024

### Hey Readers, I am updating this document with a new section on an alternative method of running render_hcce.sh using Docker and how to set up persistent volumes.

## Using Docker for render_hcce.sh

`render_hcce.sh` is the script that allows us to populate our hcce.yam file with our instance specifications. This script outputs a hcce.yaml file that we can then deploy to our instance. Out of the box, developers who run render_hcce.sh may encounter issues unique to their operating system depending on their device's compatibility with the script. Well, I would like to show you how you can use Docker to run render_hcce.sh, avoiding any issues that may occur with your operating system. Thank you to Alex Griggs (aka @Doginal on github) for your PR contributing this method!

**Prerequisites**
In order to attempt this method, you must have [Docker](https://www.docker.com/) installed on your device.

**How To...**

1. Create a new file titled `Dockerfile` in the community-edition directory of your local version of the [hubs-cloud](https://github.com/mozilla/hubs-cloud) repo. Populate it with this code...

   from ubuntu:22.04

   RUN apt update && apt upgrade -y
   RUN apt install -y openssl npm gettext-base
   RUN mkdir -p /app
   WORKDIR /app
   COPY . .
   RUN chmod +x /app/render_hcce.sh

   RUN npm install pem-jwk -g

   CMD [ "/bin/bash", "-c", "/app/render_hcce.sh" ]

2. Build your container by running `docker build . -t hubs-ce-builder:latest`.

3. Run the following command to create your hcce.yaml file: `docker run --rm -it -v {path-to-your-community-edition-director}:/app hubs-ce-builder:latest`

This command should create a hcce.yaml file that you can then apply to your instance, all while avoiding issues unique to your operating system!

## Persistent Volumes

Out of the box, Community Edition instances will attempt to write data, such as scene information or custom avatars, to the pgsql and reticulum pods. When we delete these pods, we also delete the data associated with them. Persistent Volumes allow us to move our data outside of the pod lifecycle to ensure that our data will be available even after our pods delete and respawn. Please note, the method outlined below only works if you have one pgsql instance and one reticulum instance running on your node cluster. Thank you to Hrithik Tiwari for helping contribute this knowledge to the community!

1. Create a yaml file for our pgsql pod's persistent volume called persist-pgsql-pv.yaml with the following code. Be sure to replace with your namespace and customize the storage capacity based on your needs.

   ***

   # pgsql persistent volume storage

   ***

   apiVersion: v1
   kind: PersistentVolume
   metadata:
   name: pgsql-pv
   labels:
   type: local
   spec:
   storageClassName: manual
   capacity:
   storage: 10Gi
   accessModes: - ReadWriteMany
   claimRef:
   namespace: {REPLACE-WITH-YOUR-NAMESPACE}
   name: pgsql-pvc
   persistentVolumeReclaimPolicy: Retain
   hostPath:
   path: "/tmp/pgsql_data"
   type: DirectoryOrCreate

   ***

2. Apply the file by running `kubectl apply -f {path-to-your-persist-pgsql-pv.yaml-file}`.

3. Create a yaml file for our pgsql pod's persistent volume claim called persist-pgsql-pvc.yaml with the following code. Be sure to replace with your namespace.

   ***

   # pgsql persistent volume claim

   ***

   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
   name: pgsql-pvc
   namespace: {REPLACE-WITH-YOUR-NAMESPACE}
   spec:
   accessModes: - ReadWriteOnce
   resources:
   requests:
   storage: 10Gi

   ***

4. Apply the file by running `kubectl apply -f {path-to-your-persist-pgsql-pvc.yaml-file}`.

5. Repeat the process for the reticulum pod's persistent volume and persistent volume claim. Be sure to replace with your namespace and customize the storage capacity based on your needs.

   ***

   # reticulum persistent volume storage

   ***

   apiVersion: v1
   kind: PersistentVolume
   metadata:
   name: ret-pv
   labels:
   type: local
   spec:
   storageClassName: manual
   capacity:
   storage: 10Gi
   accessModes: - ReadWriteMany
   claimRef:
   namespace: hcce-mikemorran
   name: ret-pvc
   persistentVolumeReclaimPolicy: Retain
   hostPath:
   path: "/tmp/ret_storage_data"
   type: DirectoryOrCreate

   ***

   ***

   # reticulum persistent volume claim

   ***

   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
   name: ret-pvc
   namespace: {REPLACE-WITH-YOUR-NAMESPACE}
   spec:
   accessModes: - ReadWriteOnce
   resources:
   requests:
   storage: 10Gi

   ***

6. After we have applied our persistent volumes and persistent volume claims, we will need to reference them in our hcce.yaml file under the specifications for pgsql and reticulum respectively. Search for `path: /tmp/ret_storage_data` and replace the volumes spec for reticulum with the following code:

   volumes: - name: storage
   persistentVolumeClaim:
   claimName: ret-pvc # hostPath: # path: /tmp/ret_storage_data # type: DirectoryOrCreate - name: config
   configMap:
   name: ret-config

7. Repeat for pgsql. Search for `path: /tmp/pgsql_data` and replace the volumes spec for pgsql with the following code:

   volumes: - name: postgresql-data
   persistentVolumeClaim:
   claimName: pgsql-pvc # hostPath: # path: /tmp/pgsql_data

8. Apply your updated hcce.yaml file using `kubectl apply -f {path-to-your-yaml} -n {your-namespace}`.

After this is complete, our reticulum and pgsql pods will write data to our node cluster, not each individual pod, allowing data to persist regardless of the pod lifecycle or which node our pod may be scheduled on.

## Update: April 2024

### Hey Readers, I am updating this document with a new section on setting up external database storage for our instance. To be production ready, we will demonstrate how to use Network Attached Storage on GCP (Filestore) for reticulum and a PostgresSQL database on GCP SQL to replace our pgsql kubernetes pod.

## SQL Database Instead of a pgsql Pod

pgbouncer sits between reticulum and its databases storage and manages/balances requests from clients who ask reticulum to read and write data when they upload scenes or avatars. When you install community edition, by default, the deployment spec includes a dedicated pgsql kubernetes pod which will act as the database instance that pgbouncer connects to. While this is great for initial setup and development, we will likely want to add an external database to replace this pgsql pod. This is standard for making our instance more production ready and is exactly what Hubs Cloud users on AWS would have used RDS for.

1. Create your SQL pod on GCP by searching for SQL and selecting "Create Instance".
2. Select PostgresSQL and choose your instance specifications depending on your desired capacity. For PSQL on GCP, make sure to use version 12 for out-of-the box support (this is because version 12 defaults to md5 encryption, [there are ways](https://stelang.medium.com/how-to-change-encryption-type-from-scram-sha-256-to-md5-in-postgres-for-password-authentication-263312aa1f5a) to change the default of higher versions to md5). Under "Configurations Options" -> "Connections" make sure to enable "Private IP" and select the same network that your GKE cluster is on. Also enable "Enable Private Path".
3. Create your instance and wait for it to finish. Make sure to remember your password.
4. After the instance is created, go to the "Databases" tab and add a new database called "retdb".
5. Return to the "Overview" tab and copy down your Private IP.
6. Update your render_hcce.sh's DB_PASS with your SQL instance's password and re-run the script to populate your hcce.yaml. This should update all mentions of DB_PASS throughout hcce.yaml, but most importantly in PSQL and PGRST_DB_URI.
7. Before applying, search through your hcce.yaml file for the mention of DB_HOST in both the pgbouncer and pgbouncer-t sections. Update the value of each DB_HOST section with your SQL instance's private IP.
8. Re-apply your deployment spec with `kubectl apply -f {path to file} -n {namespace}`. If you have correctly provisioned your database on the same network as your kubernetes cluster, it should work immediately.
9. After you have connected to your external instance, it is no longer necessary to run a pgsql pod in your deployment. You can disable this by scaling down the deployment using the interface or commenting it out in hcce.yaml and re-applying the spec.

💡

If you are using an external storage system like this, you no longer need to use persistent volumes.

## Network Attached Storage for Reticulum using Filestore

When you are uploading images, audio, video, or 3D models to your reticulum pod, by default you are writing this data to the disk of your virtual machine, either in the pod or using persistent volumes. To be more production-ready, you will want to write this data outside of your node cluster in order to fully protect it from the lifecycle of your virtual machines. We'll be using GCP's Filestore to write data with reticulum.

1. Search for "Filestore" in Google Cloud and select "Create Instance".
2. You will need to give your filestore a name, select the same network as the one your kubernetes cluster is on, and specify a configuration path in the "File share name". You should also provision your instance with the appropriate amount of storage given your use case.
3. Create your instance and wait for it to initialize. Once complete, locate the NFS mount point for your instance. This is made up of **an IP** followed by a **mount path**.
4. In your hcce.yaml deployment spec, we will want to change reticulum's volume specification for storage to the following...

   spec:
   volumes: - name: storage
   nfs:
   path: {Mount path for your NFS}
   server: {IP for your NFS} # hostPath: # path: /tmp/ret_storage_data # type: DirectoryOrCreate - name: config
   configMap:
   name: ret-config

5. Apply your deployment spec `kubectl apply -f {path to file} -n {namespace}` and restart your reticulum pod.

6. If you have properly provisioned your NFS on the same network as your kubernetes node cluster, reticulum should be able to write to this network attached storage without any errors.
