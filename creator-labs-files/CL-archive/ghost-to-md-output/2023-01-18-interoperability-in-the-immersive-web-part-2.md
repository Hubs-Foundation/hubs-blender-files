---
title: Interoperability in the Immersive Web - Part 2
slug: interoperability-in-the-immersive-web-part-2
date_published: 2023-01-18T13:02:29.000Z
date_updated: 2023-01-19T20:11:39.000Z
---

*In our first installment of *[*Interoperability in the Immersive Web*](__GHOST_URL__/interoperability-in-the-immersive-web/)*, we talked about the definition of interoperability, how various components of interoperability are being applied to the metaverse, some of the challenges of interoperability, and key characteristics of an open metaverse. In today’s post, we will explore additional frameworks for evaluating interoperability, and various ways that we can categorize different types of interoperability across applications.*

Defining abstraction layers is a key component of building interoperable systems. These boundaries help us understand and share a context for the discussions we have about sharing technologies and concepts between different groups. Abstraction allows us to determine which pieces of a technology should be shared across systems, while also providing a clear framework for which parts of a feature a platform can implement its own behaviors. 

![An image showing 16 power outlets and plug shapes, only a few of which can work in multiple configurations](https://lh4.googleusercontent.com/NpInPu19CTVY4hSr6JunMeZ-Coyn5vCMUixNkyI5r_AkPxuEoBwIpfJubjSu-tJraWBHX9Lq4NQa0swJocqz17J-RdHBQ3fyh4HV2_7xq2yUBfzagLi28iSjPqzc7N9aRt0MXWW4l705CDU0p4rk_gk_BwEAHwcsz2DjRhd9SvwErEpAkhPe9lPD2ScmhA)
*Without standardization, technologies are limited in how different systems work together *

**Interoperable File Formats in 3D Applications**

A file format is one layer of abstraction that enables portability between applications. For immersive applications, the two primary file formats that are often discussed in the context of interoperability are the ‘glTF’ format, and the ‘USD’ format. 

The glTF (‘GL Transmission Format’) is an open format that is governed within the Khronos Group. This format was created to make transmitting 3D models and their associated content (such as textures) easier and less intensive than previous formats. gltF models can be packaged in a human-readable JSON format, or as a binary .glb file. USD (‘Universal Scene Descriptor’) is an open format that was developed at Pixar. This format was created to define the way that a scene is composed, and introduces a sub-layering concept where multiple artists can work on the same scene and iterate quickly. Both of these file formats are ways of representing spatial data. They are each open source, and define a set of rules that applications can implement.
![A screenshot from Pirates of the Caribbean that states &quot;The code is more what you'd call guidelines, than actual rules.&quot;](https://lh4.googleusercontent.com/_ko2U-ZR7Ma-FAxHhE7EL4xq2h0jr3L_x1yUudZmziNWvW9FPxkHAggHKvdGj15GRp-GKSKkA0ulRl38oDVnGAhzwYHwhgwnHeUQiOCwu9-wHiLR29zLgDujd05dLGx1TjNDV7wb_BKNyj-nJU3WsBGilh0EA_BFNyGEz8-wXWChPZkayccbjwd-I5CPCQ)
File formats are often an area where conversations of interoperability occur because they allow for greater portability of information across applications and use cases. A 3D model is transferring data related to a mesh - the physical shape of a digital object - as well as often including data about textures, materials, annotations and author information, usage rights, and more. By standardizing a format for data, applications can build on top of these files to present and modify information in different contexts. In the context of immersive web applications, applications increasingly also provide ways of modifying information within these files. 

**Exploring Interoperability in the Immersive Web with Avatars and Identity**

Let’s consider the abstraction layers that can be drawn around the concept of an “avatar”. Avatars are commonly used as a point of discussion in conversations of interoperability in the metaverse for many reasons: 

- They’re a way of representing and identifying one’s self in a given environment
- They are a feature of almost every major platform
- They encode a significant amount of information that is shared with a platform and the others in it

An avatar can be defined in different ways. Data that avatars may include contains information about how to render a digital body that one can control in a virtual space. It usually references a 3D model, which may include the mesh of an avatar, textures and material information. It might include user information - such as who is allowed to use the avatar. The line between avatar and identity is still being drawn within the context of the immersive web.

The way that a platform chooses to define a user’s identity and avatar involves making decisions about the extent to which their application will be interoperable with other forms of content. A platform that wants a high degree of control over how users look and act in their application, or wants to innovate quickly on new features related to one’s digital bodies and forms of expression, may choose to implement a less-interoperable avatar system than a platform that wants to open up for creators to use their work in multiple places. Trade-offs related to interoperability have real usability and business impact, where tensions can exist between platform holders and content creators. 

When it comes to interoperability, there is no one “clear” solution that works best, but it’s important to be aware of these trade-offs so that those building experiences have visibility into what they can and cannot control about their work. The graphic below shows examples of high and low interoperability systems that users may encounter in the emerging “metaverse” technology space.
![An image of an avatar in 3 different resolutions. Examples of high interoperability - such as the ability to move, edit, and freely access an avatar file - are on the right side, while examples of low interoperability - such as restrictions on use - are on the left.](https://lh6.googleusercontent.com/p0Tv8FWob44qotU1ZeCvtQbPVXF4HsCtUlJxfn39PsHA14oPQxnadRAjoenP0DapumXBa5l4EydQAiZ5AhhAoETUDLCGmw2_JIFz-MTHcFFr9ItBZX0nfEwublpBRVfX9EBrEg9ArzuK1AYQmtgDzrOF9xFJK8cxA7E5YSKxsDFRivmkkt6oEgF1kZlCDg)

Interoperability - like so many other components of metaverse technology - has a philosophical component to it. When we expand our thinking around interoperability from “avatars” to the more-encompassing “identity”, the conversation may move away from pure technical interoperability, and into territory around what makes us individuals and the rights that we have when we use products and services. This can be a compelling part of working in this space: it enables us to work at a level that fundamentally questions our assumptions about where we are as a global community, and where we can move in the future.   

**Levels of Interoperability (and what it means for Creators)**

For creators, understanding the level of interoperability of content can help with making decisions about the trade-offs between portability, performance, and capabilities. A platform with little to no interoperability may require a specific engine or creation tool for building content, and limit the extent to which externally-created content can be brought in and used. Low-interoperability platforms are often tied to a closed-source software stack, which enables them to keep information and data stored in a proprietary manner. Having a less-interoperable system often means that an application is able to make decisions more quickly than an open, higher-interoperability system, and build features that other platforms don’t yet support.

Considering our avatar example, one thing that we might see on a platform with low levels of interoperability is a feature that allows creators to add custom bones to an avatar skeleton. This gives creators much more flexibility in adding tails, hair, and extra appendages to their digital bodies, but this feature will only work with applications that are aware that additional bones may be added to the base avatar skeleton, and have implemented a way of handling the additional bones.

For a creator who cares deeply about having complex capabilities to extend their avatar, choosing a platform that has the features that they want may take priority over the ability to take that avatar directly to multiple platforms. They may choose to build multiple versions of their avatar, in a way that adapts to different platforms depending on the level of capabilities that are available to them. For a creator who wants to represent themselves the same way on many platforms, finding an interoperable solution for avatars can enable that portability.

In building Hubs, one of the considerations that we have top of mind is how to build a platform that can be both extensible and support interoperability between instances (and other applications). In the coming months, we’ll be continuing work on our migration to Bit-ECS, to create a more easily extendable client architecture, and exploring new avatar formats and capabilities to align more closely with VRM. As we shift to a model where there are more individual hubs out on the web, porting data across different instances will be a key component of growing the ecosystem.   

**Advocating for Interoperability**

Throughout our history, Mozilla has been a key advocate of open web standards and interoperability within the browser. Our past in the 2D web guides our vision of the future, where new devices offer a more immersive experience for connecting and collaborating with others. This work shapes what we’re doing on the Hubs project, and how we think about what the internet looks like in an increasingly interactive and augmented digital world. It’s a highly collaborative effort, and one that we’re proud to be part of. One such artifact of this work can be found in the contributions we’ve made to the World Economic Forum’s [Metaverse Interoperability white paper](https://www3.weforum.org/docs/WEF_Interoperability_in_the_Metaverse.pdf) (PDF), which introduces a wide range of technical and interpersonal considerations for building interoperable immersive applications.

As always, we encourage anyone who is interested in participating in conversations around standards and interoperability to get involved, either through Hubs discussions or participating in groups like:

- [**W3C**](https://www.w3.org/)
- [**Khronos Group**](https://www.khronos.org/)** (OpenXR)**
- [**Metaverse Standards Forum**](https://metaverse-standards.org/)
- [**World Economic Forum Metaverse Initiative**](https://www.weforum.org/press/2022/05/new-initiative-to-build-an-equitable-interoperable-and-safe-metaverse/)
- [**Open Metaverse Initiative**](https://omigroup.org/)
