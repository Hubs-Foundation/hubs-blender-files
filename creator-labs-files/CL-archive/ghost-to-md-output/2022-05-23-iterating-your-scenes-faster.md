---
title: Iterating On Your Scenes Faster
slug: iterating-your-scenes-faster
date_published: 2022-05-23T17:34:16.000Z
date_updated: 2022-05-23T17:34:16.000Z
tags: Tutorials, Intermediate
---

When making a virtual environment, it's those last 10% of changes that can take the most time to get right. Fortunately there's a little-known trick to iterate much faster.

In the past, it was tedious to check the results on Mozilla Hubs. Typically, the pipeline for updating a scene looks something like this.

### The old way:

In Blender

1. Make a change
2. Export .glb file

Then (if you're bypassing Spoke):
In Project manager 3. Import from Blender 4. Upload .glb file 5. Wait 6. Once finished, click on the project again 7. Open in Hubs 8. Create a new room 9. Join Room 10. Set Audio 11. Check the change you made.

Or if you're using Spoke:

3. Upload the asset
4. Change the URL on the asset you updated to the new upload
5. Publish scene
6. Confirm publish
7. Create a new room
8. Join room
9. Set audio
10. Check the change you made.

Both pathways can take a long time, especially for changes that can take many iterations to get just right.

### The New way:

If you're not familiar with them, 'Query String Parameters' are words you can add to the end of the URL with a '?' to get some extra development and debugging options [https://hubs.mozilla.com/docs/hubs-query-string-parameters.html](https://hubs.mozilla.com/docs/hubs-query-string-parameters.html).

The **debugLocalScene **Query String Parameter helps expedite the iterative process tremendously.

Simply add _`?debugLocalScene`_ (case-sensitive) to the end of the URL here:
![](./content/images/2022/05/image.png)?debugLocalScene Query String Parameter
and reload the room.

Here is a video demonstration:
video demonstration for ?debugLocalScene from my Materials in Hubs playlist on youtube (timestamped at 10:35 )
Once reloaded with this parameter, dropping a .glb file into the scene loads them as the scene. So all you have to do is:

1. Make change
2. Export from Blender
3. Drag and drop .glb file into the hubs scene
4. Voila! Check the change you made

💡

Note: This scene change only happens locally, so the scene will not change for anyone else in your room. You'll have to use the regular upload process and have your visitors refresh their page for them to see those changes.

You can see how this new way can greatly reduce the time it takes to try different looks or make rapid adjustments to your scenes. If you have more time-saving techniques, please share them on our [Hubs Discord](https://discord.gg/dFJncWwHun). Our community would love to see what you've been making.
