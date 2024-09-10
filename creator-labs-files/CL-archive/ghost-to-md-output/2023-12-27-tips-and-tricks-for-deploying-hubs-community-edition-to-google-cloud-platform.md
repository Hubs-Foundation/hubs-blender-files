---
title: Tips and Tricks for Deploying Hubs Community Edition to Google Cloud Platform
slug: tips-and-tricks-for-deploying-hubs-community-edition-to-google-cloud-platform
date_published: 2023-12-27T16:59:29.000Z
date_updated: 2023-12-27T16:59:29.000Z
excerpt: Perfect for those new to Kubernetes, Kieran Farr's guide takes you through many useful lessons and recommendations to consider when getting started with Community Edition.
---

---

> [!IMPORTANT]
> **Editor's Note:** This article is based on the bash version of Community Edition, to follow along you will need to use the bash scripts from https://github.com/Hubs-Foundation/hubs-cloud/tree/bash-version

## What is Mozilla Hubs?[​](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#what-is-mozilla-hubs)

Hubs is an [open-source 3D conferencing cloud software](https://labs.mozilla.org/projects/hubs/) that works across every browser and VR, AR headsets like the Oculus Quest. Users create "Rooms" and invite other users to join with live video and audio streaming like Zoom or Google Meets but for users with XR headsets they can choose live-animated 3D avatars connected to the XR headset and controllers for an immersive experience.

I’ve been a long time user of Hubs. During the pandemic our small but mighty marketing team at Bitmovin got Oculus Quest headsets and used Hubs for internal meetings. We had the most fun when interacting in a custom virtual space that a 3D artist helped us create, bespoke for a virtual conference that we eventually hosted open to the public.

## **Why Hubs Community Edition?**

Our WebXR app [3DStreet](https://3dstreet.org) launched this year to empower anyone to visualize a safer, greener world, one street at a time. 3DStreet users have asked for collaboration features, but our team is small and integrating multi-user presence and conferencing into 3DStreet would be difficult and time consuming. How can we offer remote, virtual collaboration tools without major rewrites of our 3DStreet application?

I considered a few options for this and chose to try out a newly launched option from Mozilla Hubs: “[Community Edition](__GHOST_URL__/welcoming-community-edition/)” – a new way for developers to host their own version of the open-source Hubs codebase on their own infrastructure.

## **Why Google Cloud Platform?**

3DStreet’s cloud services are hosted primarily on Google’s Firebase service. When considering launching a customized Hubs service, we wanted to keep all of our infrastructure in one place and decided to work on launching Hubs Community Edition in GCP.

## **Starting Point for Community Edition on GCP**

The best starting point for deploying Hubs Community Edition on GCP is this Mozilla piece [CE Quick Start on GCP](__GHOST_URL__/community-edition-case-study-quick-start-on-gcp-w-aws-services/). In addition to being a great starting point, it’s a helpful ongoing reference for the “vanilla” deployment of Community Edition and Michael continues to revise it based on feedback.

In the rest of this post I share my notes from my run through on setting up Hubs CE on a custom domain for 3DStreet. This includes a condensed set of instructions on just what you need to get started and how to deal with the “gotchas” on the way.

### **Project Structure in Google Cloud Platform**[**​**](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#project-structure-in-google-cloud-platform)

GCP use of Projects is a very handy way to structure cloud services, I strongly recommend creating a dedicated project for your Hubs CE deployment. In our case we already have a project for 3DStreet Cloud production, and another project for 3DStreet Dev Server which is a copy of production for testing against, so adding another for Hubs is simple and fits in this existing structure. You can get other features by "leaning in" to this structure such as distinct user rights management and billing settings for each project.

## Domain and DNS Setup[​](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#domain-and-dns-setup)

I used an old domain lying around 3dstreet.club which was registered with GoDaddy, and used [GCP for DNS hosting](https://cloud.google.com/dns) for the project. Using GCP to [setup Cloud DNS hosting zones was straightforward](https://cloud.google.com/dns/docs/set-up-dns-records-domain-name), once I [updated the GoDaddy domain to use custom nameservers](https://www.godaddy.com/help/edit-my-domain-nameservers-664) pointing to the new GCP Cloud DNS zone.

## Email SMTP Server and Forwarding[​](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#email-smtp-server-and-forwarding)

You'll need an SMTP server for Hubs to send emails for authentication and, believe it or not GCP, doesn’t have a native SMTP email solution. Thanks to some recommendations from others on the Hubs Discord, I tried out [Elastic Email's SMTP free tier](https://elasticemail.com/referral-reward?r=2d26b9c5-2367-4c1a-a658-b9eaba965057) (you read that right, $0 / month) and it worked great. I also use [ImprovMX for email forwarding](https://improvmx.com/) to receive email from various addresses across multiple domains.

## **CLI Cheat Sheet[​](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#cli-cheat-sheet)**

Here are the most critical command lines for deploying your Hubs scene -- you'll be using these over and over again if you're testing and changing deployment settings. This assumes you have everything else setup. Reference [the Mozilla Quick Start guide](__GHOST_URL__/community-edition-case-study-quick-start-on-gcp-w-aws-services/) for a step-by-step guide on how to get your local dev environment setup.

### **Create cluster in GCP[​](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#create-cluster-in-gcp)**

`gcloud container clusters create <YOUR_DESIRED_NAMESPACE> --zone=<YOUR_DESIRED_ZONE>`

For this example project I'm using zone: "us-central1" and namespace: "hcce"

`gcloud container clusters create hcce --zone us-central1`

I strongly recommend using the default cluster and namespace names like "hcce" suggested in the [Quick Start Guide](__GHOST_URL__/community-edition-case-study-quick-start-on-gcp-w-aws-services/).

### **Deploy to newly created cluster with custom settings[​](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#deploy-to-newly-created-cluster-with-custom-settings)**

After editing, use `render_hcce.sh` to render yam into yaml, placing appropriate environment variables like your Hub domain, email and namespace. Then use kubectl to apply this generated yaml file to your cluster. Here is the magic line that combines both, you’ll probably use this quite a bit setting up Hubs CE:

`bash render_hcce.sh && kubectl apply -f hcce.yaml`

Then wait until you get an "External IP" from this command:

`kubectl -n hcce get svc lb`

And wait until all 11 pods are ready from this command:

`kubectl get deployment -n hcce`

Use the External IP to set as A record for all 4 domains in DNS Zone: domain, assets.domain, stream.domain, cors.domain.

Then run the script to setup certificates for the domains after placing appropriate environment variables:

`bash cbb.sh`

You should be able to access your Hubs server on a web browser and see no certificate warnings at this stage. Now you can begin customizing your admin settings, the Hubs client, and other exciting ideas that come to mind.

### **"Pausing" the cluster[​](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#pausing-the-cluster)**

Kubernetes doesn't have the concept of "pausing" a cluster. Instead you can scale it down to 0 replicas with this command which effectively pauses the cluster and importantly does not bill compute time:

`kubectl scale --replicas=0 -f hcce.yaml`

By default the Hubs CE Kubernetes deployment has 1 replica of each pod. Therefore, when you’re ready to resume your server you can do it with this command:

`kubectl scale --replicas=1 -f hcce.yaml`

### **Deleting all the pods**

If you want to make sure that your pods are fully wiped after making changes to yaml or other server configuration, then you can run this command to delete and pods associated with the yaml file:

`kubectl delete -f hcce.yaml -n hcce`

### **Deleting the entire cluster[​](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#deleting-the-cluster)**

If you’re ready to shut down the cluster for good, or want to wipe from scratch and start the process over, you can delete the entire cluster with this command:

`gcloud container clusters delete hcce --region=us-central1`

I found this helpful during testing of the deployment process itself to double check that all of the steps from creating a new gcloud container to rendering and applying yaml to the cluster can be replicated exactly.

### **Create GCP firewall rules to open ports for Hubs**

By default, Google Kubernetes Engine will not open all of the ports required for Hubs Community Edition to be able to provide real-time voice communication. You’ll need to set up the following firewall rules using these Google Cloud CLI commands:

#### **For TCP port 4443:**

`gcloud compute firewall-rules create rule-name-1 --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:4443 --source-ranges=0.0.0.0/0`

#### **For TCP port 5349:**

`gcloud compute firewall-rules create rule-name-2 --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:5349 --source-ranges=0.0.0.0/0`

#### **For UDP ports 35000 to 60000:**

`gcloud compute firewall-rules create rule-name-3 --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=udp:35000-60000 --source-ranges=0.0.0.0/0`

### **Quota Limits**[**​**](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#quota-limits)

You will hit quota limits -- the defaults in GCP are too low for IP address limits and Persistent Disk SSD total storage capacity (GB). You will need to go into the [GCP Console > IAM & Admin > Quotas](https://console.cloud.google.com/apis/api/compute.googleapis.com/quotas) to make a quota request to increase these. Persistent disk storage upgrade from 500gb to 1000gb. IP addresses raise limit to 16.

## **Debugging when things go wrong**[**​**](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#when-things-go-wrong)

Automated server deployment with Kubernetes magically works -- until it doesn't. Unfortunately, when it doesn't work you will need to dig through a lot of layers of clusters, nodes, and pods (oh my!) to see what's going wrong. Here are the techniques I used to deal with debugging issues when they arise.

### **Hubs Discord Community**

The #1 source of help for me has been the #community-edition channel on the Hubs Discord. Not only has the community been helpful in identifying issues, but we have also worked together discussing and creating possible solutions. These discussions provide the foundation for distilling them down into Issues.

### **Mirantis Lens**

An excellent alternative to using command line tools for managing CE deployment is [Mirantis Lens](https://k8slens.dev/) – a very helpful tool to very quickly poke around at your cluster and see what is going on “under the hood.” Lens provides an “at a glance” visual dashboard of the status of your pods, along with a dead simple user interface to access logs and even access a remote shell of each of your pods – critical when something isn’t going well.

One word of warning about “dark patterns” in Lens Desktop – it will push you toward a Pro license trial at the end of which Lens will appear to be disabled. Don’t despair, you’ll need to revisit your Lens cloud account at [https://app.k8slens.dev/](https://app.k8slens.dev/) and make sure that you’ve enabled your free Personal license to Lens desktop after your Pro trial license expires.

### **`kubectl` command line tools**

In theory, `kubectl` command line tools give you everything you need to manage your cluster, however at first I found the complexity of these CLI tools to be daunting. Instead, I started with Mirantis Lens (above) for initial exploration of the CE deployment, finding it to be a much faster GUI-based method. I then returned to `kubectl` commands once I had a better understanding of their purpose and wanted to do repeated actions more quickly.

I found myself returning time and again to these commands while debugging:

- `kubectl get deployment -n hcce` simply lists out all the pods as part of the deployment which includes their status is helpful each time you’re launching pods
- `kubectl logs -f <pod-id>` felt like a superpower to be able to see live logs from troublesome pods
- `kubectl exec --stdin --tty my-pod -- /bin/sh` if it was really bad then this command could let you open a shell into the pod.

This [kubectl Quick Reference](https://kubernetes.io/docs/reference/kubectl/quick-reference/) was my favorite guide for finding these shortcuts and more.

### **Filing Issues**

As old-school as it may be, I found that filing issues on the appropriate GitHub repositories – [mozilla/hubs](https://github.com/mozilla/hubs/issues) or [mozilla/hubs-cloud](https://github.com/mozilla/hubs-cloud/issues) – has been very effective in providing a “grounding” of issues from which to discuss and propose solutions. Here are some examples of how I formatted some issues I encountered. Issues that relate to the core Hubs client go in [mozilla/hubs](https://github.com/mozilla/hubs/issues) whereas issues specific to CE deployment should be placed in [mozilla/hubs-cloud](https://github.com/mozilla/hubs-cloud/issues). Here are a few example issues that you can use as examples on how to file your own:

- [https://github.com/mozilla/hubs/issues/6418](https://github.com/mozilla/hubs/issues/6418) - npm ci build fail
- [https://github.com/mozilla/hubs-cloud/issues/322](https://github.com/mozilla/hubs-cloud/issues/322) - error applying user-supplied domain cert
- [https://github.com/mozilla/hubs-cloud/issues/325](https://github.com/mozilla/hubs-cloud/issues/325) - JsonWebTokenError
- [https://github.com/mozilla/hubs-cloud/issues/326](https://github.com/mozilla/hubs-cloud/issues/326) - Inline script security error

### **If you find a fix, suggest a Pull Request**

Part of the magic of the community-based approach of Hubs is the ability for users to help make the improvements they want to see. After an issue has a proposed solution that solves your problem, it’s highly appreciated to give back to the community in the form of a Pull Request (PR) to share that fix back with others. Here are two simple examples of PRs that I created while fixing some of the issues above:

- [https://github.com/mozilla/hubs-cloud/pull/323](https://github.com/mozilla/hubs-cloud/pull/323) - proposed fix use user-supplied domain for default ssl cert
- [https://github.com/mozilla/hubs/pull/6425](https://github.com/mozilla/hubs/pull/6425) - accepted and merged fix for npm ci build fail

### **Billing and cost considerations**[**​**](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#billing-and-cost-considerations)

For a given GCP Project we can check out billing history while excluding costs incurred from other Projects on our accounts, so I ran a report for just the Hubs CE Project. I've seen about $14 per day cost for compute and Kubernetes engine which was a bit more than I expected, and more expensive than the $79 fully managed Hubs Professional plan.

## **Scoping Hubs client customizations**

Our project goal is to allow a user to click a button inside of a 3DStreet.app scene and launch a Hubs room using that scene.

We do this by using a glTF file as an intermediary -- the 3DStreet.app will create a glb (all-in-one compressed binary glTF file representing the 3DStreet scene) and then storing it on the 3DStreet server.

Therefore, we’ll need to modify the Hubs client to reference this 3DStreet glb file to present in the user's scene when they create a new Hubs Room.

### **Hubs Client customization**[**​**](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#hubs-client-customization)

To support the above workflow, we need to modify the Hubs client in 2 places:

First, we need to capture the path of the 3DStreet Scene GLB when the user clicks on the link to leave 3DStreet.app and load the custom CE Hubs instance at 3DStreet.club.

Then, after the user creates a new Hubs Room on the server, we need to add that GLB to the scene that we saved when the user first loaded the custom CE Hubs instance.

### **Modifying HomePage.js in Hubs client**

The first file we'll modify is HomePage.js -- part of the Hubs client React code used when a user first lands on our custom Hubs CE homepage. We want to capture the path of the 3DStreet GLB file. We can do this by adding some code around line 28 to fire when the page is loaded.

`//This takes a page location such as "https://myhubs.club/index.html#https://3dstreet.app/file.glb"
// and saves to local storage just the part after the # symbol such as "https://3dstreet.app/file.glb"
const gltfPath = window.location.hash.substring(1);
localStorage.setItem('gltf-path', gltfPath);`

### **Modifying hub.js​ in Hubs client**

The second file we'll modify is hub.js. This is a critical file used in the core instantiation of Hubs logic such as voice communication, user interface, physics, etc. We are doing our best to "tread lightly" and only run our code after the entire scene is instantiated. To do this, we piggyback off of an existing onSceneLoaded function [in line 780](https://github.com/mozilla/hubs/blob/master/src/hub.js#L780).

Here is how we modified hub.js to add the 3DStreet glb from the path saved in local storage:

`const onSceneLoaded= () => {
// existing physics setup here
// Load 3DStreet glb path from local storage
var streetEl = document.createElement('a-entity');
const gltfPath = localStorage.getItem('gltf-path');
streetEl.setAttribute("media-loader", { src: gltfPath, fitToBox: true, resolve: true })
streetEl.setAttribute("networked", { template: "#interactable-media" } );
streetEl.id = 'streetEl';
streetEl.setAttribute('scale', '100 100 100');
streetEl.setAttribute('position', '0 1 0');
document.getElementById('objects-scene').append(streetEl);
};`

### **Deploying Hubs Custom Client to Community Edition**[**​**](http://localhost:3000/blog/mozilla-hubs-and-3dstreet-virtual-safe-street-collaboration#deploying-hubs-custom-client-to-community-edition)

After making those changes, I committed those to a [fork of Hubs on my own GitHub account](https://github.com/kfarr/hubs/tree/master). Then I followed these instructions compiled by Michael Morran for deploying the newly customized Hubs client to the Kubernetes cluster in GCP.

1. First, create a docker hub account and, optionally, a registry for your image:[ https://hub.docker.com/](https://hub.docker.com/)
2. Fork hubs: [https://github.com/mozilla/hubs](https://github.com/mozilla/hubs) and use the master branch as a starting point for adding your customizations.
3. When you are ready to deploy, go to .github/workflows/ and add a file called ce-build.yml and populate with the following code created by @BrandonP:[ https://github.com/mikemorran/hubs/blob/master/.github/workflows/ce-build.yml](https://github.com/mikemorran/hubs/blob/master/.github/workflows/ce-build.yml). Ensure this is checked in and merged with your master branch.
4. Navigate to the Actions section of your GitHub repository. After adding and committing ce-build.yml, you should see “ce” listed as an action.
5. Go to the settings tab of your repo, select "Secrets and Variables" and "actions". Create a new repository secret titled "DOCKER_HUB_PWD". In the secret value, either put your docker password or create an access token in docker hub and use the password from that.
6. After saving the secret, go back to the "Actions" tab, select ce and select "Run Workflow." In the pop-up, choose your branch, leave code path blank, enter your docker username, make sure the dockerfile is RetPageOriginDockerfile, and enter your registry (by default, a registry will exist that is the same as your docker username).
7. Wait for the build to complete successfully. You can check the successful deployment in docker hub.
8. Adjust your CE deployment of hubs. Instead of pointing to mozillareality/hubs:stable-latest, point to your docker image with the deployed code, in my case it was `kieranfarr/ce:latest`.

## **Making Community Edition work for your project**

With the combination of the my guide and tips on this post and Michael’s [Quick Start Case Study](__GHOST_URL__/community-edition-case-study-quick-start-on-gcp-w-aws-services/), you should have everything you need to start launching your own Hubs Community Edition server.

As always, there is still more to finish to make it a perfect process, but the detailed guide and community support make it an accessible and scalable option for deploying customized 3D and metaverse conferencing solutions on your own infrastructure.

[Join the Mozilla Hubs Discord](https://discord.gg/QegTPRhy) server if you’d like more help getting started!
