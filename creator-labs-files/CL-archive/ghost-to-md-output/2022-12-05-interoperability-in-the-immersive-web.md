---
title: Interoperability in the Immersive Web - Part 1
slug: interoperability-in-the-immersive-web
date_published: 2022-12-05T21:25:35.000Z
date_updated: 2023-02-23T18:11:05.000Z
---

Interoperability is a hot topic in the “metaverse” circles these days. Standards organizations are advancing interoperability between different immersive technology apps. Companies and regulators alike are taking notice around the world.

Interoperability is the ability to move one’s content and identity from one platform to another with low switching costs. Systems that are interoperable need to be user-friendly and built on top of open standards. Most of the time, subject-matter experts define standards such that the public can observe the process. Defining the way that content can move around different applications is no easy task. There are contextual boundaries where it makes sense to have an abstract definition of content. There are some things that will likely never be interoperable.

The term “metaverse” is a wide-reaching one. It encompasses both technological and social constraints and experiences. When we talk about interoperability, it’s important to identify where it makes sense for a standard to offer data portability, and where it doesn’t. We wouldn’t expect Excel, for example, to be our first choice for handling video editing. When we consider standards in the metaverse, the first thing that we need to do is narrow down and define that problem space.

Drawing an abstraction boundary as part of the problem space is where the challenge of interoperability starts to get hard. If boundaries are drawn at too high of a level, then it becomes hard to differentiate or innovate around the content or data being moved. The applications become too rigid, and there isn’t much room for providing new value to users with innovative features. On the flip side, if standards boundaries are drawn at too low of a level, then the benefits of being interoperable get lost.

A good example of the difficulties of interoperability is[ Rami Ismail’s Twitter thread on making an interoperable pair of dice](https://mobile.twitter.com/tha_rami/status/1480404367459168258). If we start with the 3D model - the mesh, materials, and textures - we start with a decent place for standardization. But, depending on where the dice will be used, the appearance may vary based on how lighting works in the application. If there is a physics engine, the orientation and scale of the dice may make the dice “roll” differently. You can see how, with just a small type of interaction, portability immediately becomes harder.

Some types of content can be portable within the same engine or application, or between two specific platforms. While this is a good start to application interoperability, doesn't quite make an “open standard”. So what _are_ good examples of open standards?

**Standards in the Metaverse**

We’ve identified some places where it makes sense to share content, like scenes and (to a degree) avatars. Standardizing file formats can work well for helping with some types of content portability - gLTF for 3D models, and BASIS for texture compression both are examples of open file formats. If you think about existing applications - for example, social media sites - while you might not have full interoperability between them, you can at least upload the same picture to each of them since they use the same file format.

For an emerging technology like the metaverse, a nice thing about glTF is that it’s extensible. The core can be standard and work across platforms, while still allowing platforms to add their own capabilities. As platforms work on their own extensions, it becomes clearer over time which features are core capabilities, and that becomes the standard.
![Dom says: Hardware platforms can also benefit from standards. Back when GPUs first hit the scene, game authors would have to target specific GPUs when creating their games, and end users would often have to configure the game for their specific graphics card. OpenGL, DirectX, and more recently Vulkan, made it so that things could largely be written in a GPU-agnostic way. OpenXR does this for XR hardware. Application developers can build for different headsets without having to rewrite the core application for each device.](./content/images/2022/12/image.png)
Standards can also be used to define how applications can be interoperable across different types of hardware. Mobile phones and desktop computers have different capabilities and interfaces, which impact the design of interfaces. Browsers are platforms that allow creators and developers to write applications in a standard way. The W3C governs the development of standards that allows a site to respond to different devices.

**Data Ownership & Interoperability**

Data ownership is an important component of system interoperability. For example, in “the metaverse”, I want to have an easy way to take my avatars and move them. In an ecosystem where you can export your avatar from one application, and import it into another application, for some use cases, that's enough. Ownership of content is one part of an application that can be a factor in considering switching costs. It’s harder to build a system where users have ownership over their social graph. This is what makes it hard to move off of a particular social network - we might have years of content that’s tricky to export, and when you do export it, then what?

What do you do with that data? What about the people I’m following, or connected to? This problem isn’t unique to the metaverse and immersive web applications. We need to be considering how we can take ownership of the systems we create with our data.

That level of ownership and interoperability is hard. It’s counter to the business models that we currently have, where data is a currency for the companies that are collecting it. Moving to a model that puts people ahead of profit requires a deep shift in the assumptions we make about business models today. Finding ways to incentivize user and community-driven frameworks in the metaverse can help this idea develop. Developers can build on top of open protocols and differentiate on the value added - how features are built - and build their platforms and spaces as a place of deep user agency.

Users benefit from interoperable systems. But because companies in recent years have tended to focus on growth at all costs, there aren’t great incentives for companies profiting off of data to give up lock-in in favor of interoperability, either.

**How to get involved**

Interoperability is a big effort. It requires a lot of people trying different things, and identifying where it makes sense to draw abstraction lines. Interested in learning more about interoperability? Take a look at the different organizations below as a jumping-off point:

- [W3C](https://www.w3.org/)
- [Khronos Group](https://www.khronos.org/) (OpenXR)
- [Metaverse Standards Forum](https://metaverse-standards.org/)
- [World Economic Forum Metaverse Initiative](https://www.weforum.org/press/2022/05/new-initiative-to-build-an-equitable-interoperable-and-safe-metaverse/)
- [Open Metaverse Initiative](https://omigroup.org/)

If you want to stay up to date with what we’re doing to keep Hubs open, make sure that you join our [Discord](https://discord.gg/hubs-498741086295031808) server or mailing list! In Part 2, we'll explore additional frameworks for evaluating interoperability, and various ways that we can categorize different types of interoperability across applications.

_Ready to get started with your own hub? Visit _[https://hubs.mozilla.com/#subscribe](https://hubs.mozilla.com/#subscribe)_today_!
