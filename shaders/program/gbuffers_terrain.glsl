// VERTEX SHADER

#ifdef VERTEX

    varying vec2 texCoord;
    varying vec2 lmCoord; //lightmap coordinates
    varying vec3 normal;
    varying vec4 color;



    void main() {
        texCoord = gl_MultiTexCoord0.xy;
        lmCoord = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.xy;
        lmCoord = (lmCoord * 33.05 / 32.0) - (1.05 / 32.0);
        normal = gl_NormalMatrix * gl_Normal;
	    color = gl_Color;
	    gl_Position = ftransform();
    }

#endif



// FRAGMENT SHADER

#ifdef FRAGMENT

    varying vec2 texCoord;
    varying vec2 lmCoord; //lightmap coordinates
    varying vec3 normal;
    varying vec4 color;

    uniform sampler2D texture;



    void main() {
        vec4 albedo = texture2D(texture, texCoord) * color;

        /* DRAWBUFFERS:012 */
        gl_FragData[0] = albedo;
        gl_FragData[1] = vec4(normal * 0.5 + 0.5, 1.0);
	    gl_FragData[2] = vec4(lmCoord, 0.0, 1.0);
    }

#endif