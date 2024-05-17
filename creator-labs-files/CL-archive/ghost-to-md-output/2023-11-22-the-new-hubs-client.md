---
title: The new Hubs client
slug: the-new-hubs-client
date_published: 2023-11-22T15:54:04.000Z
date_updated: 2023-11-22T16:00:43.000Z
---

The Mozilla Hubs team has developed a new Hubs client based on [bitECS](https://github.com/NateTheGreatt/bitECS) to improve flexibility, extensibility, and maintainability. We are very excited to announce this new client, which has been the subject of much discussion, design, and development within the Hubs team over a long period of time, since 2022. This article will explain the features and benefits of the new client.

## Background

Hubs adopted [A-Frame](https://aframe.io/) to develop the client in its early days. A-Frame is a library that makes it easy to create VR-enabled web applications. This was a good fit for the Hubs project's goal of quickly getting something working. The project was successful, and Hubs was able to get to market quickly.

However, as Hubs development continued to grow, we faced many problems with the client's internal design. For example, the overuse of async/await operations has made it difficult to ensure the order of processing, resulting in complex code. Async events are non-deterministic, so it is impossible to predict when they will occur. As a result, it is necessary to listen to them, which can make it difficult to write simple code that executes in order. This can lead to complex processing, which reduces maintainability and makes it more likely for bugs to occur. Additionally, the internal modules are not clearly decoupled from each other and they have become more complex and interdependent. This has made maintenance difficult and the process of adding new features unnecessarily time consuming.

What’s more, there have been many requests from users to be able to add their own features to the client more easily. The complex client made it difficult for users to add their own features.

Therefore, in order to improve flexibility, extensibility, and maintainability, and to make it easier to control the order of processing, we began to consider a client based on a more pure ECS architecture. We found [bitECS](https://github.com/NateTheGreatt/bitECS), a JavaScript ECS library, and decided to rewrite the client with it and migrate from the existing A-Frame based client to the new bitECS based client.

Please refer to this [page](https://github.com/mozilla/hubs/pull/5536 ) for additional information.

## ECS Architecture

[ECS (Entity Component System)](https://en.wikipedia.org/wiki/Entity_component_system) architecture is a type of architecture commonly used in game development. In ECS architecture, game objects are managed by entities and components.

An entity is a unit that represents a game object. Various components can be added to an entity. 

A component is a unit that represents a function or attribute that can be added to an entity. Components can be added independently to an entity. For example, even if you add a component to update the position of a character and add a component to change the color of a character, they will not affect each other. This achieves excellent flexibility, extensibility, and maintainability.

A system is a unit that implements the behavior of game objects. For example, there are systems that update the position of all characters and systems that detect collisions of all objects.

Although Hubs Client is not a game, it performs the same kind of processing, so ECS architecture is very well applicable.

## Flexibility, Extensibility, and Maintainability

The new Hubs client based on bitECS achieves excellent flexibility, extensibility, and maintainability by adopting ECS architecture. One of the notable improvements is that it is now easier to add new features without making too many changes to the core source code of the Hubs Client. 

To better understand the process of adding a new feature, let's consider the simple example of adding velocity to an object in order to move it linearly through a 3D scene.

First, we will define a new component. The `Velocity` component holds  vector information that indicates the direction and speed of movement.

    // src/components/velocity.ts
    import { defineComponent, Types } from "bitecs";
    
    export const Velocity = defineComponent({
      x: Types.f32,
      y: Types.f32,
      z: Types.f32
    });
    

Second, we will write a new system that moves Three.js objects. `velocitySystem` gets the ids of entities that have `Velocity` and `Object3DTag` components by using bitECS query, gets Three.js objects associated with entities, and updates the objects' position.

    // src/systems/velocity.ts
    import { defineQuery } from "bitecs";
    import { Object3DTag } from "../bit-components";
    import { Velocity } from "../components/velocity";
    import { HubsWorld } from "../app";
    
    const velocityQuery = defineQuery([Velocity, Object3DTag]);
    
    export function velocitySystem(world: HubsWorld) {
      velocityQuery(world).forEach(eid => {
    	const obj = world.eid2obj.get(eid)!;
    	obj.position.x += Velocity.x[eid];
    	obj.position.y += Velocity.y[eid];
    	obj.position.z += Velocity.z[eid];
      });
    }
    

We will need to edit a small bit of an existing Hubs core file `src/systems/hubs-systems.ts` to call `velocitySystem` from `mainTick` that is invoked every animation frame.

    // src/systems/hubs-systems.ts
    ...
    import { velocitySystem } from "../systems/velocity";
    ...
    export function mainTick(...) {
      ...
      velocitySystem(world);
      ...
    }
    ...
    

Next, we will write an inflator for the Velocity component. Inflator is unique to Hubs and adds component(s) to an entity and initializes component(s) data.

    // src/inflators/velocity.ts
    import { addComponent } from "bitecs";
    import { Velocity } from "../components/velocity";
    import { HubsWorld } from "../app";
    
    export type VelocityParams = {
      x?: number;
      y?: number;
      z?: number;
    };
    
    const DEFAULTS: Required<VelocityParams> = {
      x: 0.0,
      y: 0.0,
      z: 0.0
    };
    
    export function inflateVelocity(
      world: HubsWorld,
      eid: number,
      params: VelocityParams
    ) {
      params = Object.assign({}, params, DEFAULTS) as Required<VelocityParams>;
      addComponent(world, Velocity, eid);
      Velocity.x[eid] = params.x;
      Velocity.y[eid] = params.y;
      Velocity.z[eid] = params.z;
    }
    

The new feature is ready now. If you call the inflator from somewhere to add `Velocity` components and also add Three.js objects to entities, you will see the objects move in the 3D scene.

    // somewhere
    import { addEntity } from "bitecs";
    import { BoxGeometry, Mesh, MeshBasicMaterial } from "three";
    import { inflateVelocity } from "../inflators/velocity";
    import { addObject3DComponent } from "../utils/jsx-entity";
    import { HubsWorld } from "../app";
    
    function xxx(world: HubsWorld) {
      ...
      const eid = addEntity(world);
      inflateVelocity(world, eid, {
    	x: 1.0
      });
      addObject3DComponent(world, eid, new Mesh(
    	new BoxGeometry(1.0, 1.0),
    	new MeshBasicMaterial()
      ));
      ...
    }
    

As you saw, the implementation of the new feature is very simple and by moving async/await processing out of the animation loop, the order of processing is made predictable. We didn’t add many changes to the Hubs core code and the new feature is decoupled from other key features.

This simple paradigm means that the Hubs team can add features more quickly, and users can even add their own features, while keeping the code maintainable. 

For more details, please refer to the following documentation.

[https://hubs.mozilla.com/docs/dev-client-gameplay.html](https://hubs.mozilla.com/docs/dev-client-gameplay.html)

💡

Another significant change is the adoption of TypeScript for the new client, while the existing client is written in JavaScript. TypeScript facilitates faster development with the aid of types. Static type checking enables us to identify bugs early in the development phase.

## How to enable the new client

The new bitECS based Hubs client is disabled by default. You can switch to the new client on a per-room basis. To switch to the new client, the room owner must turn on the "Enable bitECS based client" toggle in “Room Info and Settings”.

0:00
/
1&#215;

To ensure that all clients in the room use the same client type, when the room owner switches the client type, all clients in the room automatically reload the web page. Dynamic client type switch and the mixed use of client types are not supported.

We attempt to keep the features that are supported in the existing A-Frame based client functionable in the new bitECS based client so (ideally) you will see no visual change after switching the client type.

## An Important Disclaimer

The bitECS-based Hubs client is still under development and stability is not fully guaranteed. In addition, some features are supported by the A-Frame based client, but are not supported by the new bitECS based client. Therefore, the bitECS based client is disabled by default. We plan to enable the bitECS based client by default after safety has been sufficiently confirmed.

For known issues with the new client, please refer to [https://github.com/mozilla/hubs/labels/new-loader](https://github.com/mozilla/hubs/labels/new-loader).

Also, as written above, the mixed use of new and old clients is not supported. For example, if you upload an object on the old client and change its state, the behavior of the object is not guaranteed if you enable the new client. If you use the new client, it is assumed that the room owner will enable the new client immediately after creating the room and then will not disable it.

## Support for the A-Frame-based client

We will not abandon the existing A-Frame based client immediately. Users who are creating custom clients based on the existing A-Frame-based client need not worry, but should start to learn the new client for future migration.

It is possible that new features will only be added to the new client in the future. We may also lower the priority of resolving problems that only occur in the old client. When we feel that the new client is mature enough, we plan to remove the old client.

Therefore, we strongly recommend that users who are creating new custom clients create them on the top of the new client.

## Conclusion

Our next goal is to improve the stability of the new client and enable it by default. We would like users to try the new client and give us feedback.

We would also like to thank the Hubs community for their help in testing the new client over a long period of time. We could not have made it to this point without your help.

We will continue to commit to building a vibrant and innovative community based on the bitECS based Hubs client. We hope that developers and users will explore the possibilities of this new platform, [provide feedback, and contribute to its continued development](https://github.com/mozilla/hubs).
