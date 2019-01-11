#ifndef HBAO_DEFERRED_INCLUDED
#define HBAO_DEFERRED_INCLUDED

    struct CombinerOutput {
	    half4 gbuffer0 : COLOR0;	// albedo (RGB), occlusion (A)
	    half4 gbuffer3 : COLOR1;	// emission (RGB), unused(A)
    };

    CombinerOutput frag(v2f i) {
		half4 occ = FetchOcclusion(i.uv2);
		half3 ao = lerp(_BaseColor.rgb, half3(1.0, 1.0, 1.0), occ.a);

	    CombinerOutput o;
#if UNITY_SINGLE_PASS_STEREO
		float2 uv = UnityStereoTransformScreenSpaceTex(i.uv2);
	    o.gbuffer0 = tex2D(_rt0Tex, uv);
	    o.gbuffer3 = tex2D(_rt3Tex, uv);
#else
		o.gbuffer0 = tex2D(_rt0Tex, i.uv2);
		o.gbuffer3 = tex2D(_rt3Tex, i.uv2);
#endif
	    o.gbuffer0.a *= occ.a;
	    o.gbuffer3.rgb = -log2(o.gbuffer3.rgb);
	    o.gbuffer3.rgb *= ao;
#if COLOR_BLEEDING_ON
	    o.gbuffer3.rgb += occ.rgb;
#endif
	    o.gbuffer3.rgb = exp2(-o.gbuffer3.rgb);

	    return o;
    }

    CombinerOutput frag_blend(v2f i) {
		half4 occ = FetchOcclusion(i.uv2);
	    half3 ao = lerp(_BaseColor.rgb, half3(1.0, 1.0, 1.0), occ.a);

	    CombinerOutput o;
	    o.gbuffer0 = half4(1.0, 1.0, 1.0, occ.a);
	    o.gbuffer3 = half4(ao, 0);
	    return o;
    }

#endif // HBAO_DEFERRED_INCLUDED
