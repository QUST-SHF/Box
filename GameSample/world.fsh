#version 150

#define NUM_LIGHTS 3

in vec3 varNormals;
in vec3 varVertex;
in vec3 varTexCoords;
in vec3 eyeDirection;
in vec3 lightDirection[NUM_LIGHTS];

out vec3 fragColor;

uniform sampler2D floorTex;
uniform sampler2D brickTex;
uniform sampler2DArray textures;
//uniform sampler2D textures;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform vec3 ambLight[NUM_LIGHTS];
uniform vec3 specLight[NUM_LIGHTS];
uniform vec3 lightColor[NUM_LIGHTS];
uniform float lightPower[NUM_LIGHTS];


void main()
{
    
	vec3 finalColor = vec3(0, 0, 0);
    
    
    //vec3 theDiffColor = texture(brickTex, varTexCoords.st, 0).rgb;
	//vec3 anotherDiffColor = texture(floorTex, varTexCoords.st, 0).rgb;
    //vec3 diffColor = mix(theDiffColor, anotherDiffColor, 0.5);
    
    
    vec3 diffColor = texture(textures, varTexCoords.stp, 0).rgb;
    //vec3 diffColor = texture(brickTex, varTexCoords.st, 0).rgb;
    
    //vec3 diffColor = vec3(1, 1, 1);
    
	for (int i=0;i<NUM_LIGHTS;i++)
	{
		vec3 ambColor = ambLight[i] * diffColor;
		float distance = length(lightDirection[i] - varVertex);
		
		vec3 n = normalize(varNormals);
		vec3 l = normalize(lightDirection[i]);
		
		float cosTheta = clamp(dot(n, l), 0, 1);
		
		vec3 e = normalize(eyeDirection);
		vec3 r = reflect(-l, n);
		
		float cosAlpha = clamp(dot(e, r), 0, 1);
		
		finalColor += ambColor + diffColor*lightColor[i]*lightPower[i]*cosTheta / (distance*distance)
         +	specLight[i] * lightColor[i] * lightPower[i] * pow(cosAlpha, 5) / (distance * distance);
        //finalColor += ambColor + diffColor*lightColor[i]*lightPower[i]*cosTheta / (distance*distance)
        // +	specLight[i] * lightColor[i] * lightPower[i] * pow(cosAlpha, 5) / (distance * distance);
	}
	fragColor = finalColor+vec3(0, 0, 0);//The vec3(0) will be replaced by surface materials later on
	//fragColor = diffColor;
    //fragColor = vec3(1, 1, 1);
}
