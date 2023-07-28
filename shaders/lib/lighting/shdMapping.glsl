const bool shadowHardwareFiltering = true;
const int shadowMapResolution = 1024;
const float shadowDistance = 128;

// Shadow opaque
uniform sampler2DShadow shadowtex0;

#ifdef SHADOW_COL
    // Shadow w/o translucents
    uniform sampler2DShadow shadowtex1;

    // Shadow color
    uniform sampler2D shadowtex0;
#endif

vec3 getShdCol(in vec3 shdPos) {
    #ifdef SHADOW_COL
        // Sample shadows
        float shd0 = textureLod(shadowtex0, shdPos, 0);
        // If not in shadow, return "white"
        if(shd0 == 1) return vec3(1);

        // Sample opaque only shadows
        float shd1 = textureLod(shadowtex1, shdPos, 0);
        // If not in shadow, return full shadow color
        if(shd1 != 0) return texelFetch(shadowcolor0, ivec2(shdPos.xy * shadowMapResolution), 0).rgb * shd1 * (1.0 - shd0) + shd0;
        // Otherwise, return "black"
        return vec3(0);
    #else
        // Sample shadows and return directly
        return vec3(textureLod(shadowtex0, shdPos, 0));
    #endif
}

vec3 getShdCol(in vec3 shdPos, in float dither) {
    vec2 randVec = vec2(cos(dither), sin(dither)) / shadowMapResolution;
    return (getShdCol(vec3(shdPos.xy + randVec, shdPos.z)) + getShdCol(vec3(shdPos.xy - randVec, shdPos.z))) * 0.5;
}