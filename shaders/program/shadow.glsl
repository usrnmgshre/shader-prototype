// VERTEX SHADER

#ifdef VERTEX

    #include "distort.glsl"

    varying vec2 texCoord;
    varying vec4 color;



    void main() {
        texCoord = gl_MultiTexCoord0.xy;
        color = gl_Color;
        gl_Position = ftransform();
        gl_Position.xy = distortPosition(gl_Position.xy);
    }

#endif



// FRAGMENT SHADER

#ifdef FRAGMENT

    varying vec2 texCoord;
    varying vec4 color;

    uniform sampler2D texture;



    void main() {
	    gl_FragData[0] = texture2D(texture, texCoord) * color;
    }

#endif