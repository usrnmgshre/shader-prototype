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

    uniform sampler2D colortex0;



    void main() {
        vec3 color = texture2D(colortex0, texCoord).rgb;
        
        /* DRAWBUFFERS:0 */
        gl_FragData[0] = vec4(color, 1.0);
    }

#endif