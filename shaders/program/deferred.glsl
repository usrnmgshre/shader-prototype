// VERTEX SHADER

#ifdef VERTEX
    
    varying vec2 texCoord;



    void main() {
        texCoord = gl_MultiTexCoord0.xy;
        gl_Position = ftransform();
    }

#endif



// FRAGMENT SHADER

#ifdef FRAGMENT

    varying vec2 texCoord;

    uniform vec3 sunPosition;

	uniform mat4 gbufferModelViewInverse;

    uniform sampler2D colortex0;
    uniform sampler2D colortex1;
    uniform sampler2D colortex2;
    uniform sampler2D depthtex0;

    /*
    const int colortex0Format = RGBA16F;
    const int colortex1Format = RGB16;
    const int colortex2Format = RGB16;
    */

    const float sunPathRotation = -40.0;
    const int noiseTextureResolution = 64;

    const float ambient = 0.1;



    float adjustLightmapTorch(in float torch) {
	    const float k = 3.5;
	    const float p = 5.0;
	    return k * pow(torch, p);
    }

    float adjustLightmapSky(in float sky) {
	    float sky_2 = sky * sky;
	    return sky_2 * sky_2;
    }

    vec2 adjustLightmap(in vec2 lightmap) {
	    vec2 newLightmap;
	    newLightmap.x = adjustLightmapTorch(lightmap.x);
	    newLightmap.y = adjustLightmapSky(lightmap.y);
	    return newLightmap;
    }

    vec3 getLightmapColor(in vec2 lightmap) {
	    lightmap = adjustLightmap(lightmap);
	    const vec3 torchColor = vec3(1.0, 0.5, 0.25);
	    const vec3 skyColor = vec3(0.3, 0.45, 0.5);
	    vec3 torchLighting = lightmap.x * torchColor;
	    vec3 skyLighting = lightmap.y * skyColor;
	    vec3 lightmapLighting = torchLighting + skyLighting;
	    return lightmapLighting;
    }



    void main() {
	    vec3 albedo = pow(texture2D(colortex0, texCoord).rgb, vec3(2.2));
		vec3 normal = normalize(texture2D(colortex1, texCoord).rgb * 2.0 - 1.0);
		vec2 lightmap = texture2D(colortex2, texCoord).rg;
		vec3 lightmapColor = getLightmapColor(lightmap);
		vec3 lightPos = mat3(gbufferModelViewInverse) * sunPosition;
		float ndotL = max(dot(normal, lightPos * 0.01), 0.0);
		vec3 diffuse = albedo * (lightmapColor + ndotL + ambient);

		/* DRAWBUFFERS:0 */
		gl_FragData[0] = vec4(diffuse, 1.0);
    }

#endif