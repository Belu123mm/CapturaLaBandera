// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "5"
{
	Properties
	{
		_asdfasdf("asdfasdf", Int) = 0
		_Tiling("Tiling", Int) = 0
		_Float10("Float 10", Float) = 0
		_NormalspeedX("Normal speed X", Float) = 0
		_Float7("Float 7", Float) = 0
		_NormalspeedY("Normal speed Y", Float) = 0
		_FlowmapIntensity("Flowmap Intensity", Float) = 0
		_DepthDistance("Depth Distance", Float) = 0
		_FoamFallOff("Foam FallOff", Float) = 0
		_Color1("Color 1", Color) = (0,1,0.03440881,0)
		_Color0("Color 0", Color) = (1,0,0.009047508,0)
		_Float0("Float 0", Float) = 0
		_Float1("Float 1", Float) = 0
		_Color2("Color 2", Color) = (0,0,0,0)
		_NormalIntensity("Normal Intensity", Float) = 0
		_Flowmap("Flowmap", 2D) = "white" {}
		_FlowmapTiling("Flowmap Tiling", Int) = 0
		_Float4("Float 4", Range( 0 , 1)) = 0
		_RefraccionIndex("Refraccion Index", Range( 0 , 1)) = 0.1
		_Color3("Color 3", Color) = (1,1,1,0)
		_Float3("Float 3", Float) = 0
		_Float6("Float 6", Float) = 0
		_Float9("Float 9", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Float8("Float 8", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
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
		uniform float _NormalIntensity;
		uniform float _NormalspeedX;
		uniform float _NormalspeedY;
		uniform int _Tiling;
		uniform int _FlowmapTiling;
		uniform float _FlowmapIntensity;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _RefraccionIndex;
		uniform float4 _Color1;
		uniform float4 _Color0;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthDistance;
		uniform float _FoamFallOff;
		uniform float4 _Color2;
		uniform float _Float0;
		uniform float _Float1;
		uniform sampler2D _TextureSample1;
		uniform float _Float6;
		uniform float _Float3;
		uniform float _Float9;
		uniform float _Float10;
		uniform float _Float7;
		uniform int _asdfasdf;
		uniform float _Float4;
		uniform float4 _Color3;
		uniform float _Float8;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime131 = _Time.y * 0.1;
			float2 appendResult8 = (float2(_NormalspeedX , _NormalspeedY));
			float2 temp_cast_0 = _Tiling;
			float2 uv_TexCoord12 = i.uv_texcoord * temp_cast_0;
			float2 temp_cast_2 = _FlowmapTiling;
			float2 uv_TexCoord161 = i.uv_texcoord * temp_cast_2;
			float4 tex2DNode14 = tex2D( _Flowmap, uv_TexCoord161 );
			float4 lerpResult23 = lerp( float4( uv_TexCoord12, 0.0 , 0.0 ) , tex2DNode14 , _FlowmapIntensity);
			float2 panner24 = ( mulTime131 * appendResult8 + lerpResult23.rg);
			float3 tex2DNode156 = UnpackScaleNormal( tex2D( _Flowmap, panner24 ), _NormalIntensity );
			o.Normal = saturate( tex2DNode156 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult206 = (float2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float4 screenColor181 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( appendResult206 - ( (tex2DNode156).xy * _RefraccionIndex ) ));
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
			float screenDepth218 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth218 = abs( ( screenDepth218 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Float6 ) );
			float2 appendResult263 = (float2(_Float10 , _Float7));
			float2 temp_cast_4 = _asdfasdf;
			float2 uv_TexCoord256 = i.uv_texcoord * temp_cast_4;
			float4 lerpResult257 = lerp( float4( uv_TexCoord256, 0.0 , 0.0 ) , tex2DNode14 , _FlowmapIntensity);
			float2 panner260 = ( mulTime131 * appendResult263 + lerpResult257.rg);
			float simplePerlin2D238 = snoise( panner260 );
			simplePerlin2D238 = simplePerlin2D238*0.5 + 0.5;
			float2 temp_cast_7 = (saturate( ( ( 1.0 - pow( distanceDepth218 , _Float3 ) ) * ( _Float9 * simplePerlin2D238 ) ) )).xx;
			float4 tex2DNode240 = tex2D( _TextureSample1, temp_cast_7 );
			float4 lerpResult182 = lerp( screenColor181 , lerpResult80 , saturate( ( tex2DNode240 + ( distance( lerpResult80 , float4( 1,1,1,1 ) ) * _Float4 ) ) ));
			o.Albedo = lerpResult182.rgb;
			float4 color245 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 lerpResult214 = lerp( _Color3 , color245 , ( 1.0 - ( tex2DNode240 * _Float8 ) ));
			o.Emission = lerpResult214.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
937;42;932;987;1478.085;618.6884;1.3;False;False
Node;AmplifyShaderEditor.IntNode;164;-5219.706,-666.889;Inherit;False;Property;_FlowmapTiling;Flowmap Tiling;17;0;Create;True;0;0;False;0;False;0;5;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;252;-4781.443,811.3698;Float;False;Property;_asdfasdf;asdfasdf;1;0;Create;True;0;0;False;0;False;0;28;0;1;INT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;161;-5011.706,-682.889;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;134;-5347.706,-1194.889;Inherit;True;Property;_Flowmap;Flowmap;16;0;Create;True;0;0;False;0;False;None;be114cc752a6153449cf1b4b002b490d;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;6;-4579.344,1972.27;Inherit;False;882.8231;242.9031;Depth Fade;5;29;26;17;20;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;262;-3988.536,872.1986;Float;False;Property;_Float10;Float 10;3;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;261;-3985.536,941.1986;Float;False;Property;_Float7;Float 7;5;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;256;-4545.653,781.3698;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-4527.344,2023.666;Float;False;Property;_DepthDistance;Depth Distance;8;0;Create;True;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-4771.705,-746.889;Inherit;True;Property;_owo;owo;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-4211.705,-762.889;Float;False;Property;_FlowmapIntensity;Flowmap Intensity;7;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;17;-4319.153,2020.269;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;257;-4171.214,776.3089;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;263;-3817.536,893.1987;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-4000,384;Inherit;False;Property;_Float6;Float 6;22;0;Create;True;0;0;False;0;False;0;0.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-4247.788,2130.173;Float;False;Property;_FoamFallOff;Foam FallOff;9;0;Create;True;0;0;False;0;False;0;2.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;131;-4003.704,-58.88914;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;10;-4227.705,-1114.889;Float;False;Property;_Tiling;Tiling;2;0;Create;True;0;0;False;0;False;0;6;0;1;INT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-4067.704,-1114.889;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;221;-3744,528;Inherit;False;Property;_Float3;Float 3;21;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;218;-3824,368;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;26;-3985.522,2029.245;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-4003.704,-890.8889;Float;False;Property;_NormalspeedY;Normal speed Y;6;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-4013.95,2338.504;Inherit;False;Property;_Float0;Float 0;12;0;Create;True;0;0;False;0;False;0;1.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-4012.112,2411.543;Inherit;False;Property;_Float1;Float 1;13;0;Create;True;0;0;False;0;False;0;1.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-4003.704,-970.889;Float;False;Property;_NormalspeedX;Normal speed X;4;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;260;-3664.351,782.0023;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;23;-3795.704,-1114.889;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-3795.704,-938.8889;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;29;-3834.216,2029.834;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-3898.574,1576.028;Inherit;False;Property;_Color1;Color 1;10;0;Create;True;0;0;False;0;False;0,1,0.03440881,0;0,0.5624856,0.6784314,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;44;-3891.72,1755.065;Inherit;False;Property;_Color0;Color 0;11;0;Create;True;0;0;False;0;False;1,0,0.009047508,0;0,0.7547917,0.902,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;220;-3568,480;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;75;-3831.236,2274.642;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;238;-3223.188,970.0466;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;233;-3162.001,878.3675;Inherit;False;Property;_Float9;Float 9;23;0;Create;True;0;0;False;0;False;0;1.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;24;-3603.703,-1114.889;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;55;-3587.277,1876.448;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-3619.703,-986.889;Inherit;False;Property;_NormalIntensity;Normal Intensity;15;0;Create;True;0;0;False;0;False;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;-2977.168,918.2638;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;219;-3279.401,502.5317;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;81;-3530.675,2274.353;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;-3589.853,2009.413;Inherit;False;Property;_Color2;Color 2;14;0;Create;True;0;0;False;0;False;0,0,0,0;0.02802799,0.2139935,0.308,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;156;-3395.703,-1178.889;Inherit;True;Property;_TextureSample4;Texture Sample 4;15;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;-2960.595,505.4384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;80;-3264.72,1916.836;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-3091.703,-602.8892;Inherit;False;Property;_RefraccionIndex;Refraccion Index;19;0;Create;True;0;0;False;0;False;0.1;0.5411765;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;209;-3027.703,-698.889;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GrabScreenPosition;205;-3043.703,-874.8889;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;250;-2779.887,506.0428;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;188;-3021.917,1964.097;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;190;-3127.792,2160.412;Inherit;False;Property;_Float4;Float 4;18;0;Create;True;0;0;False;0;False;0;0.4821218;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-2819.704,-666.889;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;206;-2819.704,-826.8889;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;247;-2512.55,882.8489;Inherit;False;Property;_Float8;Float 8;25;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-2822.523,2023.065;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;240;-2576.203,487.1915;Inherit;True;Property;_TextureSample1;Texture Sample 1;24;0;Create;True;0;0;False;0;False;-1;None;cac16ed83a36f514181496af8f007085;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-2238.616,541.0092;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;241;-2064.428,1828.653;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;207;-2675.703,-762.889;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;213;-3374.559,277.6838;Inherit;False;Property;_Color3;Color 3;20;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;245;-1871.36,762.4891;Inherit;False;Constant;_Color4;Color 4;23;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;244;-1615.27,1406.438;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;236;-1908.416,546.3711;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;181;-2531.703,-826.8889;Inherit;False;Global;_GrabScreen0;Grab Screen 0;19;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;214;-1427.916,420.0407;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;182;-2272,-768;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;138;-208,32;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;5;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Overlay;;Overlay;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;161;0;164;0
WireConnection;256;0;252;0
WireConnection;14;0;134;0
WireConnection;14;1;161;0
WireConnection;17;0;11;0
WireConnection;257;0;256;0
WireConnection;257;1;14;0
WireConnection;257;2;16;0
WireConnection;263;0;262;0
WireConnection;263;1;261;0
WireConnection;12;0;10;0
WireConnection;218;0;222;0
WireConnection;26;0;17;0
WireConnection;26;1;20;0
WireConnection;260;0;257;0
WireConnection;260;2;263;0
WireConnection;260;1;131;0
WireConnection;23;0;12;0
WireConnection;23;1;14;0
WireConnection;23;2;16;0
WireConnection;8;0;4;0
WireConnection;8;1;5;0
WireConnection;29;0;26;0
WireConnection;220;0;218;0
WireConnection;220;1;221;0
WireConnection;75;2;76;0
WireConnection;75;3;77;0
WireConnection;238;0;260;0
WireConnection;24;0;23;0
WireConnection;24;2;8;0
WireConnection;24;1;131;0
WireConnection;55;0;45;0
WireConnection;55;1;44;0
WireConnection;55;2;29;0
WireConnection;232;0;233;0
WireConnection;232;1;238;0
WireConnection;219;0;220;0
WireConnection;81;0;75;0
WireConnection;156;0;134;0
WireConnection;156;1;24;0
WireConnection;156;5;135;0
WireConnection;223;0;219;0
WireConnection;223;1;232;0
WireConnection;80;0;55;0
WireConnection;80;1;78;0
WireConnection;80;2;81;0
WireConnection;209;0;156;0
WireConnection;250;0;223;0
WireConnection;188;0;80;0
WireConnection;208;0;209;0
WireConnection;208;1;210;0
WireConnection;206;0;205;1
WireConnection;206;1;205;2
WireConnection;189;0;188;0
WireConnection;189;1;190;0
WireConnection;240;1;250;0
WireConnection;248;0;240;0
WireConnection;248;1;247;0
WireConnection;241;0;240;0
WireConnection;241;1;189;0
WireConnection;207;0;206;0
WireConnection;207;1;208;0
WireConnection;244;0;241;0
WireConnection;236;0;248;0
WireConnection;181;0;207;0
WireConnection;214;0;213;0
WireConnection;214;1;245;0
WireConnection;214;2;236;0
WireConnection;182;0;181;0
WireConnection;182;1;80;0
WireConnection;182;2;244;0
WireConnection;138;0;156;0
WireConnection;0;0;182;0
WireConnection;0;1;138;0
WireConnection;0;2;214;0
ASEEND*/
//CHKSM=E4A4AB6C9A5D2F1AE82B8A072FDA4EACD69FB0C0