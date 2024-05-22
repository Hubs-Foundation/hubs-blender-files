# Demo-Server

This directory contains configuration settings for the Hubs demo server: hubs.mozilla.com

### Avatar and Scene .TXT files

These .txt files contain lists of scene and avatar urls set as 'approved' or 'featured' in Mozilla's demo hub. We have also included lists of scenes and avatars specifically contributed by the Hubs team (hubs_team_avatars.txt & hubs_team_scenes.txt)

### Hubs_Avatars_Export

These directories contain json data references and avatar assets for all _approved_ avatars on hubs.mozilla.com/admin whose creator attribution is either "Hubs Team" or "JCo". Avatar assets either include unified .glb files or .gltf base models with .png base maps. All assets follow the same naming convention: `{avatar name}_by_{creator attribution}_id_{avatar id}` This export was conducted on May 22, 2024.

### Hubs_Scenes_Export

These directories contain json data references and scene assets for all _approved_ scenes on hubs.mozilla.com/admin whose creator attribution is either "Hubs Team" or "JCo". All assets follow the same naming convention: `{scene name}_by_{creator attribution}_id_{scene id}` This export was conducted on May 22, 2024.

### Themes.json

This file is the theme-ing json for Mozilla's demo server.
