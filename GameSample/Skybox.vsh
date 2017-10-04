#version 150

#define NUM_LIGHTS 3

in vec3 position;
in vec3 textures;

out vec3 varTexCoords;

uniform mat4 modelViewProjectionMatrix;


void main()
{
	gl_Position = modelViewProjectionMatrix * vec4(position, 1);
	
	//varTexCoords = textures;

}