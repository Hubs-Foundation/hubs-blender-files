---
title: Hubs LOD Support
slug: hubs-lod-support
date_published: 2022-11-04T03:22:24.000Z
date_updated: 2022-11-07T19:25:17.000Z
tags: Code, Tools
---

We are happy to announce that Hubs now supports LOD! This feature allows richer, more performant, and more efficient model rendering in [Hubs](https://hubs.mozilla.com/).

**What is LOD?**

> In computer graphics, level of detail (LOD) refers to the complexity of a 3D model representation. LOD can be decreased as the model moves away from the viewer or according to other metrics such as object importance, viewpoint-relative speed or position. LOD techniques increase the efficiency of rendering by decreasing the workload on graphics pipeline stages, usually vertex transformations. The reduced visual quality of the model is often unnoticed because of the small effect on object appearance when distant or moving fast.

[Wikipedia: Level Of Detail](https://en.wikipedia.org/wiki/Level_of_detail_(computer_graphics))

In short, the LOD technique is an efficient rendering technique by rendering simpler versions of models for distant objects.

![](https://lh6.googleusercontent.com/t6iC_DbCK1dq-24ImnbpIYtbB-h-Dnx4H7650S_tOkT9rxoAoJjPXaIClPm03yHhVQAY8lSIEe8pLmmY6vIsKHUajOkCeG3py2lueT9gJgcZH2ttQtCfyvGmNQisQXdqKOD9FIkjB813d05q5CSTnbPNpG1vg9xm73eSbfu_6nCD2UgpcDM5jKtR0Q)

![](https://lh5.googleusercontent.com/dCw1momsYGeBZZlAPo_gsBRKxW043nk8GESQOTEsEYEf5r1I2DzHiJ14ILlwGj89jcRAcupmDXGi72Lgh0IZTaRlIS3mbzinLbLbg0ZAULFF6JXWqtFiFiuzM6NuqQYYnBo7bLBhoPta83Nnr0tl5byO35KBWuUWu-r7S_rTjwaTeAdJ3mYa4ff2dQ)

Image Credit: David Luebke [Level of Detail: A Brief Overview](https://slideplayer.com/slide/13638512/)
Below is a LOD demo video recorded in Hubs. You will notice the model switches to simpler versions as the player moves further away from it.

![a level of detail demonstration of a black and grey music player](https://lh3.googleusercontent.com/Y1dl4YRWgTmS8fGDVYWuAsJ0V4TO9Ctufl_nFaE2Rw85ut2qYyfIkJcrlDPtIhBt2TcxHpZIBJvikYTgRJmHOo5XH5sgcArk_AJeHBUz999QpZLuc_axpuKUKrSVe_5v3EiLP7lGlvc7wvcXncnKpVrwCO8n4fxkSt3WL7hTWNR5pyjkXkcIgsBNzA)A simplified version of the stereo is exaggerated here for demonstration purposes. [Source](https://twitter.com/superhoge/status/1573434117282320389)
**Progressively loading LODs**

An asset supporting LOD includes several LOD levels of a model. Progressively loading LODs can save network usage. For example, we can start by loading the smallest version of the asset and then downloading the more demanding version of the model as the camera gets closer to the object. Progressive loading ensures that higher-cost versions of the asset are never downloaded unless the player gets close.

**Benefits from LOD**

You will get the following benefits from LOD + Progressive loading.

- Better runtime performance. Distant objects are simple to render.
- Shorter response time. Models become visible when the lowest LOD download is completed.
- Save network usage. Unused LODs are never downloaded.

A benefit derived from the above is that LOD allows richer content. Currently scene authors may be hesitant to put many high quality models in a scene because they can cause negative impact for runtime performance, response time, and network usage. The efficiency gained by using LOD techniques can mitigate this negative impact.

**glb + HTTP range requests**

Hubs supports [glTF](https://www.khronos.org/gltf/), which is a standard 3D file format. If you are familiar with the glTF format****,**** you may assume having a single bundled glb should be avoided to exploit the progressive loading. This is not the case. 
[Binary container format of glTF, called glb,](https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html#glb-file-format-specification) enables a glTF asset, including JSON, mesh data, and texture images to be stored in a single glb file. Bundled glb files are easy to import to applications because they don’t need to care about archive files.
![](https://lh6.googleusercontent.com/vBoH7ebdxMQBnf65i2xBDnLfVdzRYsN0zjtN79cd_GTCkJQ22-7UITk3N2bATL9OfG5h4cc718mwVNIFdF5NMq2lSrCO6_UOzyMeoDnm_xQFWeRRnZfc1L7Tn7BzNn_cNa3Byl2Myoi_s-95_x7J8m_kNlOSEfkzWk3dAOY-Yrsy4hd-r_17THhG-w)
[HTTP range requests](https://developer.mozilla.org/en-US/docs/Web/HTTP/Range_requests) enable partial downloading. An HTTP range request asks the server to send back partial data of a file. HTTP range requests enabledownloading a specific **level** of a bundled glb file.
![GLB LOD Range Requests and progressive loading overview. Shows high-level data loading progressively](https://lh4.googleusercontent.com/cEGznWrBahwpW9DYtaYLn8_zfVTe9E6xFk__end86x61Wrri17vzOI6rqcCv3zgcnUY_H7v5NU9JaS0HhKVUg-RoZGbY1NZwJN0eHpWM_KVIXx1qZaYiRGJ2f5S8iNAcm8Oe7Nw35Ptxb45Wzorf1dngF73GWKObybgWULAbLOQuagxsqGAlIPagZg)
**glTF MSFT_lod extension**

[The core glTF specification](https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html) doesn’t support LOD. How can LOD be represented in glTF?  glTF has an extensibility mechanism that extends the base glTF model format.

Microsoft proposed a LOD extension [MSFT_lod](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Vendor/MSFT_lod/README.md) as a vendor extension that allows LOD in glTF node or material. Hubs supports this extension because it provides better portability for assets than making Hubs****-****specific LOD components.

**Authoring tools**

So how can you create assets with LOD and export as glTF?
Unfortunately there are no major asset authoring tools that support the MSFT_lod extension, so I have made two tools for this purpose.

**glTF-transform script**
[glTF-transform](https://gltf-transform.donmccurdy.com/) is a useful glTF SDK created by [Don McCurdy](https://www.donmccurdy.com/) that provides fast, reproducible, and lossless control of the low-level details in a 3D model.
glTF-transform doesn’t natively support the MSFT_lod extension but provides [an extensibility mechanism that allows user custom extension handling](https://gltf-transform.donmccurdy.com/extensions.html).
I have written a glTF-transform script that uses the extensibility mechanism to handle the MSFT_lod extension. You can add LOD to a glTF asset in the command line. The original glTF asset is used as the highest LOD and lower levels are automatically generated from the glTF asset with glTF-transform and the dependency libraries. Please refer to the following link for the details:

🔧

[glTF-Transform-lod-script](https://github.com/takahirox/glTF-Transform-lod-script)

![](https://lh5.googleusercontent.com/_CyrWg_o2Lsha5hES1F016TbIKTG9giTfun2JTSykRHdVXujrgqO5qw1jlYbtXyMv1IlI9O6Lnh7hJgRLoZ6DnOxGYfrpJW8I7M3IYsa30g4vBF3e_QI-FBSnZYLMJXXoYrqLe1btOZxEcwZ48i3B5Tnb_fkRsdpBVN7B6s-5qbmxf2nif6YT-JijQ)

**Blender Add-On**
[Blender](https://www.blender.org/) is one of the most popular computer graphics software and you can create 3D assets with it. Blender doesn’t natively support glTF format but [it has an extensibility mechanism called addons](https://docs.blender.org/manual/en/latest/editors/preferences/addons.html) and [the glTF import/export addon](https://github.com/KhronosGroup/glTF-Blender-IO) is installed by default.

Unfortunately, the glTF add-on doesn’t support the MSFT_lod extension. So I have written a Blender MSFT_lod add-on. With this add-on, you can assign lower-level meshes to a mesh and export them as glTF with the MSFT_lod extension. Please refer to the following link for the details:

🔧

[glTF-Blender-IO-MSFT-lod](https://github.com/takahirox/glTF-Blender-IO-MSFT-lod).

![Blender UI with a yellow duck in the viewport. The level of details extension highlighted in a red box.](https://lh4.googleusercontent.com/5KJ-fZrPDB7htSBlLBEeLZUI0uYG5Syp0Rz7J2HH0_lDUYmBG8xzgG-jJrKdu5C0WqaHZH5dIjbasY7fVidSx73Cpc6jNyhiAyl0Op2M9MDsme2ikcr-giqJu2JhqxxQI4IUZAVjT3YGO8ep0kr0xWLXeX_0Yxb6nIsgfumSopAgfb3PGyuGla1TGw)
**Implementation for LOD in Hubs Client**

**LOD support**
Hubs Client (Hubs web application page) is built on the top of [Three.js](https://threejs.org/), which is one of the most popular JavaScript + [WebGL](https://www.khronos.org/webgl/) 3D graphics engines.  Three.js has a [THREE.LOD](https://threejs.org/docs/#api/en/objects/LOD) class that manages LOD.  glTF assets having the MSFT_lod extension need to be imported as THREE.LOD objects in Hubs Client.

Three.js [GLTFLoader](https://threejs.org/docs/#examples/en/loaders/GLTFLoader) supports some standard glTF extensions by default but doesn’t support the MSFT_lod extension. The GLTFLoader has an extensibility mechanism called Plugin system that allows custom glTF extensions handling. [I wrote a plugin that imports a glTF asset having the MSFT_lod extension as a THREE.LOD object.](https://github.com/takahirox/three-gltf-extensions/tree/main/loaders/MSFT_lod)

**HTTP range requests support**
Currently, Three.js doesn’t support HTTP range requests. [I have sent a pull request to Three.js for HTTP range requests support.](https://github.com/mrdoob/three.js/pull/24580) It hasn’t been merged yet at the time when I’m writing this article so we have cherry-picked this upcoming change to our Three.js fork.

Three.js GLTFLoader also needs some changes for HTTP range requests. Fortunately, I have found that HTTP range requests support is doable with the plugin system so I wrote a [Three.js GLTFLoader HTTP range requests plugin](https://github.com/takahirox/three-gltf-extensions/tree/main/loaders/GLB_range_requests) that allows progressive LODs loading with HTTP range requests.

**How to enable HTTP range requests feature**

Because of some reasons the HTTP range requests support in Hubs Client is still an experimental feature and it is hidden behind a flag right now.

It is disabled by default. To enable it you need to add “rangerequests” query string to the Hubs URL.

1. Go to [https://hubs.mozilla.com/](https://hubs.mozilla.com/) in your web browser
2. Create and enter a room
3. Add “rangerequests” to the URL bar, like https://hubs.mozilla.com/randomId/roomName?rangerequests, and load the page again

To ensure that the HTTP range requests feature is enabled, open your browser’s devtool network panel ([Chrome](https://developer.chrome.com/docs/devtools/network/)/[Firefox](https://firefox-source-docs.mozilla.org/devtools-user/network_monitor/)) and find [206 HTTP status response code](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/206).

![dev tools network tab with 206 status highlighted in a red box](https://lh4.googleusercontent.com/knz-GCiE5qXmamRVWE34YY1_r0KlUm5Tf12ZtZ7UQ2PqAaqvNs9DxLwB73RwOAvHZFQAnRoQp4idNthKpuNGUZlDNsXpQbjSUGVrZACk5XzOQJTNU9YTV2TGoLzqN2BqWkZLpYocn-NnL1CvOi8FN39n_CYSJ3KTkOpyQ5hOdhtqZnmaiJ3mRQjDUQ)
**Feedback is welcome**

Enjoy LOD in [Hubs](https://hubs.mozilla.com/). We are happy to hear your feedback on [Mozilla Hubs GitHub](https://github.com/mozilla/hubs) or [Mozilla Hubs Discord](https://hubs.mozilla.com/discord).
