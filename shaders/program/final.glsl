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
        vec3 color = pow(texture2D(colortex0, texCoord).rgb, vec3(1.0 / 2.2));
        gl_FragColor = vec4(color, 1.0);
    }

#endif