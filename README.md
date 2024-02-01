# Cloud-Shader

A simplified version of the cloud shader that I'm currently using for a game idea! [Here's the post!](https://www.reddit.com/r/godot/comments/1ag4x7k/spent_the_last_couple_days_playing_around_with/)
You can modify/study/use it however you want. If you do use it for your projects, I'd appreciate crediting me and maybe a [coffee!](https://ko-fi.com/ya834095)!

https://github.com/iammagical/Cloud-Shader/assets/66885721/ab2cf157-0048-4630-93f3-7c57560b598a

## How the Shader Works!
Basically, it's a billboarded quad mesh with vertex displacement to give it the appearance of a spherical volume, it's overall pretty simple! I chose this method because it doesn't seem graphically intensive (I haven't truly tested it though, so it might not be as efficient as I thought). Follow the basic setup and use it as particles to create pretty cool looking clouds! I recommend this video on how to setup the clouds using the GPUParticle3D [Tears of the Kingdom Style Clouds in Godot 4! - Tutorial](https://www.youtube.com/watch?v=sNXj0RN09ps)

## Basic Setup: 
![image](https://github.com/iammagical/Cloud-Shader/assets/66885721/11db7cec-1ba0-4416-aa30-5b71a8cca300)
![image](https://github.com/iammagical/Cloud-Shader/assets/66885721/ade5059c-584d-44ed-845d-7f26fda50ef5)

Apply the shader onto a QuadMesh, with a subdivided width/depth of 20 (could be higher or lower, depending on your preference for quality vs. performance).

### Parameters:
* Color - Overall color of the quad; the albedo color
* Time Scale - How fast you want the noise texture to shift
* Noise Texture - Create a noise texture, it's used for creating the fluffy, cloud-like feel, and is also used for height displacement
* Noise Normal Texture - Normalmap from a provided noise texture
* Cloud Texture - Your cloud shape mask; this is your overall cloud shape (Create a cloud shape image with alpha transparency)
* Noise Height - How high/wide you want the cloud vertex to be displaced by

The lighting code is a modified snippit of NekoArts' [Botw shader](https://godotshaders.com/shader/update-botw-toon-shader/)
!Warning! Because of how light and shadow is calculated, using an Omnilight, Spotlight3D, etc. with DirectionalLight3D will cause lighting artifacts, so make sure your mesh is on a different layer/cull mask then your non-directional lights.

* Normal Bias - How much the light is going to be affected by the mesh's normal
* Light Bias - Shifts how the light is going to affect the mesh
* Shadow Size - Changes shadow size
* Shadow Blend - Changes how much the shadow blends
* Shadow Extra Intensity - Darkens/increases contrast of the shadow
* Shadow Color - The shadow's color
* Light Tint - Tints the light

## If you like this shader consider buying me a [coffee!](https://ko-fi.com/ya834095)
