#ifndef DISTORT_GLSL

	vec2 distortPosition(in vec2 position) {
		float centerDistance = length(position);
		float distortionFactor = mix(1.0, centerDistance, 0.9);
		return position / distortionFactor;
	}

#endif