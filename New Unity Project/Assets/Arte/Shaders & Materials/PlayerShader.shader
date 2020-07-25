// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PlayerShader"
{
	Properties
	{
		_SKin("SKin", 2D) = "white" {}
		_Clothes("Clothes", 2D) = "white" {}
		_baseColor("baseColor", Color) = (0,0,0,0)
		_patternColor("patternColor", Color) = (0,0,0,0)
		_clothesColor("clothesColor", Color) = (0,0,0,0)
		_ClothesSmootness("ClothesSmootness", Range( 0 , 1)) = 0
		_PenguinMetallic("PenguinMetallic", Range( 0 , 1)) = 0
		_PenguinSmoothness("Penguin Smoothness", Range( 0 , 1)) = 1
		_ClothesMetallic("ClothesMetallic", Range( 0 , 1)) = 0
		_SkinIntensity("SkinIntensity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _baseColor;
		uniform sampler2D _SKin;
		uniform float4 _SKin_ST;
		uniform sampler2D _Clothes;
		uniform float4 _Clothes_ST;
		uniform float4 _clothesColor;
		uniform float4 _patternColor;
		uniform float _SkinIntensity;
		uniform float _PenguinMetallic;
		uniform float _ClothesMetallic;
		uniform float _PenguinSmoothness;
		uniform float _ClothesSmootness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_SKin = i.uv_texcoord * _SKin_ST.xy + _SKin_ST.zw;
			float4 tex2DNode2 = tex2D( _SKin, uv_SKin );
			float2 uv_Clothes = i.uv_texcoord * _Clothes_ST.xy + _Clothes_ST.zw;
			float4 tex2DNode3 = tex2D( _Clothes, uv_Clothes );
			float4 temp_output_11_0 = ( _patternColor * saturate( ( tex2DNode2.g - tex2DNode3.b ) ) );
			o.Albedo = ( ( _baseColor * saturate( ( 1.0 - ( tex2DNode2.g + tex2DNode3.b ) ) ) ) + ( _clothesColor * tex2DNode3.b ) + temp_output_11_0 ).rgb;
			o.Emission = ( temp_output_11_0 * _SkinIntensity ).rgb;
			float lerpResult31 = lerp( _PenguinMetallic , _ClothesMetallic , tex2DNode3.b);
			o.Metallic = lerpResult31;
			float lerpResult29 = lerp( _PenguinSmoothness , _ClothesSmootness , tex2DNode3.b);
			o.Smoothness = lerpResult29;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
164;162;1402;753;2425.153;654.7896;1.776732;True;False
Node;AmplifyShaderEditor.SamplerNode;2;-1792,-304;Inherit;True;Property;_SKin;SKin;0;0;Create;True;0;0;False;0;False;-1;None;0ca7d0958a329d14cb0b14d01686c6d6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1792,-112;Inherit;True;Property;_Clothes;Clothes;1;0;Create;True;0;0;False;0;False;-1;None;3ddba65b861cdf24bad7f8176c660c69;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1456,-320;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;-1328,-320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-1455,-192;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;23;-1296,-192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-1283.059,-532.4571;Inherit;False;Property;_baseColor;baseColor;2;0;Create;True;0;0;False;0;False;0,0,0,0;0.968754,0.3148057,0.3148057,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-1349.353,-80.66467;Inherit;False;Property;_patternColor;patternColor;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.6320754,0.2474635,0.4397694,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;16;-1168,-320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-1355.673,98.03016;Inherit;False;Property;_clothesColor;clothesColor;4;0;Create;True;0;0;False;0;False;0,0,0,0;0.706,0,0.1849364,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-967,-196;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-939.3544,232.1168;Inherit;False;Property;_PenguinSmoothness;Penguin Smoothness;7;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-962.114,-87.80269;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-920.0898,323.0185;Inherit;False;Property;_ClothesSmootness;ClothesSmootness;5;0;Create;True;0;0;False;0;False;0;0.376;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-753.8828,105.9624;Inherit;False;Property;_SkinIntensity;SkinIntensity;9;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-960,-336;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-863.2813,458.4742;Inherit;False;Property;_PenguinMetallic;PenguinMetallic;6;0;Create;True;0;0;False;0;False;0;0.116;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-859.4165,542.5317;Inherit;False;Property;_ClothesMetallic;ClothesMetallic;8;0;Create;True;0;0;False;0;False;0;0.117;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;-326.3244,354.9601;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;-345.9333,232.9759;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-539.5828,-201.1874;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-343.2343,75.16373;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;25;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PlayerShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;2;2
WireConnection;15;1;3;3
WireConnection;18;0;15;0
WireConnection;22;0;2;2
WireConnection;22;1;3;3
WireConnection;23;0;22;0
WireConnection;16;0;18;0
WireConnection;11;0;8;0
WireConnection;11;1;23;0
WireConnection;12;0;9;0
WireConnection;12;1;3;3
WireConnection;17;0;7;0
WireConnection;17;1;16;0
WireConnection;31;0;32;0
WireConnection;31;1;30;0
WireConnection;31;2;3;3
WireConnection;29;0;27;0
WireConnection;29;1;26;0
WireConnection;29;2;3;3
WireConnection;14;0;17;0
WireConnection;14;1;12;0
WireConnection;14;2;11;0
WireConnection;34;0;11;0
WireConnection;34;1;33;0
WireConnection;25;0;14;0
WireConnection;25;2;34;0
WireConnection;25;3;31;0
WireConnection;25;4;29;0
ASEEND*/
//CHKSM=BACFC826353A55F2B6929CCD6E979625C98389E3