// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "5"
{
	Properties
	{
		_Tiling("Tiling", Int) = 0
		_SpeedX("Speed X", Float) = 0
		_SpeedY("Speed Y", Float) = 0
		_FlowmapIntensity("Flowmap Intensity", Float) = 0
		_DepthDistance("Depth Distance", Float) = 0
		_FoamFallOff("Foam FallOff", Float) = 0
		_Color1("Color 1", Color) = (0,1,0.03440881,0)
		_Color0("Color 0", Color) = (1,0,0.009047508,0)
		_Float0("Float 0", Float) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0.4333996
		_Float1("Float 1", Float) = 0
		_Color2("Color 2", Color) = (0,0,0,0)
		_Float2("Float 2", Float) = 0
		_Flowmap("Flowmap", 2D) = "white" {}
		_Int0("Int 0", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Flowmap;
		uniform float _Float2;
		uniform float _SpeedX;
		uniform float _SpeedY;
		uniform int _Tiling;
		uniform int _Int0;
		uniform float _FlowmapIntensity;
		uniform float4 _Color1;
		uniform float4 _Color0;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthDistance;
		uniform float _FoamFallOff;
		uniform float4 _Color2;
		uniform float _Float0;
		uniform float _Float1;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime131 = _Time.y * 0.1;
			float2 appendResult8 = (float2(_SpeedX , _SpeedY));
			float2 PannerSpeed13 = appendResult8;
			float2 temp_cast_0 = _Tiling;
			float2 uv_TexCoord12 = i.uv_texcoord * temp_cast_0;
			float2 temp_cast_2 = _Int0;
			float2 uv_TexCoord161 = i.uv_texcoord * temp_cast_2;
			float4 lerpResult23 = lerp( float4( uv_TexCoord12, 0.0 , 0.0 ) , tex2D( _Flowmap, uv_TexCoord161 ) , _FlowmapIntensity);
			float2 panner24 = ( mulTime131 * PannerSpeed13 + lerpResult23.rg);
			o.Normal = saturate( UnpackScaleNormal( tex2D( _Flowmap, panner24 ), _Float2 ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth17 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth17 = abs( ( screenDepth17 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthDistance ) );
			float4 lerpResult55 = lerp( _Color1 , _Color0 , saturate( pow( distanceDepth17 , _FoamFallOff ) ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV75 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode75 = ( 0.0 + _Float0 * pow( 1.0 - fresnelNdotV75, _Float1 ) );
			float4 lerpResult80 = lerp( lerpResult55 , _Color2 , saturate( fresnelNode75 ));
			o.Albedo = lerpResult80.rgb;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
645;99;1206;975;4474.104;-529.4921;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-4543.105,784.0006;Inherit;False;602.5322;233.9999;Panner Speed;4;13;8;5;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-4490.105,903.0005;Float;False;Property;_SpeedY;Speed Y;2;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;-3880.037,772.2853;Inherit;False;823.8157;206.0263;Coordinates del panner;3;12;10;23;;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;164;-4059.104,1094.492;Inherit;False;Property;_Int0;Int 0;14;0;Create;True;0;0;False;0;False;0;10;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-4493.105,834.0005;Float;False;Property;_SpeedX;Speed X;1;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;6;-2316.405,1022.821;Inherit;False;882.8231;242.9031;Depth Fade;5;29;26;17;20;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;10;-3833.452,856.9122;Float;False;Property;_Tiling;Tiling;0;0;Create;True;0;0;False;0;False;0;6;0;1;INT;0
Node;AmplifyShaderEditor.TexturePropertyNode;134;-3910.663,559.7738;Inherit;True;Property;_Flowmap;Flowmap;13;0;Create;True;0;0;False;0;False;None;8cbc53266523cfc4bad03c33395b305b;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2289.405,1089.217;Float;False;Property;_DepthDistance;Depth Distance;4;0;Create;True;0;0;False;0;False;0;1.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-4322.105,855.0006;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;161;-3896.165,1051.753;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;91;-3025.313,777.5447;Inherit;False;518.1626;206;Panner en si;2;19;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-3595.452,826.9122;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;17;-2056.214,1070.82;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-3615.463,981.9588;Inherit;True;Property;_owo;owo;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-4183.574,849.8946;Float;False;PannerSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-3553.815,1190.685;Float;False;Property;_FlowmapIntensity;Flowmap Intensity;3;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1984.849,1180.724;Float;False;Property;_FoamFallOff;Foam FallOff;5;0;Create;True;0;0;False;0;False;0;1.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;26;-1722.583,1079.796;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1749.173,1462.094;Inherit;False;Property;_Float1;Float 1;10;0;Create;True;0;0;False;0;False;0;1.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;131;-2942.584,998.1397;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;23;-3221.014,821.8513;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-2973.405,905.9412;Inherit;False;13;PannerSpeed;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1751.011,1389.055;Inherit;False;Property;_Float0;Float 0;8;0;Create;True;0;0;False;0;False;0;1.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;44;-1628.781,805.6161;Inherit;False;Property;_Color0;Color 0;7;0;Create;True;0;0;False;0;False;1,0,0.009047508,0;0,0.7547917,0.902,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;75;-1568.297,1325.193;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;24;-2714.15,827.5447;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;45;-1635.635,626.5788;Inherit;False;Property;_Color1;Color 1;6;0;Create;True;0;0;False;0;False;0,1,0.03440881,0;0,0.5624856,0.6784314,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;29;-1571.277,1080.385;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-2719.857,616.1061;Inherit;False;Property;_Float2;Float 2;12;0;Create;True;0;0;False;0;False;0;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;156;-2349.344,562.9872;Inherit;True;Property;_TextureSample4;Texture Sample 4;15;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;78;-1326.914,1059.964;Inherit;False;Property;_Color2;Color 2;11;0;Create;True;0;0;False;0;False;0,0,0,0;0.02802799,0.2139935,0.308,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;81;-1267.736,1324.904;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;-1324.338,926.9989;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;80;-1055.724,965.2293;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-303.3971,212.3733;Inherit;False;Property;_Opacity;Opacity;9;0;Create;True;0;0;False;0;False;0.4333996;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;138;-1991.347,577.9172;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;5;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;4;0
WireConnection;8;1;5;0
WireConnection;161;0;164;0
WireConnection;12;0;10;0
WireConnection;17;0;11;0
WireConnection;14;0;134;0
WireConnection;14;1;161;0
WireConnection;13;0;8;0
WireConnection;26;0;17;0
WireConnection;26;1;20;0
WireConnection;23;0;12;0
WireConnection;23;1;14;0
WireConnection;23;2;16;0
WireConnection;75;2;76;0
WireConnection;75;3;77;0
WireConnection;24;0;23;0
WireConnection;24;2;19;0
WireConnection;24;1;131;0
WireConnection;29;0;26;0
WireConnection;156;0;134;0
WireConnection;156;1;24;0
WireConnection;156;5;135;0
WireConnection;81;0;75;0
WireConnection;55;0;45;0
WireConnection;55;1;44;0
WireConnection;55;2;29;0
WireConnection;80;0;55;0
WireConnection;80;1;78;0
WireConnection;80;2;81;0
WireConnection;138;0;156;0
WireConnection;0;0;80;0
WireConnection;0;1;138;0
WireConnection;0;9;56;0
ASEEND*/
//CHKSM=DCA270E31342B8F0893C24E80DD5F377848AA9B5