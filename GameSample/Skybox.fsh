#version 150

#define NUM_LIGHTS 3

in vec3 varTexCoords;

out vec3 fragColor;

uniform sampler2D skyboxTexture;

void main()
{
    //vec3 diffColor = texture(skyboxTexture, varTexCoords.st, 0).rgb;
	//fragColor = diffColor;
    fragColor = vec3(1, 1, 1);
}
