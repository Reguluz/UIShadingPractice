// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "14/Wave"
{
	Properties
	{
		_rotation("rotation", Range( 0 , 1)) = 0
		_amp("amp", Float) = 5.59
		_Color1("Color 1", Color) = (1,0.2392157,0.4668612,1)
		_Vector1("Vector 1", Vector) = (0.14,0.52,4.55,7.06)
		_Vector0("Vector 0", Vector) = (0.86,0.95,2.06,3.46)
		_Color2("Color 2", Color) = (1,0.2392157,0.4668612,1)
		_Color3("Color 3", Color) = (1,0.2392157,0.4668612,1)
		_Vector2("Vector 2", Vector) = (0.14,0.52,4.55,7.06)
		_Vector3("Vector 3", Vector) = (0.14,0.52,4.55,7.06)
		_Color0("Color 0", Color) = (0.3596929,1,0.240566,1)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Color0;
			uniform float _amp;
			uniform float _rotation;
			uniform float4 _Vector0;
			uniform float4 _Color1;
			uniform float4 _Vector1;
			uniform float4 _Color2;
			uniform float4 _Vector2;
			uniform float4 _Color3;
			uniform float4 _Vector3;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord3 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult20 = (float2(texCoord3.x , ( texCoord3.y * _amp )));
				float cos8 = cos( ( ( 2.0 * UNITY_PI ) * _rotation ) );
				float sin8 = sin( ( ( 2.0 * UNITY_PI ) * _rotation ) );
				float2 rotator8 = mul( ( appendResult20 - float2( 0.5,0.5 ) ) - float2( 0,0 ) , float2x2( cos8 , -sin8 , sin8 , cos8 )) + float2( 0,0 );
				float2 temp_output_2_0 = ( rotator8 + float2( 0.5,0.5 ) );
				float2 break6_g4 = ( ( temp_output_2_0 * UNITY_PI ) / _Vector0.z );
				float mulTime5_g4 = _Time.y * _Vector0.x;
				float2 break6_g5 = ( ( temp_output_2_0 * UNITY_PI ) / _Vector1.z );
				float mulTime5_g5 = _Time.y * _Vector1.x;
				float2 break6_g6 = ( ( temp_output_2_0 * UNITY_PI ) / _Vector2.z );
				float mulTime5_g6 = _Time.y * _Vector2.x;
				float2 break6_g7 = ( ( temp_output_2_0 * UNITY_PI ) / _Vector3.z );
				float mulTime5_g7 = _Time.y * _Vector3.x;
				
				
				finalColor = max( max( max( ( _Color0 * step( ( break6_g4.y - sin( ( ( break6_g4.x + mulTime5_g4 ) * UNITY_PI ) ) ) , ( _Vector0.y * UNITY_PI ) ) ) , ( _Color1 * step( ( break6_g5.y - sin( ( ( break6_g5.x + mulTime5_g5 ) * UNITY_PI ) ) ) , ( _Vector1.y * UNITY_PI ) ) ) ) , ( _Color2 * step( ( break6_g6.y - sin( ( ( break6_g6.x + mulTime5_g6 ) * UNITY_PI ) ) ) , ( _Vector2.y * UNITY_PI ) ) ) ) , ( _Color3 * step( ( break6_g7.y - sin( ( ( break6_g7.x + mulTime5_g7 ) * UNITY_PI ) ) ) , ( _Vector3.y * UNITY_PI ) ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
-90;970;2498;864;2406.818;586.7385;1.830102;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2397.447,-116.1356;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-2165.613,113.3464;Inherit;False;Property;_amp;amp;1;0;Create;True;0;0;0;False;0;False;5.59;19.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2043.613,20.34644;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1790.644,203.1559;Inherit;False;Property;_rotation;rotation;0;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1893.613,-103.6536;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PiNode;5;-1726.644,37.15601;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-1699.918,-98.5658;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1498.645,45.15601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;8;-1379.983,-108.1006;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;31;-916.5889,-497.8743;Inherit;False;Property;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0.86,0.95,2.06,3.46;0.86,0.95,2.06,3.46;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;43;-1018.909,97.49748;Inherit;False;Property;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;0.14,0.52,4.55,7.06;0.14,0.52,4.55,7.06;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-1158.316,-108.6028;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;42;-568.4691,-387.7974;Inherit;True;SubWave;-1;;4;e5576dd5e69455248ad476a8ef32bbd9;0;4;20;FLOAT;1;False;18;FLOAT;0.25;False;19;FLOAT;1;False;16;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;-365.1219,-583.1467;Inherit;False;Property;_Color0;Color 0;9;0;Create;True;0;0;0;False;0;False;0.3596929,1,0.240566,1;0.572549,1,0.6206841,0.5686275;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;36;-348.9091,-28.50249;Inherit;False;Property;_Color1;Color 1;2;0;Create;True;0;0;0;False;0;False;1,0.2392157,0.4668612,1;1,0.5681055,0.5411765,0.5960785;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;41;-580.7283,132.4757;Inherit;True;SubWave;-1;;5;e5576dd5e69455248ad476a8ef32bbd9;0;4;20;FLOAT;1;False;18;FLOAT;0.25;False;19;FLOAT;1;False;16;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;44;-1011.965,645.1786;Inherit;False;Property;_Vector2;Vector 2;7;0;Create;True;0;0;0;False;0;False;0.14,0.52,4.55,7.06;0.14,0.52,4.55,7.06;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-118.1214,-438.1462;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;45;-341.9641,519.1787;Inherit;False;Property;_Color2;Color 2;5;0;Create;True;0;0;0;False;0;False;1,0.2392157,0.4668612,1;1,0.5681055,0.5411765,0.5960785;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-107.909,84.49748;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;46;-573.7837,680.1569;Inherit;True;SubWave;-1;;6;e5576dd5e69455248ad476a8ef32bbd9;0;4;20;FLOAT;1;False;18;FLOAT;0.25;False;19;FLOAT;1;False;16;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;48;-982.6839,1139.5;Inherit;False;Property;_Vector3;Vector 3;8;0;Create;True;0;0;0;False;0;False;0.14,0.52,4.55,7.06;0.14,0.52,4.55,7.06;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;50;-544.5031,1174.478;Inherit;True;SubWave;-1;;7;e5576dd5e69455248ad476a8ef32bbd9;0;4;20;FLOAT;1;False;18;FLOAT;0.25;False;19;FLOAT;1;False;16;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-100.9642,632.1786;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;40;296.4861,-124.9163;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;49;-312.6838,1013.5;Inherit;False;Property;_Color3;Color 3;6;0;Create;True;0;0;0;False;0;False;1,0.2392157,0.4668612,1;1,0.5681055,0.5411765,0.5960785;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;52;565.2678,335.6328;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-71.68375,1126.5;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;53;794.0286,785.8377;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;1141.776,709.1719;Float;False;True;-1;2;ASEMaterialInspector;100;1;14/Wave;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;19;0;3;2
WireConnection;19;1;18;0
WireConnection;20;0;3;1
WireConnection;20;1;19;0
WireConnection;7;0;20;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;8;0;7;0
WireConnection;8;2;6;0
WireConnection;2;0;8;0
WireConnection;42;20;31;1
WireConnection;42;18;31;2
WireConnection;42;19;31;3
WireConnection;42;16;2;0
WireConnection;41;20;43;1
WireConnection;41;18;43;2
WireConnection;41;19;43;3
WireConnection;41;16;2;0
WireConnection;34;0;33;0
WireConnection;34;1;42;0
WireConnection;35;0;36;0
WireConnection;35;1;41;0
WireConnection;46;20;44;1
WireConnection;46;18;44;2
WireConnection;46;19;44;3
WireConnection;46;16;2;0
WireConnection;50;20;48;1
WireConnection;50;18;48;2
WireConnection;50;19;48;3
WireConnection;50;16;2;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;40;0;34;0
WireConnection;40;1;35;0
WireConnection;52;0;40;0
WireConnection;52;1;47;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;53;0;52;0
WireConnection;53;1;51;0
WireConnection;1;0;53;0
ASEEND*/
//CHKSM=71D247F71640EC610C5CEEEDE73A142A80EEE021