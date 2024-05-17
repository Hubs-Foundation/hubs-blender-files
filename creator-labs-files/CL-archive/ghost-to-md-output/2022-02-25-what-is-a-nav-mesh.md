---
title: What is a Nav Mesh?
slug: what-is-a-nav-mesh
date_published: 2022-02-25T18:30:27.000Z
date_updated: 2022-05-04T17:26:11.000Z
tags: Tutorials, Beginner
---

Why do my avatars fly around my scene ignoring walls? Why is this spiral staircase or narrow pathway broken? The answer to these exciting mysteries may lie in your nav-mesh.

What's a nav-mesh? Nav is short for navigation and a [mesh](https://en.wikibooks.org/wiki/Blender_3D:_Noob_to_Pro/What_is_a_Mesh%3F#:~:text=A%20mesh%20is%20a%20collection,shape%20of%20a%203D%20object%3A&amp;text=(The%20plural%20of%20vertex%20is,flat%20surface%20enclosed%20by%20edges.) is another name for a 3D object. Mozilla Hubs uses nav-mesh to dictate where an avatar can go.  Hubs doesn’t recognize anything else in the scene for avatar movement, so understanding nav-mesh is crucial for controlling movement in your space.

![](./content/images/2022/03/Screen-Shot-2022-02-23-at-9.11.44-AM-1.png)

![](./content/images/2022/03/artgallery-nav-mesh-1.png)

Art Gallery nav mesh on the right highlighted in blue. Notice how the edges stop short of the walls so the avatar won’t clip through.
Check out this brief demonstration video below. See the differences between the two grey planes representing the nav-mesh? Notice how one nav mesh has a hole that prevents the avatar from clipping into the green object.

0:00
/
1&#215;

Two different nav-mesh seen in grey
In [Spoke](https://hubs.mozilla.com/spoke), the nav-mesh is automatically generated.  Scenes have a floor plan you can find in the scene hierarchy. The floor plan has many properties you can use to make adjustments to the way the nav-mesh is generated.
![image of Spoke with floor plan](./content/images/2022/03/spoke-floor-plan.png)Nav Mesh highlighted in blue. Floor Plan element and properties.
We won’t go into detail what every one of these properties do here. You can try playing with these properties yourself by remixing the [Hubs Modular Art Gallery](https://hubs.mozilla.com/scenes/jOIjUE0/hubs-modular-art-gallery)

With the [Hubs Modular Art Gallery open in spoke](https://hubs.mozilla.com/spoke/projects/new?sceneId=jOIjUE0), let’s try to add a new wing for our participants to explore.  Enable the west hall, delete the walls and add to our nav-mesh to make sure people can explore the new wing of our gallery.

0:00
/
1&#215;

Enabling the west hall and updating the nav-mesh

💡

You can try adding _?debugNavmesh_ to the end of any room URL to see a wireframe version of the nav-mesh in that space.

0:00
/
1&#215;

Visualization of a nav mesh wireframe created by appending ?debugNavmesh to the room URL.
The nav-mesh is a critical part of the experience for many spaces in Mozilla Hubs. To learn more about advanced nav-mesh techniques check out this creator labs post: [Creating a Custom Nav Mesh](__GHOST_URL__/creating-a-custom-nav-mesh-for-your-hubs-scene/) to meet your needs.

Any questions? Ask in the [Mozilla Hubs Discord](https://discord.gg/sBMqSjCndj).
