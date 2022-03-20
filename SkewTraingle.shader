// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "14/SkewTraingle"
{
	Properties
	{
		
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
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
				float2 texCoord2 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_3_0_g1 = mul( float3( ( texCoord2 * ( 8.0 + _SinTime.w ) ) ,  0.0 ), float3x3(1,-0.5780347,0,0,1.156069,0,0,0,1) ).xy;
				float2 break5_g1 = temp_output_3_0_g1;
				float3 appendResult6_g1 = (float3(temp_output_3_0_g1 , ( 1.0 - ( break5_g1.x + break5_g1.y ) )));
				float3 temp_output_9_0_g1 = ( floor( appendResult6_g1 ) + float3( 0.5,0.5,0.5 ) );
				float4 color18 = IsGammaSpace() ? float4(0.45,0.35,0.15,1) : float4(0.1706449,0.1004815,0.01960665,1);
				float3 temp_output_11_0_g1 = frac( temp_output_9_0_g1 );
				float3 lerpResult16_g1 = lerp( temp_output_11_0_g1 , ( 1.0 - temp_output_11_0_g1 ) , step( length( temp_output_11_0_g1 ) , 1.0 ));
				float3 break30_g1 = abs( ( ( frac( lerpResult16_g1 ) * float3( 2,2,2 ) ) - float3( 1,1,1 ) ) );
				float3 break21_g1 = lerpResult16_g1;
				float2 appendResult22_g1 = (float2(break21_g1.x , break21_g1.y));
				float2 temp_cast_4 = (( ceil( ( 1.0 - break21_g1.z ) ) / 3.0 )).xx;
				float2 temp_output_27_0_g1 = mul( float3( ( appendResult22_g1 - temp_cast_4 ) ,  0.0 ), float3x3(1,0.5,0,0,0.865,0,0,0,1) ).xy;
				float2 temp_cast_7 = (( ceil( ( 1.0 - break21_g1.z ) ) / 3.0 )).xx;
				float4 appendResult34_g1 = (float4(( ( 1.0 - max( max( break30_g1.x , break30_g1.y ) , break30_g1.z ) ) * 0.43 ) , length( temp_output_27_0_g1 ) , temp_output_27_0_g1));
				float smoothstepResult22 = smoothstep( 0.0 , 0.035 , ( appendResult34_g1.x - 0.035 ));
				float4 lerpResult20 = lerp( float4( 0,0,0,0 ) , ( ( pow( abs( sin( ( ( length( temp_output_9_0_g1 ) * 0.5 ) + ( 0.65 * _Time.y ) ) ) ) , 4.0 ) + 1.0 ) * color18 ) , smoothstepResult22);
				float smoothstepResult24 = smoothstep( 0.0 , 0.055 , appendResult34_g1.x);
				float4 lerpResult23 = lerp( float4( 1,1,1,1 ) , lerpResult20 , ( smoothstepResult24 * smoothstepResult24 ));
				
				
				finalColor = lerpResult23;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
949;957;2498;858;153.0314;303.681;2.242131;True;True
Node;AmplifyShaderEditor.SinTimeNode;5;-1359,-76;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1297,-265;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-1156,-101;Inherit;False;2;2;0;FLOAT;8;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1022,-186;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;1;-834,-183;Inherit;False;SkewTriGrid;-1;;1;3097d4e6ca408b947bf085d131d79331;0;1;2;FLOAT2;0,0;False;2;FLOAT3;36;FLOAT4;0
Node;AmplifyShaderEditor.LengthOpNode;7;-630,-58;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-653,84;Inherit;False;Constant;_patternVal;patternVal;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-640.0914,222.5566;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-487,-2;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-403,181;Inherit;False;2;2;0;FLOAT;0.65;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-302,66;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;12;-160.6925,66.02057;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;13;-13.6925,66.02057;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;14;129.3075,67.02057;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;19;578.8689,-127.6346;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;18;235.3075,257.0206;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.45,0.35,0.15,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;15;297.3075,63.02057;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;748.4337,-104.0169;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.035;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;22;929.4337,-100.0169;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.035;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;485.3075,72.02057;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;24;1212.434,-267.0169;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.055;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;1110.434,53.98309;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;1450.434,-189.0169;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;23;1618.434,41.98309;Inherit;True;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2178.451,104.1043;Float;False;True;-1;2;ASEMaterialInspector;100;1;14/SkewTraingle;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;4;1;5;4
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;1;2;3;0
WireConnection;7;0;1;36
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;10;1;11;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;12;0;9;0
WireConnection;13;0;12;0
WireConnection;14;0;13;0
WireConnection;19;0;1;0
WireConnection;15;0;14;0
WireConnection;21;0;19;0
WireConnection;22;0;21;0
WireConnection;16;0;15;0
WireConnection;16;1;18;0
WireConnection;24;0;19;0
WireConnection;20;1;16;0
WireConnection;20;2;22;0
WireConnection;25;0;24;0
WireConnection;25;1;24;0
WireConnection;23;1;20;0
WireConnection;23;2;25;0
WireConnection;0;0;23;0
ASEEND*/
//CHKSM=AA4135567DB0204DB79A9603C4364953C2C4D2B4