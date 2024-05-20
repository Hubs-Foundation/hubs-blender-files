---
title: Optimizing a Sketchfab model for Hubs
slug: optimizing-models-from-sketchfab
date_published: 2022-05-06T19:52:48.000Z
date_updated: 2022-05-13T01:07:27.000Z
tags: Tutorials, Advanced, Tools
excerpt: 3d models from the web are amazing. But they sometimes require a little intervention to make them work better. This tutorial will help you make the most out of models grabbed from the web so your Hubs scenes can run their very best.
---

There has never been a better time to find great 3d models on the web. Sites like [Sketchfab](https://www.sketchfab.com) offer thousands of models, both paid and free, all easily downloadable and ready to use in your proj–**_wait just a second. _**Just because a model is available to download does not necessarily mean it’s ready for use in a realtime application like Hubs. Sure, most models will eventually load up just fine, but that doesn’t mean they perform well. In fact, most of the questions we get from new users (aside from ‘_How do I jump?_’) are related to some asset that they can’t get to work the way they wished. In this article, we’ll take a look at a few of the most common problems people run into when using models obtained from the web.

### It all starts with picking a good model

I would argue that most of the problems people encounter with models from the web can be avoided simply by not picking problematic models in the first place. Fortunately, sites like Sketchfab provide some nice ways of understanding a model before you even choose to download it. For example, in the embedded Sketchfab viewer below, you can use the ‘Model Inspector’ button to open up a side panel with all kinds of helpful information.

💡

You may have to click within the window first, but you’ll see an icon that looks like a stack of paper.

![A group of icons on Sketchfab's viewer window. The Model Inspector button is highlighted.](./content/images/2022/04/SketchfabLayerButton.png)Bottom right corner of the Sketchfab viewer.

[ Basic Barrel ](https://sketchfab.com/3d-models/basic-barrel-f2256509d4c14688849907217394e811?utm_medium=embed&utm_campaign=share-popup&utm_content=f2256509d4c14688849907217394e811) by [ Blender3D ](https://sketchfab.com/Blender3D?utm_medium=embed&utm_campaign=share-popup&utm_content=f2256509d4c14688849907217394e811) on [Sketchfab](https://sketchfab.com?utm_medium=embed&utm_campaign=share-popup&utm_content=f2256509d4c14688849907217394e811)

At the top of the panel that appears, you can click on the various color swatches to view the wireframe overlay on the model. This is usually the first thing to check to see how well the model is made. What you’re looking for is relatively clean lines and not too many extraneous faces or triangles that don’t contribute to the overall silhouette of the model.

Within the inspector panel, you can also isolate individual texture channels that the model has. For example, you can see _just_ the Metallic texture or the Normal (bump) texture by clicking the corresponding label. Toggling these channels is a fantastic way to help you understand how the various textures work to produce the final result.

0:00
/
1&#215;

Sketchfab’s 3d viewer lets you inspect models in many useful ways.
If you use the various ‘Viewport’ modes, you can see the textures in their 2-dimensional format. Running your mouse over the model will show a corresponding cursor on the texture to help you better understand the relationship between the 2d texture and the 3d model.

💡

For more information about how they relate, check out [this tutorial on UV Scrolling](__GHOST_URL__/animating-textures-with-the-uv-scroll-component-pt1/) that explains the 2d/3d relationship.

0:00
/
1&#215;

Sketchfab’s Viewport modes help you visualize the textures in 2d
If you require even more information about the model, such as the exact triangle count, download size of the textures, or format information, you can see these by visiting the model on the main Sketchfab website. From there, all models have a ‘More Model Information’ link below them.
Clicking that link will open up a helpful panel like this example:
![Sketchfab's Model Information panel for the barrel model discussed in the article.](./content/images/2022/04/SketchfabModelInfo.png)Sketchfab’s ‘More Model Information’ pop-up window. This is a great place to find potential problems, particularly with texture counts and texture file sizes. (Image cut in half to save you some scrolling.)
But wait! We can go even deeper by clicking the ‘See all files’ link. From there, we get yet another useful pop-up:
![Sketchfab's All Files window showing a list of models and all the included textures, many as large as 4k.](./content/images/2022/04/Sketchfab_FileInfo-2.png)Sketchfab's All Files window. Look at all those huge 4k textures!
Right away, I can see that I’m definitely going to want to reduce those 4k textures down to something more reasonable, especially for just a simple prop. I usually accomplish this with Photoshop or some other image editing software. Doing so will greatly reduce the overall download size for Hubs visitors so that’s worth doing for sure.

Beyond that, I’d say this model is fairly efficient. Sure, we could reduce the triangle count by selectively deleting edges and vertices, but we’d lose the smoothness of the round barrel a bit and the savings wouldn’t greatly affect performance unless, of course, I'm planning to add dozens or hundreds of them in one scene.

### “But my model is a _complete mess_!”

Okay, okay, so I chose a pretty efficient model as an example. Meanwhile, you just spent a while finding (or paying for) a model only to realize it looks like a complete mess of triangles–sometimes referred to as ‘polygon soup’.

Meshes often end up like this if they were captured using [photogrammetry](https://en.wikipedia.org/wiki/Photogrammetry) or some similar technique. Let’s take a look at one such model:

[ Club chair ](https://sketchfab.com/3d-models/club-chair-0edad579dcd9431e9b91c1fff4b84700?utm_medium=embed&utm_campaign=share-popup&utm_content=0edad579dcd9431e9b91c1fff4b84700) by [ alban ](https://sketchfab.com/alban?utm_medium=embed&utm_campaign=share-popup&utm_content=0edad579dcd9431e9b91c1fff4b84700) on [Sketchfab](https://sketchfab.com?utm_medium=embed&utm_campaign=share-popup&utm_content=0edad579dcd9431e9b91c1fff4b84700)

Doesn’t seem too bad, right? Well, try looking at the wireframe like we did before…

0:00
/
1&#215;

Even a seemingly simple model can hide its true construction, in this case, a giant mess of triangles.
It turns out that this chair model consists of around 36,000 triangles! That may not seem like a big deal, but it sure does when you remember the typical budget for a _whole Hubs scene_ is around 100,000 to run comfortably on most devices. Maybe if your whole scene will only consist of a couple chairs and a tv like the [Construct from The Matrix](https://genius.com/2643391?), that could be acceptable. But when you consider loading up other background elements and multiple avatars, that budget may get blown out quickly with assets like this one.

### (not)Too late topologize...

We’re going to want to eliminate this sort of ‘polygon soup’ whenever we can. The good news is that there are many tools out there that are catered to just this sort of challenge. In fact, I bet by the time I’m done writing this, there will be several new ones that work even better. It’s a great time to be a 3d content creator for the sheer reason that lots of people are actively trying to solve problems like this one. This is a sort of shortcut method that uses a specific piece of software to figure it out for you, as opposed to [‘retopologizing’ manually](https://www.youtube.com/watch?v=S4YNiImIgPs). So in the interest of time, I’ll limit this tutorial to one such solution.

For this club chair model, I’m going to use a free solution called ‘[Instant Meshes](https://github.com/wjakob/instant-meshes)’.

The concept is pretty straightforward: import your high-resolution model, choose a target triangle count, make a few guidelines, then let Instant Meshes recalculate a simpler, more streamlined model for export.

The only drawback is being limited to using either .OBJ or .PLY files to do so. Fortunately, you may have noticed that Sketchfab often provides several different file types when downloading, including .OBJ so we’re all set to go.

💡

If you are using Blender, you'll find that it has support for all kinds of model formats, including .OBJ and .PLY. When in doubt, you can use it to convert from one format to another.

Instant Meshes is pretty intuitive. When you launch it, you must first open your mesh. There’s a nice big ‘Open Mesh’ button at the top; you can’t miss it.

0:00
/
1&#215;

Opening a mesh in Instant Meshes couldn’t be simpler. You just need a .OBJ or .PLY model
Next, you will specify a Target Vertex Count. Instant Meshes attempts to choose a size for you, which is usually good. But you may have different requirements you’re trying to achieve, so try out some different settings if you want. In this example, around 1.5k triangles seems to be a good number. Then, under ‘Orientation Field’, click the big ‘Solve’ button and you’ll see some colorful lines appear on the model.

0:00
/
1&#215;

The colorful lines represent the flow of the geometric topology that Instant Meshes will attempt to follow.
This is the fun not-so-terrible part. If you use the little button that looks like a comb, you enter a mode that lets you draw your own strokes on the model to help guide the topology how you want it to flow. Why is this important? Well, the straighter and cleaner the topology is, the easier it will be to work with if you’re making your own textures or otherwise editing the model in another software package. Plus, if you decide you want to tweak the geometry of the model a bit, like removing the arms of the chair, it will be much easier to work with if you only have to move a handful of straight vertices instead of hundreds of scattered ones.

0:00
/
1&#215;

The 'comb' tool in Instant Meshes lets you guide the topology so the geometry flows across the model better.
Next, you’ll click the bottom-most ‘Solve’ button and the view will change to show a grid-like texture over the model. The grid is a rough representation of what the ‘new’ geometry will look like. So if you see lots of crooked or broken lines within the grid, you may want to go back and comb the model differently.

0:00
/
1&#215;

Testing out the new topology. You can always make changes before exporting, so experiment as much as you want.
Don’t be surprised if it takes a few tries to comb your topology into something that looks the way you want. Fortunately, you can simply click the circular ‘X’ button(s) to remove any unwanted strokes and try again.

💡

I found it a little confusing that I couldn’t rotate the view of the model while using tools like the comb, but I just get the view lined up first and remember to disable the comb tool when I'm done.

Another handy feature is the two ‘Singularity Attractor’ tools. They each look like a magnet.
When toggled, they show spots on the model where a ‘singularity’ has occurred in the mesh.

A singularity is a spot where the original mesh has a whole bunch of triangles in one dense area. These spots can cause problems if you really need the geometry to flow in a particular direction. But unless you have dozens and dozens of them, they won’t likely cause you too much trouble.
I didn’t have much luck getting the ‘Orientation’ attractor to work, but the ‘Position’ one makes what can only be described as little Pac Man spots that can be clicked and dragged and they’ll ‘gobble up’ the bad geometry as they travel. It’s not important that you remove every single singularity, but the fewer you have, the better your model will look.

0:00
/
1&#215;

If only Pac Man would chomp away all the bad geometry I've ever made...

💡

You can toggle and adjust most of the items on the model by opening up the ‘Advanced’ menu and trying the different ‘Render Layers’. Some of them have sliders for size too.

When you’re finished (or at least ready to say ‘good enough’), you can export the model by using the ‘Export Mesh’ button. Inside the menu, you must first click ‘Extract Mesh’, then ‘Save’. I recommend saving the mesh in the same folder as the original, high poly mesh.

Once again, you can choose between .OBJ or .PLY. I’m choosing .OBJ.

0:00
/
1&#215;

Exporting in Instant Meshes is pretty straightforward. You might want to try out that ‘Smoothing Iterations’ slider for different results.

### Back to Blender

This next set of steps can be done in lots of different software applications, but I’m using Blender for this part. The high-level explanation for what we’re doing next is that we need to bring in both versions of the model–the ugly high-poly and the more efficient low-poly one, transfer the texture information from the high to the low, then finally re-export the finished low version.

💡

If you don’t see the option to import/export .OBJ or .PLY within Blender, you can enable those in Blender’s Preferences menu since they ship with Blender but may be disabled by default.

![Blender's Preferences for Add-ons. Stanford PLY and Wavefront OBJ are highlighted.](./content/images/2022/04/BlenderAddOnsFormats.png)Blender’s Preferences→ Add-ons: Both the .OBJ and .PLY formats can be enabled.
So the first step is to import just the original high-poly version of the chair. It’s as simple as going to File→Import .OBJ and selecting the file you want.

Let’s go ahead and import the low-poly chair too so we can see them overlapping each other.

0:00
/
1&#215;

Both .OBJ models imported to Blender with less-than-ideal orientation and scale.
Whoa! Wait just a second. I didn’t notice before when I was using Instant Meshes, but now that the model is in Blender, I can see that it’s rotated strangely. But I know not to panic–that means my low-poly chair is rotated exactly the same way. This is good because it means I can correct them by moving them together.

It’s important that we make any changes to the position/rotation/scale of the chairs exactly the same. So we’ll make sure we select BOTH models and then use Blender’s various move, rotate, scale tools to make them look more reasonable. Don’t forget–the scale is also very important since we’ll be using these in Hubs and probably want them to be sized for a human.

Note that Blender’s default grid shows 1-meter squares so this chair is actually supersized by default.

0:00
/
1&#215;

Selecting both chairs– rotating and scaling them to match the world, then Applying their transforms to reset them.

💥

The last step of that clip above is extremely important: You must Apply the Transforms (CTRL+a) so that the Position and Rotation values all read 0,0,0; and all the Scale values read 1, 1, 1.

### "_Can I borrow that texture?_"

When the high-poly chair is imported, there’s a chance that its material and/or textures are missing. The Sketchfab model contains everything you need, so it’s likely that the textures are available alongside the model file or perhaps in another nearby folder. If it _did_ show up with its material intact, we’re probably going to need to adjust it anyway. Regardless of how the model came in, we’re going to set up its material ourselves in Blender’s Shader Editor window.

Select the **high-poly chair** mesh and then use the Shader Editor window to set up your material graph to look like this. You’re safe to delete any extra nodes that may have come along during the import process.
![Three nodes that represent the high-poly chair's material.](./content/images/2022/04/HighPoly_MaterialSetup.png)The high-poly chair’s material graph. Just an image texture piped into a Diffuse BSDF node, then to the Material Output.
The low-poly chair also needs a material setup, but it will look different since we need to capture or ‘bake’ the textures from the high-poly version into it.

Select the **low-poly chair** and set up its material like this:
![Three nodes that represent the high-poly chair's material. The Image Texture node remains unattached to the rest.](./content/images/2022/04/LowPoly_MaterialSetup-1.png)The low-poly chair’s material graph. This time, we’re using an Image Texture node that remains disconnected from the rest of the graph.
In the Image Texture node, click ‘+New’ and make a new texture with the following setup:

- Name: Chair_BaseColor
- Size: 1024x1024
- No Alpha
- Blank

Here’s what that dialog looks like:
![New Image dialog from Blender. Fields are: Name, Width, Height, Color, Alpha, Generated Type](./content/images/2022/04/ImageTextureTarget.png)You can use a higher resolution if you wish, but be aware that the file size may increase dramatically. Make sure you keep that Image Texture node selected afterwards.
This texture, which starts out blank, will act as a target for the high-poly chair’s texture to bake into. Confused? Don’t worry. This will make sense in a moment…keep reading…

The important thing here, (and this is a bit of a Blender quirk), is that you **make sure that Image Texture node remains selected. **It will have a white outline to indicate it’s selected.

☠️

This is an egregious, redundant call-out here– but I can't emphasize enough how important it is to keep that Image Texture node selected when baking textures.

### We need UVs!

The low-poly chair has model data (faces, edges, vertices) but it lacks texture coordinates. We need to unwrap it so that Blender knows where to lay the new texture. Fortunately for us, we can do a somewhat sloppy job here. I’m using the 'Smart UV Project' operation and just making sure that none of the UV islands overlap with each other in the UV Editor window by using 'Pack UVs'.

0:00
/
1&#215;

A quick Smart unwrap and Pack UVs will ensure the low-poly chair can actually display a texture on it.

### Let's get baked\*

**\*texture** bake, that is. Mind-altering substances not recommended while reading complex tutorials

Now comes the cool part. We’re going to bake the texture from the high-poly chair onto the low-poly chair. The steps are as follows:

- Select the High-Poly chair first.
- Shift+select the Low-Poly chair.
- In the Shader Editor, make sure the Image Texture node is selected for the low-poly chair.
- Go to the Render Properties tab and switch the Renderer to ‘Cycles’.
- In the Render Properties panel, expand the ‘Bake’ section.

We need to set up a proper texture bake by doing the following:

Set the Bake Type to Diffuse, then **uncheck** both Direct and Indirect Lighting contributions.

0:00
/
1&#215;

There are many texture channels you can bake, but we're just transferring a basic texture from one object to another.
Next, since we’re capturing the texture from the high-poly chair, we need to turn on ‘Selected to Active’.

💡

In Blender terminology, ‘Active’ means the object you selected LAST. This means we’re baking the texture FROM the high-poly (selected) TO the low-poly (active).

We also need to adjust the Extrusion and Ray Distance values so that Blender can accurately project the texture from one to the other. These numbers are highly subject to the real-world scale of your object(s), so you’ll likely need to experiment with different values until the baked texture comes out the way you expect.
Last, you’ll hit the big ‘Bake’ button and wait for the render to finish.

0:00
/
1&#215;

Baking Selectd to Active is how you transfer information from one object to another.
When it’s done, you can plug the Image Texture node back into the Base Color input of the BSDF node to see the result on your low-poly chair. You’ll definitely want to hide the high-poly chair so you can see what’s going on.

0:00
/
1&#215;

The (active) low-poly chair gets its new baked texture from the (selected) high-poly chair.

💡

You're likely going to need to adjust those Bake numbers until the texture looks right. If parts of the texture are missing on the model, you may have to increase the Extrusion value so that the whole model gets ‘captured’. Once again, the scale of the model can help you dial in the right values. You’re essentially trying to get the distance between the low and high surfaces without going too far.

From here, we can adjust the other parameters of the material like the Roughness until the model looks the way we want. Bear in mind that models captured from photographs often contain extra lighting and other things you don’t actually need in that base color texture. You can always try to remove highlights, shadows, reflections, or other artifacts in an image editor.

0:00
/
1&#215;

The textures have now been successfully transferred onto the low-poly chair! It’s almost like the high-poly chair went on a diet and lost around 35,000 triangles--yet its clothes still fit!

### Conclusion

Whew! We did it! If nothing else, going through this process will make you appreciate when someone either makes a nice, clean model to start with or when they do all this clean-up before you ever download it. But regardless, it's nice to know that you can roll up your sleeves and do it yourself when you have to.

Know of any other methods for optimizing models? Our community would love to hear how you can make their lives easier on our [Hubs Discord](https://discord.gg/dFJncWwHun). Feel free to show off your model optimizing results on our [#show-and-tell](https://discord.com/channels/498741086295031808/819202898247548948) channel.
