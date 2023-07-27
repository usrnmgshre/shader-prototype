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

	#include "distort.glsl"

    varying vec2 texCoord;

    uniform vec3 sunPosition;

    uniform sampler2D colortex0;
    uniform sampler2D colortex1;
    uniform sampler2D colortex2;
    uniform sampler2D depthtex0;
    uniform sampler2D shadowtex0;
    uniform sampler2D shadowtex1;
    uniform sampler2D shadowcolor0;
    uniform sampler2D noisetex;

    uniform mat4 gbufferProjectionInverse;
    uniform mat4 gbufferModelViewInverse;
    uniform mat4 shadowModelView;
    uniform mat4 shadowProjection;

    /*
    const int colortex0Format = RGBA16F;
    const int colortex1Format = RGB16;
    const int colortex2Format = RGB16;
    */

    const float sunPathRotation = -40.0;
    const int shadowMapResolution = 1024;
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



    float visibility(in sampler2D shadowMap, in vec3 sampleCoords) {
	    return step(sampleCoords.z - 0.001, texture2D(shadowMap, sampleCoords.xy).r);
    }

    vec3 transparentShadow(in vec3 sampleCoords) {
		float shadowVisibility0 = visibility(shadowtex0, sampleCoords);
		float shadowVisibility1 = visibility(shadowtex1, sampleCoords);
		vec4 shadowColor0 = texture2D(shadowcolor0, sampleCoords.xy);
		vec3 transmittedColor = shadowColor0.rgb * (1.0 - shadowColor0.a);
		return mix(transmittedColor * shadowVisibility1, vec3(1.0), shadowVisibility0);
	}

    #define SHADOW_SAMPLES 2
	const int shadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
	const int totalSamples = shadowSamplesPerSize * shadowSamplesPerSize;

    vec3 getShadow(float depth) {
		vec3 clipSpace = vec3(texCoord, depth) * 2.0 - 1.0;
		vec4 viewW = gbufferProjectionInverse * vec4(clipSpace, 1.0);
		vec3 view = viewW.xyz / viewW.w;
		vec4 world = gbufferModelViewInverse * vec4(view, 1.0);
		vec4 shadowSpace = shadowProjection * shadowModelView * world;
		shadowSpace.xyz = distort(shadowSpace.xyz);
		vec3 sampleCoords = shadowSpace.xyz * 0.5 + 0.5;
		vec3 shadowAccum = vec3(0.0);
		float randomAngle = texture2D(noisetex, texCoord * 20.0).r * 100.0;
		float cosTheta = cos(randomAngle);
		float sinTheta = sin(randomAngle);
		mat2 rotation = mat2(cosTheta, -sinTheta, sinTheta, cosTheta) / shadowMapResolution;
		for(int x = -SHADOW_SAMPLES; x <= SHADOW_SAMPLES; x++) {
			for(int y = -SHADOW_SAMPLES; y <= SHADOW_SAMPLES; y++) {
				vec2 offset = rotation * vec2(x, y);
				vec3 currentSampleCoordinate = vec3(sampleCoords.xy + offset, sampleCoords.z);
				shadowAccum += transparentShadow(currentSampleCoordinate);
			}
		}
		shadowAccum /= totalSamples;
		return shadowAccum;
	}



    void main() {
	    vec3 albedo = pow(texture2D(colortex0, texCoord).rgb, vec3(2.2));
		float depth = texture2D(depthtex0, texCoord).r;
		if(depth == 1.0) {
			gl_FragData[0] = vec4(albedo, 1.0);
			return;
		}
		vec3 normal = normalize(texture2D(colortex1, texCoord).rgb * 2.0 - 1.0);
		vec2 lightmap = texture2D(colortex2, texCoord).rg;
		vec3 lightmapColor = getLightmapColor(lightmap);
		float ndotL = max(dot(normal, normalize(sunPosition)), 0.0);
		vec3 diffuse = albedo * (lightmapColor + ndotL * getShadow(depth) + ambient);
	
		/* DRAWBUFFERS:0 */
		gl_FragData[0] = vec4(diffuse, 1.0);
    }

#endif