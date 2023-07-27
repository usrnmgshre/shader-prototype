vec4 shading(in vec4 albedo) {

    #ifdef WORLD_LIGHT
        #ifdef SHADOW
            vec3 shdPos = vec3(shadowProjection[0])
}