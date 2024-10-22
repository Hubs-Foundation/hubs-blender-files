---
title: Building the Metaverse with Open Source
slug: building-the-metaverse-with-open-source
date_published: 2022-06-27T15:31:39.000Z
date_updated: 2023-02-23T18:13:44.000Z
tags: Inspiration
---

### Ensuring that virtual worlds are open, accessible, and safe to all is paramount to a successful metaverse.

The word metaverse has been thrown around a lot these days. Whether you believe it's a reality or not, the adoption of the term has signaled a significant shift in the way people think about the future of online interactions. With today's technological advancements and an increase in geographically distributed social circles, the idea of seamlessly connected virtual worlds as part of a metaverse has never felt more appealing.

Virtual worlds enable a wide range of scenarios, and brings to life a rich and vibrant array of experiences. Students can explore the past by stepping inside a past time period, embodying historic figures, and interacting with buildings that were built centuries ago. Coworkers can gather for coffee chats, regardless of where in the world they're working. Musicians and artists can interact with fans from around the world in small or large digital venues. Conferences can reach new audiences, and friends can connect to explore interactive spaces.
![](./content/images/2022/06/jameswebbexpeirence.jpeg)_James Webb Telescope Experience: [MetaxuStudio](https://twitter.com/MetaxuStudio), [Ashley Zelinskie](https://twitter.com/azelinskie)_
When we built virtual world platforms (the predecessors to today's metaverse applications) in the past, there was only limited access to powerful graphics hardware, scalable servers, and high-bandwidth network infrastructure. However, recent advancements in cloud computing and hardware optimization have allowed virtual worlds to reach new audiences. The complexity of what we're able to simulate has increased significantly.

Today, there are several companies investing in new online virtual worlds and technologies. To me, this is indicative of a fundamental shift in the way people interact with one another, create, and consume content online.

Some tenets associated with the concept of the metaverse and virtual worlds are familiar through the traditional web, including identity systems, communication protocols, social networks, and online economies. Other elements, though, are newer. The metaverse is already starting to see a proliferation of 3D environments (often created and shared by users), the use of digital bodies, or "avatars", and the incorporation of virtual and augmented reality technology.
![](./content/images/2022/06/SAT-meetup-1.png)Credit: [SAT](__GHOST_URL__/society-for-arts-and-technology/)

### Building virtual worlds the open source way

With this shift in computing paradigms, there's an opportunity to drive forward open standards and projects encouraging the development of decentralized, distributed, and interoperable virtual worlds. This can begin at the hardware level with projects like Razer's [Open source virtual reality (OSVR)](https://www2.razer.com/osvr) schematics encouraging experimentation for headset development, and go all the way up the stack. At the device layer, the Khronos Group's [OpenXR](https://www.khronos.org/OpenXR/) standard has been widely adopted by headset manufacturers, which allows applications and engines to target a single API, with device-specific capabilities supported through extensions.

This allows creators and developers of virtual worlds to focus on mechanics and content. While the techniques used to build 3D experiences aren't new, the increased interest in metaverse applications has resulted in new tools and engines for creating immersive experiences. Although there are many libraries and engines that have differences in how they run their virtual worlds, most virtual worlds share the same underlying development concepts.
![Two avatars in a virtual space making emojis](./content/images/2022/06/hubs.jpeg)
At the core of a virtual world is the 3D graphics and simulation engine (such as [Babylon.js](https://www.babylonjs.com/community/) and the WebGL libraries it interacts with). This code is responsible for managing the game state of the world, so that interactions manipulating the state of the world are shared between the visitors of the space, and drawing updates to the environment on screen. Game simulation states can include objects in the world and avatar movement, so that when one user moves through a space, everyone else sees it happening in real time. The rendering engine uses the perspective of a virtual camera to draw a 2D image on the screen, mapped to what a user is looking at in digital space.

The video game world is made up of 2D and 3D objects that represent a virtual location. These experiences can vary, ranging from small rooms to entire planets, limited only by the creator's imagination. Inside of the virtual world, objects have _transforms_ that instantiate the object to a particular place in the world's 3D coordinate system. The transform represents the object's position, rotation, and scale within the digital environment. These objects, which can have mesh geometry created in a 3D modeling program, materials, and textures assigned to them, can trigger other events in the world, play sounds, or interact with the user.

Once a virtual world has been created, the application renders content to the screen using a virtual camera. Like a camera in the real world, a camera inside of a game engine has a viewport and settings that change the way a frame is captured. For immersive experiences, the camera draws many updates every second (up to 120 frames per second for some high-end virtual reality headsets) to reflect the way you're moving within the space. Virtual reality experiences specifically also require that the camera draws twice: once for each eye, slightly offset by your _interpupillary distance_ (the distance between the center of your pupils in each eye).

0:00
/
1&#215;

Metahood by [Conor Woodard](https://twitter.com/ConorWoodard)
Other key characteristics that make up the metaverse include users taking on digital bodies (often referred to as _avatars_), user-generated content that's created and shared by users of the platform, voice and text chat, and the ability to navigate between differently themed worlds and rooms.

## Approaches to building the metaverse

Before choosing a development environment for building the metaverse, you should consider what tenets are most critical for the types of experiences and worlds your users are going to experience. Most libraries and frameworks for authoring immersive content have a range of core graphics capabilities available so you can focus on the content and interactivity. The first choice you're faced with is whether to target a native experience or the browser. Both have different considerations for how a virtual world unfolds.

A proprietary metaverse necessarily offers limited connections to virtual worlds. Open source and browser-based platforms have emerged, building on top of web standards and operating through the [Khronos group and ](https://www.khronos.org)[W3C](http://www.w3c.org) to ensure interoperability and content portability.

Web applications such as [Mozilla Hubs](http://github.com/mozilla/hubs/) and Element's [Third Room](https://github.com/matrix-org/thirdroom) build on existing web protocols to create open source options for building browser-based virtual world applications. These experiences, linking together 3D spaces embedded into web pages, utilize open source technologies including [three.js](http://threejs.org), [Babylon.js](http://babylonjs.com), and [A-Frame](http://aframe.io) for content authoring. They also utilize open source real time communication protocols for voice and synchronized avatar movement.

Open source game engines, such as [Open 3D Engine (O3de)](https://www.o3de.org/) and [Godot Engine](https://godotengine.org/) offer native development capabilities and features. With open source engines, developers have the additional flexibility of extending or changing core systems, which allows for more control over the end experience.

## Open access

As with all emerging technologies, it's critical to consider the use case and impact to the humans who use it. Immersive virtual and augmented reality devices have unprecedented capabilities to capture, process, store, and utilize data about an individual, including their physical movement patterns, cognitive state, and attention. Additionally, virtual worlds themselves significantly amplify the benefits and problems of today's social media, and require careful implementation of trust and safety systems, moderation techniques, and appropriate access permissions to ensure that users have a positive experience when they venture into these spaces.
![](./content/images/2022/06/farvel.png)Virtual 3D Room of Remembrance in [Farvel](https://farvel.space/en/)
As the web evolves and encompasses immersive content and spatial computing devices, it's important to think critically and carefully about the experiences being created, and interoperability across different applications. Ensuring that these virtual worlds are open, accessible, and safe to all is paramount. The prospect of the metaverse is an exciting one, and one that can only be realized through collaborative open source software movements.

_This article originally was posted on [opensource.com](https://opensource.com/article/22/6/open-source-metaverse). It has been reproduced here with modifications with permission. Ready to get started with your own hub? Visit _[https://hubs.mozilla.com/#subscribe](https://hubs.mozilla.com/#subscribe)_today_!
