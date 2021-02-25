Shader "AGame/PostProcessing/BltBlendLightShaft"
{

	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_DarkenStr("_DarkenStr", Range(0, 3)) = 1
	}


	SubShader
	{
		Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		LOD 100

		Pass
		{
			Name "BltBlendLightShaft"
			ZTest Always
			ZWrite Off
			Cull Off

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			
			struct Attributes
			{
				float4 positionOS   : POSITION;
				float2 uv           : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct Varyings
			{
				half4 positionCS    : SV_POSITION;
				float2 uv            : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);

			TEXTURE2D(_LightShaft);
			SAMPLER(sampler_LightShaft);

			float _DarkenStr;

			Varyings vert(Attributes input)
			{
				Varyings output = (Varyings)0;
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
				output.positionCS = vertexInput.positionCS;
				output.uv = input.uv;

				return output;
			}


			half4 frag(Varyings input) : SV_Target
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

				half4 colDisto = SAMPLE_TEXTURE2D(_LightShaft, sampler_LightShaft, input.uv);
				half4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);
				
				float darken = lerp(1,colDisto.r, _DarkenStr);

				return col * darken;
				//return col * colDisto.r;
			}
			ENDHLSL
		}
	}
}
