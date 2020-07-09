// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "5"
{
	Properties
	{
		_Flowmap("Flowmap", 2D) = "white" {}
		_FlowmapTiling("Flowmap Tiling", Int) = 0
		_FlowmapIntensity("Flowmap Intensity", Float) = 0
		_Watercolor("Water color", Color) = (1,0,0.009047508,0)
		_Shadowcolor("Shadow color", Color) = (0,1,0.03440881,0)
		_ShadowDepthDistance("Shadow Depth Distance", Float) = 0
		_ShadowfallOff("Shadow fallOff", Float) = 0
		_Fresnelcolor("Fresnel color", Color) = (0,0,0,0)
		_Fresnelscale("Fresnel scale", Float) = 0
		_Fresnelpower("Fresnel power", Float) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_WaterreflexionColor("Water reflexion Color", Color) = (0,0,0,0)
		_ReflexionTiling("Reflexion Tiling", Float) = 0
		_Waterreflexion("Water reflexion", Range( 0 , 1)) = 0
		_FoamRamp("Foam Ramp", 2D) = "white" {}
		_Foamnoisetiling("Foam noise tiling", Int) = 0
		_Foamspeedx("Foam speed x", Float) = 0
		_FoamspeedY("Foam speed Y", Float) = 0
		_Foamnoisemultiplier("Foam noise multiplier", Float) = 0
		_Foamcolor("Foam color", Color) = (1,1,1,0)
		_FoamfallOf("Foam fallOf", Float) = 0
		_FoamDistance("Foam Distance", Float) = 0
		_FoamIntensity("Foam Intensity", Range( 0 , 1)) = 0
		_NormalTiling("Normal Tiling", Int) = 0
		_NormalIntensity("Normal Intensity", Float) = 0
		_NormalspeedY("Normal speed Y", Float) = 0
		_NormalspeedX("Normal speed X", Float) = 0
		_RefraccionIndex("Refraccion Index", Range( 0 , 1)) = 0.1
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
		uniform int _NormalTiling;
		uniform int _FlowmapTiling;
		uniform float _FlowmapIntensity;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _RefraccionIndex;
		uniform float4 _Shadowcolor;
		uniform float4 _Watercolor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _ShadowDepthDistance;
		uniform float _ShadowfallOff;
		uniform float4 _Fresnelcolor;
		uniform float _Fresnelscale;
		uniform float _Fresnelpower;
		uniform sampler2D _FoamRamp;
		uniform float _FoamDistance;
		uniform float _FoamfallOf;
		uniform float _Foamnoisemultiplier;
		uniform float _Foamspeedx;
		uniform float _FoamspeedY;
		uniform int _Foamnoisetiling;
		uniform float _Opacity;
		uniform float _ReflexionTiling;
		uniform float _Waterreflexion;
		uniform float4 _Foamcolor;
		uniform float _FoamIntensity;
		uniform float4 _WaterreflexionColor;


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


		float2 voronoihash281( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi281( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash281( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime131 = _Time.y * 0.1;
			float2 appendResult8 = (float2(_NormalspeedX , _NormalspeedY));
			float2 temp_cast_0 = _NormalTiling;
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
			float4 screenColor181 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( appendResult206 - ( _RefraccionIndex * (tex2DNode156).xy ) ));
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth17 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth17 = abs( ( screenDepth17 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _ShadowDepthDistance ) );
			float4 lerpResult55 = lerp( _Shadowcolor , _Watercolor , saturate( pow( distanceDepth17 , _ShadowfallOff ) ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV75 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode75 = ( 0.0 + _Fresnelscale * pow( 1.0 - fresnelNdotV75, _Fresnelpower ) );
			float4 lerpResult80 = lerp( lerpResult55 , _Fresnelcolor , saturate( fresnelNode75 ));
			float screenDepth218 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth218 = abs( ( screenDepth218 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FoamDistance ) );
			float2 appendResult263 = (float2(_Foamspeedx , _FoamspeedY));
			float2 temp_cast_4 = _Foamnoisetiling;
			float2 uv_TexCoord256 = i.uv_texcoord * temp_cast_4;
			float4 lerpResult257 = lerp( float4( uv_TexCoord256, 0.0 , 0.0 ) , tex2DNode14 , _FlowmapIntensity);
			float2 panner260 = ( mulTime131 * appendResult263 + lerpResult257.rg);
			float simplePerlin2D238 = snoise( panner260 );
			simplePerlin2D238 = simplePerlin2D238*0.5 + 0.5;
			float2 temp_cast_7 = (saturate( ( ( 1.0 - pow( distanceDepth218 , _FoamfallOf ) ) * ( _Foamnoisemultiplier * simplePerlin2D238 ) ) )).xx;
			float4 tex2DNode240 = tex2D( _FoamRamp, temp_cast_7 );
			float time281 = 0.0;
			float2 temp_cast_8 = (( _NormalTiling * _ReflexionTiling )).xx;
			float2 uv_TexCoord283 = i.uv_texcoord * temp_cast_8;
			float3 lerpResult286 = lerp( tex2DNode156 , float3( uv_TexCoord283 ,  0.0 ) , 0.5);
			float2 panner285 = ( 1.0 * _Time.y * float2( 0,0 ) + lerpResult286.xy);
			float2 coords281 = panner285 * 1.0;
			float2 id281 = 0;
			float voroi281 = voronoi281( coords281, time281,id281, 0 );
			float temp_output_278_0 = saturate( ( voroi281 * _Waterreflexion ) );
			float4 lerpResult182 = lerp( screenColor181 , lerpResult80 , saturate( ( tex2DNode240 + ( distance( lerpResult80 , float4( 1,1,1,1 ) ) * _Opacity ) + temp_output_278_0 ) ));
			o.Albedo = lerpResult182.rgb;
			o.Emission = saturate( ( ( _Foamcolor * ( tex2DNode240 * _FoamIntensity ) ) + ( _WaterreflexionColor * temp_output_278_0 ) ) ).rgb;
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
481;140;881;785;5545.7;2289.172;6.399999;True;False
Node;AmplifyShaderEditor.CommentaryNode;268;-5280,-736;Inherit;False;819.001;365;Flowmap preparation;4;16;14;161;164;;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;164;-5232,-608;Inherit;False;Property;_FlowmapTiling;Flowmap Tiling;2;0;Create;True;0;0;False;0;False;0;5;0;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;266;-3808,-784;Inherit;False;892;389;Normal with flowmap;8;10;12;5;4;8;23;135;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;272;-4864,912;Inherit;False;1296.649;338.1986;Noise UV;7;262;261;263;257;260;256;252;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;161;-5024,-624;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;252;-4816,976;Float;False;Property;_Foamnoisetiling;Foam noise tiling;17;0;Create;True;0;0;False;0;False;0;28;0;1;INT;0
Node;AmplifyShaderEditor.TexturePropertyNode;134;-5056,-944;Inherit;True;Property;_Flowmap;Flowmap;1;0;Create;True;0;0;False;0;False;None;be114cc752a6153449cf1b4b002b490d;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.IntNode;10;-3792,-736;Float;False;Property;_NormalTiling;Normal Tiling;24;0;Create;True;0;0;False;0;False;0;6;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-3536,-512;Float;False;Property;_NormalspeedY;Normal speed Y;26;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-4784,-688;Inherit;True;Property;_owo;owo;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;256;-4592,960;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;270;-3936,416;Inherit;False;845;277;Foam depth;5;220;221;219;218;222;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-4720,-480;Float;False;Property;_FlowmapIntensity;Flowmap Intensity;3;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;262;-4128,1056;Float;False;Property;_Foamspeedx;Foam speed x;18;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3536,-592;Float;False;Property;_NormalspeedX;Normal speed X;27;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;288;-3360.922,1589.161;Inherit;False;1685.009;438.8079;Water reflexion Mask;9;279;280;281;285;286;293;283;292;284;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-3600,-736;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;6;-2368,-304;Inherit;False;783.8231;220.9031;Shadow depth Fade;5;11;20;17;26;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;261;-4128,1136;Float;False;Property;_FoamspeedY;Foam speed Y;19;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;269;-4112,-128;Inherit;False;250;160;Le time;1;131;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-3328,-560;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;131;-4048,-80;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;263;-3920,1088;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;23;-3328,-736;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-3888,464;Inherit;False;Property;_FoamDistance;Foam Distance;22;0;Create;True;0;0;False;0;False;0;0.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2352,-256;Float;False;Property;_ShadowDepthDistance;Shadow Depth Distance;6;0;Create;True;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;257;-4272,976;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;284;-3238.243,1762.294;Inherit;False;Property;_ReflexionTiling;Reflexion Tiling;13;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;273;-1843.095,12.90516;Inherit;False;690.0948;320.0948;Fresnel;4;81;75;76;77;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;24;-3136,-736;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;267;-2864,-944;Inherit;False;370;280;Normal Result;1;156;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-2986.477,1725.555;Inherit;False;2;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;17;-2112,-256;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-3152,-608;Inherit;False;Property;_NormalIntensity;Normal Intensity;25;0;Create;True;0;0;False;0;False;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;260;-3776,976;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;218;-3696,480;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2064,-160;Float;False;Property;_ShadowfallOff;Shadow fallOff;7;0;Create;True;0;0;False;0;False;0;2.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;271;-3552,720;Inherit;False;465.02;399.6791;Noise;3;233;238;232;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-3616,576;Inherit;False;Property;_FoamfallOf;Foam fallOf;21;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;220;-3440,528;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;293;-2746.664,1869.231;Inherit;False;Constant;_Value;Value;29;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;26;-1872,-224;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;283;-2831.299,1667.202;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;233;-3472,768;Inherit;False;Property;_Foamnoisemultiplier;Foam noise multiplier;20;0;Create;True;0;0;False;0;False;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;238;-3488,864;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1793.095,142.9052;Inherit;False;Property;_Fresnelpower;Fresnel power;10;0;Create;True;0;0;False;0;False;0;1.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1793.095,62.90516;Inherit;False;Property;_Fresnelscale;Fresnel scale;9;0;Create;True;0;0;False;0;False;0;1.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;156;-2816,-880;Inherit;True;Property;_Normalresult;Normal result;15;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;286;-2577.01,1669.161;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;44;-1623.194,-498.0038;Inherit;False;Property;_Watercolor;Water color;4;0;Create;True;0;0;False;0;False;1,0,0.009047508,0;0.1368369,0.6132559,0.7075472,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;-3248,816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-1616,-672;Inherit;False;Property;_Shadowcolor;Shadow color;5;0;Create;True;0;0;False;0;False;0,1,0.03440881,0;0.2102617,0.2475668,0.254717,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;75;-1616,80;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;219;-3280,528;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;29;-1728,-224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;-1328,-368;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;78;-1424,-240;Inherit;False;Property;_Fresnelcolor;Fresnel color;8;0;Create;True;0;0;False;0;False;0,0,0,0;0.02802799,0.2139935,0.308,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;-3024,656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;81;-1328,80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;285;-2369.01,1669.161;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;264;-1455.28,560;Inherit;False;1108.657;451.931;E mission;8;247;289;275;290;213;248;291;294;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VoronoiNode;281;-2193.01,1637.161;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT2;1
Node;AmplifyShaderEditor.CommentaryNode;274;-1136,16;Inherit;False;428.1582;258;Opacity mask with Greyscale;3;189;188;190;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;80;-1168,-224;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;265;-1360,-1440;Inherit;False;843.5981;552.6404;Refraction;7;181;206;205;207;210;208;209;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;280;-2225.01,1893.161;Inherit;False;Property;_Waterreflexion;Water reflexion;14;0;Create;True;0;0;False;0;False;0;0.439;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;250;-2880,656;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;279;-1921.01,1637.161;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;209;-1264,-1120;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;188;-1008,80;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;190;-1120,176;Inherit;False;Property;_Opacity;Opacity;11;0;Create;True;0;0;False;0;False;0;0.1569425;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;205;-1312,-1392;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;247;-1424,896;Inherit;False;Property;_FoamIntensity;Foam Intensity;23;0;Create;True;0;0;False;0;False;0;0.5751029;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-1312,-1200;Inherit;False;Property;_RefraccionIndex;Refraccion Index;28;0;Create;True;0;0;False;0;False;0.1;0.5411765;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;240;-2688,-112;Inherit;True;Property;_FoamRamp;Foam Ramp;16;0;Create;True;0;0;False;0;False;-1;None;cac16ed83a36f514181496af8f007085;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;206;-1024,-1296;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-848,128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;278;-1392,1280;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-1024,-1136;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;275;-976,832;Inherit;False;Property;_WaterreflexionColor;Water reflexion Color;12;0;Create;True;0;0;False;0;False;0,0,0,0;0.7216981,0.9910952,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;213;-1200,608;Inherit;False;Property;_Foamcolor;Foam color;20;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-1136,816;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;207;-848,-1120;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;241;-704,-112;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;-928,656;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-720,800;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;181;-688,-1072;Inherit;False;Global;_GrabScreen0;Grab Screen 0;19;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;244;-560,-112;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;291;-640,624;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;294;-496,624;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;182;-400,-240;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;138;-608,16;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;5;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Overlay;;Overlay;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;161;0;164;0
WireConnection;14;0;134;0
WireConnection;14;1;161;0
WireConnection;256;0;252;0
WireConnection;12;0;10;0
WireConnection;8;0;4;0
WireConnection;8;1;5;0
WireConnection;263;0;262;0
WireConnection;263;1;261;0
WireConnection;23;0;12;0
WireConnection;23;1;14;0
WireConnection;23;2;16;0
WireConnection;257;0;256;0
WireConnection;257;1;14;0
WireConnection;257;2;16;0
WireConnection;24;0;23;0
WireConnection;24;2;8;0
WireConnection;24;1;131;0
WireConnection;292;0;10;0
WireConnection;292;1;284;0
WireConnection;17;0;11;0
WireConnection;260;0;257;0
WireConnection;260;2;263;0
WireConnection;260;1;131;0
WireConnection;218;0;222;0
WireConnection;220;0;218;0
WireConnection;220;1;221;0
WireConnection;26;0;17;0
WireConnection;26;1;20;0
WireConnection;283;0;292;0
WireConnection;238;0;260;0
WireConnection;156;0;134;0
WireConnection;156;1;24;0
WireConnection;156;5;135;0
WireConnection;286;0;156;0
WireConnection;286;1;283;0
WireConnection;286;2;293;0
WireConnection;232;0;233;0
WireConnection;232;1;238;0
WireConnection;75;2;76;0
WireConnection;75;3;77;0
WireConnection;219;0;220;0
WireConnection;29;0;26;0
WireConnection;55;0;45;0
WireConnection;55;1;44;0
WireConnection;55;2;29;0
WireConnection;223;0;219;0
WireConnection;223;1;232;0
WireConnection;81;0;75;0
WireConnection;285;0;286;0
WireConnection;281;0;285;0
WireConnection;80;0;55;0
WireConnection;80;1;78;0
WireConnection;80;2;81;0
WireConnection;250;0;223;0
WireConnection;279;0;281;0
WireConnection;279;1;280;0
WireConnection;209;0;156;0
WireConnection;188;0;80;0
WireConnection;240;1;250;0
WireConnection;206;0;205;1
WireConnection;206;1;205;2
WireConnection;189;0;188;0
WireConnection;189;1;190;0
WireConnection;278;0;279;0
WireConnection;208;0;210;0
WireConnection;208;1;209;0
WireConnection;248;0;240;0
WireConnection;248;1;247;0
WireConnection;207;0;206;0
WireConnection;207;1;208;0
WireConnection;241;0;240;0
WireConnection;241;1;189;0
WireConnection;241;2;278;0
WireConnection;290;0;213;0
WireConnection;290;1;248;0
WireConnection;289;0;275;0
WireConnection;289;1;278;0
WireConnection;181;0;207;0
WireConnection;244;0;241;0
WireConnection;291;0;290;0
WireConnection;291;1;289;0
WireConnection;294;0;291;0
WireConnection;182;0;181;0
WireConnection;182;1;80;0
WireConnection;182;2;244;0
WireConnection;138;0;156;0
WireConnection;0;0;182;0
WireConnection;0;1;138;0
WireConnection;0;2;294;0
ASEEND*/
//CHKSM=A184DD78CED8ECA464C0773FA78385329247FB1A