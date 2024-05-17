---
title: Hubs Cloud Community Edition Is Here!
slug: welcoming-community-edition
date_published: 2023-10-16T20:13:05.000Z
date_updated: 2024-02-15T19:49:13.000Z
excerpt: Today we are releasing Community Edition, a new way for developers to host their own version of the open-source Hubs codebase. In this announcement, we'll delve into what Community Edition is, how it came to be, and what to anticipate when setting up your very own Community Edition.
---

---

## Why We Are Ceasing Support for Hubs Cloud

When it was released in 2020,[ the dream of Hubs Cloud](https://gfodor.medium.com/the-path-to-mozilla-hubs-2697e635490d) was to "[let] people quickly self-host their own production-grade, customized version of Hubs, set up nearly identically to how we run things ourselves at Mozilla." Prior to Hubs Cloud, users could only access Hubs on a server managed by Mozilla. Hubs Cloud was created because our small team believed there was so much more that could be done if the tools could be put in the hands of other capable innovators.

And it worked! Since 2020, over a thousand Hubs Cloud instances have been created, the front-end of the Hubs codebase has been forked 1400+ times, and hundreds of small businesses, artists, and educators around the world continue to do work in the immersive web thanks to this decentralized infrastructure. By design, it is impossible for our team to fully understand the innovation that Hubs Cloud has powered (we simply don't collect the analytics), however it is also impossible to deny that it has changed the course of the web for good.

We believe that Hubs Cloud succeeded because it empowered proficient developers and determined hackers to quickly iterate without having to rely on our team for assistance. However, over time, we've been challenged to serve both of these user groups with the same product. To address this, we have spent the last year developing [the managed subscription](http://hubs.mozilla.com/#subscribe) and Community Edition to better serve our community’s needs.

As a result, earlier this year[ we announced](__GHOST_URL__/professional-plan-and-community-edition/) our decision to discontinue our support of Hubs Cloud on AWS, starting from January 1, 2024. This choice is driven by several factors:

- The Hubs team has been dedicating substantial resources to keep pace with Amazon's platform updates, often resulting in several weeks' delay in releasing critical changes to the AWS marketplace. We're aware that many Hubs Cloud customers have experienced frustration while waiting for us to address significant changes and bugs.
- AWS requires our team to update Hubs Cloud, but the AWS marketplace format makes it impossible to ensure compatibility with our customer's instances. The regular updates we make to Hubs do not automatically propagate to existing Hubs Cloud instances, and many (if not most) instances drift far behind the latest versions of the codebase. As a result, customers are forced to do substantial maintenance when upgrading to a new version of Hubs Cloud. This can be particularly time-consuming for customers who are not experienced with full-stack development.
- We understand that many organizations want to deploy Hubs on cloud computing platforms other than AWS.

While the era of Hubs Cloud is coming to an end, Mozilla recognizes the significance of this change and the impact it will have on our customers, many of whom rely on Hubs Cloud for their businesses. During this transition period, our goal is to offer our community options, tools, and time to adjust. Community Edition is one of the options available for existing Hubs Cloud customers to continue to host their own version of the Hubs codebase.

## What is Community Edition?

Community Edition is designed to help developers deploy the full Hubs stack on any Linux-based infrastructure, including AWS, Google Cloud, and even your own computer. In the same way that Hubs Cloud mimicked how the Hubs team ran the server managed by Mozilla, Community Edition mimics the infrastructure our team uses for the managed subscription service. Community Edition simplifies and automates most of the complex deployment process using Kubernetes, which is a containerized software orchestration system.

The obvious benefit of a solution like Community Edition is that it gives developers more choices for hosting Hubs. The less obvious benefit is that it offers greater flexibility when dealing with significant updates to a hosting platform. In the past, if there was a major update to the AWS platform, Hubs Cloud developers had to wait for our team to release a new version of AWS launch configuration. Community Edition eliminates this limitation.

Unlike Hubs Cloud, Community Edition is designed for developers who are well-versed with the *full* Hubs stack and comfortable navigating cloud hosting platforms. While we will be providing examples and guidance on how to host Community Edition, we will not designate a primary hosting platform, as we did with AWS for Hubs Cloud. Community Edition users will be responsible for researching, evaluating, and staying informed about the hosting options available to them.

Setting up Community Edition will require more effort than many of our current Hubs Cloud customers may be accustomed to. However, we believe that this direction best empowers our developer community. Many of you have already chosen to bootstrap and self-host the codebase on your own instead of using Hubs Cloud, and we hope that Community Edition will offer a more straight-forward approach for achieving your goals.

Community Edition lives in[ this Github repository](https://github.com/mozilla/hubs-cloud/tree/feature/ce/community-edition). At a high level, it consists of two Bash scripts, each with a corresponding .yam file, and a README that outlines the prerequisites for deploying Community Edition as a Kubernetes cluster. Before deploying, developers are expected to choose their Kubernetes hosting platform and services that fulfill the prerequisites, such as a DNS and SMTP provider. After deploying, users will have a functional version of Hubs and Spoke that can be accessed on their specified domain name. Fresh Community Edition instances will require developers to configure additional services to reach the production-level features that they may be accustomed to with Hubs Cloud.

## Tutorials for Community Edition

Community Edition imposes minimal limitations on how you can host it and there are countless combinations of services that can be employed to set up Community Edition. While the Hubs team won't be able to document every possible combination, today we are [releasing a case study](__GHOST_URL__/community-edition-case-study-quick-start-on-gcp-w-aws-services/) demonstrating one way developers can set up Community Edition and its required services.

At the time of writing, this method closely mirrors the way the Hubs team manages Hubs subscription instances using both Google Cloud and services on AWS. We anticipate that the demonstrated method may become deprecated in the future, however we hope this documentation will continue to serve as a comprehensive overview of Community Edition's setup.

In addition to this case study, we are planning to collaborate with trusted community members to create documentation showcasing other methods for hosting Community Edition. If you are interested in being considered for a potential documentation commission, please complete [this interest form](https://forms.gle/ampL1368jZNeqiqt5) and we will get in touch with more details.

Even if you do not produce a commission, we strongly encourage knowledgeable developers to familiarize themselves with the Community Edition hosting process and to watch the #job-board of our [Discord server](https://discord.gg/v8xTFVNA) during this transition period. We recognize that a vibrant informal economy was created around Hubs Cloud, allowing for reputable developers to monetize their services; we anticipate similar opportunities for freelance developers to assist the hundreds of existing Hubs Cloud customers migrate to Community Edition.

## What If I Don't Have The Resources To Use Community Edition?

💡

**On Tuesday, February 13th, 2024, Mozilla announced that Hubs will be shut down this year. Hubs Cloud users should not migrate to the Hubs Professional Plan, as it will be impacted by this shutdown.**

The Hubs Team acknowledges that Community Edition will not be accessible for all of our existing Hubs Cloud customers. For those looking for a suitable alternative, our managed [Hubs Professional Plan](https://hubs.mozilla.com/#subscribe) aims to provide many of the key features that Hubs Cloud users depend on, including the admin panel, custom domains, and custom client deployment. The cost of Hubs Professional ($79/month) is comparable to the monthly cost of a Personal Hubs Cloud instance on AWS with cost-saving settings enabled.

There are two notable limitations of the Hubs subscription that may dissuade current Hubs Cloud customers from choosing this alternative: fixed concurrent user (CCU) limits and inaccessibility of paid subscriptions to those outside of our 33 supported countries. To provide the broadest range of options, we are opening [a form](https://forms.gle/NFCVTBKEvLHUA5or7) for current Hubs Cloud customers to request special access to Hubs Professional, particularly those residing outside our supported countries or facing resource constraints that make using Community Edition a challenge. Requests will be processed on a case-by-case basis, and interested customers can expect a response within 10 business days.

## FAQs

- What is the timeline for migrating away from Hubs Cloud on AWS?

We will be ceasing to support Hubs Cloud on AWS starting on January 1, 2024. Existing Hubs Cloud instances** will not** be automatically shut off on January 1. On that date, we will de-list Hubs Cloud from the AWS marketplace to disable new sign-ups. Existing customers will then have a minimum of 90 days to migrate to another Hubs service before their subscriptions to Hubs Cloud come to an end. The earliest date for these subscriptions to cease will be March 30th.

- Can I keep using my existing Hubs Cloud instance?

Developers may continue to use their subscription and manually maintain their instances until we fully remove Hubs Cloud from the AWS marketplace (March 30th, 2024 at the earliest). After January 1, it is difficult to predict which AWS platform updates released will impact current Hubs Cloud customers, given the variability in current Hubs Cloud instances. Many customers, whose instances were created years ago, may not have kept their code current with the updates that have been released. However, if you have experience with AWS development, there's no reason you cannot manually troubleshoot these issues yourself to continue using your existing instance.

- Will there be tools to migrate my data off of an existing Hubs Cloud instance?

Yes! We are currently working on tools to automate the data migration process from existing Hubs Cloud instances to Community Edition and Managed Subscription instances. These tools may vary from platform to platform, however expect to see them released in the lead-up to January 1st. [Join our Discord server](https://discord.gg/v8xTFVNA) and check out the #community-edition channel to stay tuned!
