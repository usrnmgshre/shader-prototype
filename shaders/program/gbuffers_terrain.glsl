// VERTEX SHADER

#ifdef VERTEX

    varying vec2 texCoord;
    varying vec2 lmCoord; //lightmap coordinates
    varying vec3 normal;
    varying vec4 color;

    flat out vec3 vertexColor;   

    out vec4 vertexPos;

    uniform mat4 gbufferModelView;
	uniform mat4 gbufferModelViewInverse;

    void main() {
        texCoord = gl_MultiTexCoord0.xy;
        lmCoord = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.xy;
        lmCoord = (lmCoord * 33.05 / 32.0) - (1.05 / 32.0);
        normal = mat3(gbufferModelViewInverse) * gl_NormalMatrix * gl_Normal;
	    vertexColor = gl_Color.rgb;
        vertexPos = gbufferModelViewInverse * (gl_ModelViewMatrix * gl_Vertex);        
	    gl_Position = ftransform();
    }

#endif



// FRAGMENT SHADER

#ifdef FRAGMENT

    varying vec2 texCoord;
    varying vec2 lmCoord; //lightmap coordinates
    varying vec3 normal;
    varying vec4 color;

    flat in vec3 vertexColor;

    in vec4 vertexPos;

    uniform sampler2D colortex0;

    uniform float dayCycle;
	uniform float twilightPhase;

    #ifdef WORLD_LIGHT
        uniform mat4 shadowModelView;
		
		#define SHD_MAPPING
		
		uniform mat4 shadowProjection;

		#include "/lib/lighting/shdMapping.glsl"
		#include "/lib/lighting/shdDistort.glsl"
    #endif

    #include "/lib/lighting/simpleShading.glsl"

    void main() {
        vec4 albedo = vec4(vertexColor, 1);

        albedo.rgb = vec3(1);

		albedo.rgb = toLinear(albedo.rgb);

		vec4 sceneCol = simpleShading(albedo);

        /* DRAWBUFFERS:012 */
        gl_FragData[0] = sceneCol;
        gl_FragData[1] = vec4(normal * 0.5 + 0.5, 1.0);
	    gl_FragData[2] = vec4(lmCoord, 0.0, 1.0);
    }

#endif