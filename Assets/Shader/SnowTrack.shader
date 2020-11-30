Shader "Custom/SnowTrack" {
	Properties {
	    _Tess ("Tessellation", Range(1,32)) = 4
		_SnowColor ("Snow Color", Color) = (1,1,1,1)
		_MaskColor ("Snow Color", Color) = (1,1,1,1)
		_SnowTex ("Snow (RGB)", 2D) = "white" {}
		_GroundColor ("Ground Color", Color) = (1,1,1,1)
		_GroundTex ("Ground (RGB)", 2D) = "white" {}
		_Splat ("Splat Map", 2D) = "black" {}
		_Mask ("ColorMaskMap", 2D) = "black" {}
		_MaskTex ("DepthMaskMap", 2D) = "black" {}
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Displacement ("Displacement", Range(0, 1.0)) = 0.3
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:disp tessellate:tessDistance

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 4.6

		 #include "Tessellation.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };

            float _Tess;

            float4 tessDistance (appdata v0, appdata v1, appdata v2) {
                float minDist = 10.0;
                float maxDist = 25.0;
                return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
            }

            sampler2D _Splat;
			sampler2D _MaskTex;
            float _Displacement;

            void disp (inout appdata v)
            {
				half opacity = tex2D(_MaskTex, v.texcoord).a;
				float t = tex2D(_MaskTex, v.texcoord).r;
				//float alpha = col2.r;
				float val = 1.0 - t;

                float d = tex2Dlod(_Splat, float4(v.texcoord.xy,0,0)).r * _Displacement ;
				//d*=val;
                v.vertex.xyz -= v.normal * d;  // invert + to - to make it go down
				v.vertex.xyz += v.normal * _Displacement; // will push the other vertices upwards so we have a good collider with ground not the snow
            }


		sampler2D _GroundTex;

		fixed4 _GroundColor;
		sampler2D _SnowTex;
		sampler2D _Mask;

		fixed4 _SnowColor;
		fixed4 _MaskColor;

		struct Input {
			float2 uv_GroundTex;
			float2 uv_SnowTex;
			float2 uv_Splat;
		};

		half _Glossiness;
		half _Metallic;
		

		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			half amount = tex2Dlod(_Splat, float4(IN.uv_Splat,0,0)).r; 
			half maskAmount = tex2Dlod(_Mask, float4(IN.uv_Splat,0,0)).r; 


			fixed4 col2 = tex2D(_Mask, IN.uv_GroundTex);
			float alpha = col2.r;

			float t = tex2D(_Mask, IN.uv_GroundTex).r;
				//float alpha = col2.r;
			float val = 1.0 - t;

			

			fixed4 m = tex2D (_Mask, IN.uv_GroundTex * alpha) * _MaskColor;//, tex2D (_GroundTex, IN.uv_GroundTex) * _GroundColor, maskAmount);
			fixed4 c = lerp(tex2D (_SnowTex, IN.uv_SnowTex) * _SnowColor, tex2D (_GroundTex, IN.uv_GroundTex) * _GroundColor, amount);

	
            //return fixed4(col.r, col.g, col.b,alpha);
			//fixed4 neCol = (col2.r,col2.g,col2.g,1);
			c*=  m;
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
