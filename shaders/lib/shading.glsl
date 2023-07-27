vec4 shading(in vec4 albedo) {

    vec3 totalDiffuse = toLinear(SKY_COL_DATA_BLOCK);

    #ifdef WORLD_LIGHT
        #ifdef SHD_MAPPING
            vec3 shdPos = vec3(shadowProjection[0].x, shadowProjection[1].y, shadowProjection[2].z) * (mat3(shadowModelView) * vertexPos.xyz + shadowModelView[3].xyz);
            shdPos.z += shadowProjection[3].z;

            shdPos = vec3(shdPos.xy / (length(shdPos.xy) * 2.0 + 0.2), shdPos.z * 0.1) + 0.5;

            vec3 shadowCol = getShdCol(shdPos);
        #endif

        totalDiffuse += shadowCol * toLinear(LIGHT_COL_DATA_BLOCK0);
    #endif

    return vec4(albedo.rgb * totalDiffuse, albedo.a);
}