// VERTEX SHADER

#ifdef VERTEX

    #include "/lib/lighting/shdDistort.glsl"

    varying vec2 texCoord;
    varying vec4 color;



    void main() {
        texCoord = gl_MultiTexCoord0.xy;
        color = gl_Color;
        gl_Position = ftransform();
        gl_Position.xyz = distort(gl_Position.xyz);
    }

#endif



// FRAGMENT SHADER

#ifdef FRAGMENT

    varying vec2 texCoord;
    varying vec4 color;

    uniform sampler2D colortex0;



    void main() {
	    gl_FragData[0] = texture2D(colortex0, texCoord) * color;
    }

#endif