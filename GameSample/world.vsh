#version 150

#define NUM_LIGHTS 3

in vec3 position;
in vec3 textures;
in vec3 normals;


out vec3 varVertex;
out vec3 varNormals;
out vec3 varTexCoords;
out vec3 eyeDirection;
out vec3 lightDirection[NUM_LIGHTS];

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform vec3 lightPos[NUM_LIGHTS];
uniform float xLoc;
uniform float zLoc;


void main()
{
	gl_Position = modelViewProjectionMatrix * vec4(position, 1);
	
	varVertex = (modelMatrix * vec4(position, 1)).xyz;
	varTexCoords = textures;
	varNormals = normals;
	
	vec3 vertexPosCameraSpace = (vec4(position, 1)).xyz;
	eyeDirection = vec3(0, 0, 0) - vertexPosCameraSpace;
	
	for (int i=0;i<NUM_LIGHTS;i++)
	{
		vec3 lightPosCameraSpace = (vec4(lightPos[i], 1)).xyz;
		lightDirection[i] = lightPosCameraSpace + eyeDirection;
	}
	varNormals = (viewMatrix * modelMatrix * vec4(normals, 0)).xyz; //Use the inverse transpose if the model matrix does not scale the object 
	
}
