// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#pragma target 2.0

#include "Lighting.cginc"
#include "UnityCG.cginc"

#include "Flow.cginc"

float3 FlowUV (float2 uv, float2 flowVector, float2 jump,float flowOffset,float tiling,float time, bool flowB) {
    
    time = 0.1;
    float phaseOffset = flowB ? 0.5 : 0;
    float progress = frac(time + phaseOffset);
	float3 uvw;
	uvw.xy = uv - flowVector * progress + phaseOffset;
    uvw.xy = uv - flowVector * (progress + flowOffset);
	uvw.xy *= tiling;
	uvw.xy += phaseOffset;
    uvw.xy += (time - progress) * jump;
	uvw.z = 0.1 - abs(0.1 - 0.2 * progress);



	return uvw;
}

//  struct appdata
//             {
//                 float4 vertex : POSITION;
//                 float2 uv : TEXCOORD0;
//             };

struct v2f
{
    float4 pos: SV_POSITION;
     half4 uv: TEXCOORD0;
    float3 normal : NORMAL;
    float3 worldNormal: TEXCOORD1;
    float3 worldPos: TEXCOORD2;

   
    
    
    //normal
   // float3 viewDir : TEXCOORD1; // tangent.x, bitangent.x, normal.x
   //  half3 tspace1 : TEXCOORD2; // tangent.y, bitangent.y, normal.y
    half3 tspace2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
};



struct vertexOutput {
         float4 pos : SV_POSITION;
         float4 posWorld : TEXCOORD0;
         // position of the vertex (and fragment) in world space 
         float4 tex : TEXCOORD1;
         float3 tangentWorld : TEXCOORD2;  
         float3 normalWorld : TEXCOORD3;
         float3 binormalWorld : TEXCOORD4;
        // float4 grabPos : TEXCOORD0;
};

fixed4 _Color;
fixed4 _ColorTwo;
fixed4 _FurColor;
fixed4 _Specular;
fixed4 _BubbleColor;
half _Shininess;
half _FurShadeStep;
float _Blend;
float _BlendSpeed;
sampler2D _MainTex;
half4 _MainTex_ST;
sampler2D _FurTex;
sampler2D _StencilTex;
sampler2D _MaskTex;
half4 _FurTex_ST;
sampler2D _BubbleTex;
sampler2D _FlowMap;
sampler2D _Displacement;

fixed _FurLength;
fixed _BubbleLength;
fixed _FurDensity;
fixed _BubbleDensity;
fixed _FurThinness;
fixed _Thinness;
sampler2D _NormalMap;
fixed _FurShading;
float _Smooth;

float4 _ForceGlobal;
float4 _ForceLocal;
float4 _bubbleGlobal;
float4 _bubbleLocal;

sampler2D _BackgroundTexture;
fixed _Magnitude;
sampler2D _GrabTexture;
sampler2D _CameraDepthTexture;
sampler2D _BumpMap;
//sampler2D _NormalMap;
fixed4 _furOutput;

float _UJump, _VJump, _Tiling, _Speed, _FlowStrength, _FlowOffset;

float4 _DispTex_ST;
uniform float4 _BumpMap_ST;
uniform float _BumpDepth;

uniform float4 _RimColor;
uniform float _RimPower;


v2f vert_surface(appdata_full v)
{
    v2f o;
    o.pos = UnityObjectToClipPos(v.vertex);
   // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
   // o.normal = TRANSFORM_TEX(v.texcoord,_NormalMap);
    o.worldNormal = UnityObjectToWorldNormal(v.normal);
    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
    // half3 worldTangent = UnityObjectToWorldDir(v..xyz);
    // half tangentSign = v.w * unity_WorldTransformParams.w;
    // half3 worldBitangent = cross(o.worldNormal, worldTangent) * tangentSign;
     //o.uv = ComputeGrabScreenPos(o.uv);
               
    return o;
}

v2f vert_base(appdata_base v)
{
    v2f o;
    float3 P = v.vertex.xyz + v.normal * _FurLength * FURSTEP;
    P += clamp(mul(unity_WorldToObject, _ForceGlobal).xyz + _ForceLocal.xyz, -1, 1) * pow(FURSTEP, 3) * _FurLength;
    o.pos = UnityObjectToClipPos(float4(P, 1.0));
    o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
    o.uv.zw = TRANSFORM_TEX(v.texcoord, _FurTex);
    o.worldNormal = UnityObjectToWorldNormal(v.normal);
    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

    return o;
}

struct b2f
{
    float4 pos: SV_POSITION;
    //float2 uv : TEXCOORD0;
    half4 uv: TEXCOORD0;
    float3 normal : NORMAL;
    float3 worldNormal: TEXCOORD1;
    float3 worldPos: TEXCOORD2;

    half3 tspace2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
    half3 binormal : TEXCOORD4;
   
};

b2f vert_base2(appdata_full v)
{
    b2f o;

   
    fixed height = tex2Dlod(_Displacement, float4(v.texcoord.xy, 0, 0)).r;
    v.vertex.xy += v.normal * height * 0.25;

    o.worldPos = normalize( mul( float4( v.normal, 0.0 ), unity_WorldToObject ).xyz );
    o.tspace2 = normalize( mul( unity_ObjectToWorld, v.tangent ).xyz );
    o.binormal = normalize( cross( o.worldPos, o.tspace2));


    float3 P = v.vertex.xyz + v.normal * _BubbleLength * FURSTEP;
    P += clamp(mul(unity_WorldToObject, _bubbleGlobal).xyz + _bubbleLocal.xyz, -1, 1) * pow(FURSTEP, 3) * _BubbleLength;
    o.pos = UnityObjectToClipPos(float4(P, 1.0));

    o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
    // float3 dcolor = tex2Dlod (_BubbleTex, float4(o.uv.xy * _DispTex_ST.xy,0,0));
    // float3 MoveDirection = float3(2,4,1);
    // float d = (dcolor.r* _BubbleTex.r + dcolor.g * _BubbleTex.g + dcolor.b * _BubbleTex.b);
    //v.vertex.xyz += v.normal * d * _Displacement;
    o.uv.zw = TRANSFORM_TEX(v.texcoord, _FurTex);
    o.worldNormal = UnityObjectToWorldNormal(v.normal);
    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

   
    return o;
}

fixed4 frag_surface(v2f i): SV_Target
{   
    float2 flowVector = tex2D(_FlowMap, i.uv).rg * 2 -1;
    flowVector *= _FlowStrength;
    float _noise = tex2D(_FlowMap, i.uv).a;
    float time = _Time.y * _Speed + _noise;
    float2 jump = float2(_UJump, _VJump);
    float3 uv = FlowUV(i.worldPos, flowVector,jump, _FlowOffset,_Tiling,time, false);
    float3 uvA = FlowUV(i.worldPos, flowVector,jump,_FlowOffset,_Tiling,time, true);
    
    fixed3 worldNormal = normalize(i.worldNormal);
    fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
    fixed3 worldView = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
    fixed3 worldHalf = normalize(worldView + worldLight);

    fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color;
    
    // fixed3 albedo = tex2D(_MainTex, i.uv.xy  ).rgb  *  uv.z ;
    // fixed3 albedo2 = tex2D(_MainTex, i.uv.xy  ).rgb *  uvA.z ;
    // fixed3 c = (albedo + albedo2) * _Color;

    fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
    fixed3 diffuse = _LightColor0.rgb  * albedo * saturate(dot(worldNormal, worldLight));
    fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, worldHalf)), _Shininess);
    fixed3 color = ambient + diffuse ;//+ specular;
   // color.rgb = i.worldNormal*0.5+0.5;
    
    return fixed4(color, 0.01);
}

fixed4 frag_base(v2f i): SV_Target
{

    float2 flowVector = tex2D(_FlowMap, i.uv).rg * 2 -1;
    flowVector *= _FlowStrength;
    float _noise = tex2D(_FlowMap, i.uv).a;
    float time = _Time.y * _Speed + _noise;
    float2 jump = float2(_UJump, _VJump);
    float3 uv = FlowUV(i.uv, flowVector,jump, _FlowOffset,_Tiling,time, false);
    float3 uvA = FlowUV(i.uv, flowVector,jump,_FlowOffset,_Tiling,time, true);

  // i.uv.xy += sin((_Time.y + i.uv.y) * _Magnitude)/20;
    fixed3 worldNormal = normalize(i.worldNormal);
    fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
    fixed3 worldView = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
    fixed3 worldHalf = normalize(worldView + worldLight);

    fixed3  bgcolor = tex2Dproj(_BackgroundTexture, i.pos);
    fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _FurColor;
    albedo -= (pow(1 - FURSTEP, 3)) * _FurShading;
 
    fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

    fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldNormal, worldLight));
    fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, worldHalf)), _Shininess);

    fixed3 color = ambient + diffuse + specular;
    fixed3 noise = tex2D(_FurTex, i.uv.zw  * _FurThinness ).rgb  * smoothstep(color,0,_Smooth ) ;
    fixed3 noise2 = tex2D(_MaskTex, i.uv.zw  * _FurThinness ).rgb  * smoothstep(color,0,_Smooth ) ;

   fixed3 noise3 = tex2D(_StencilTex, i.uv.zw   ).rgb ;// * smoothstep(color,0,_Smooth ) ;

   
    float value  = (1-noise2);
    float value2  = (1 - noise3);
    noise *= (value2 + value);
   // noise *= value2;
    //if(value2 <0) noise = 0;
    fixed alpha = clamp(noise   - (FURSTEP * FURSTEP  ) * _FurDensity , 0, 6) * smoothstep(noise,0,_Smooth) ;
    // alpha *= value2;
    //color.rgb = i.worldNormal*0.5+0.5;
    // _furOutput = fixed4(color,alpha);
    return fixed4(color,alpha );
}


//bubble
fixed4 frag_base2(b2f i): SV_Target
{


  //  normal lighting 
    float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.worldNormal.xyz );
    float3 lightDirection;
    float atten;

    			if( _WorldSpaceLightPos0.w == 0.0 ) { // Directional Light
					atten = 1.0;
					lightDirection = normalize( _WorldSpaceLightPos0.xyz );
				} else {
					float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - i.worldNormal.xyz;
					float distance = length( fragmentToLightSource );
					float atten = 1 / distance;
					lightDirection = normalize( fragmentToLightSource );
				}


    float4 texN = tex2D( _BumpMap, i.uv.xy * _BumpMap_ST.xy + _BumpMap_ST.zw );

	// unpackNormal Function
	float3 localCoords = float3(2.0 * texN.ag - float2(1.0,1.0), 0.0);
    localCoords.z = _BumpDepth;

    // Normal Transpose Matrix
    float3x3 local2WorldTranspose = float3x3(
        i.tspace2,
        i.binormal,
        i.worldPos
    );

    // Calculate Normal Direction
    float3 normalDirection = normalize( mul( localCoords, local2WorldTranspose ) );
    
    // Lighting
    float3 diffuseReflection = atten * _LightColor0.rgb * saturate( dot( normalDirection, lightDirection ) );
    float3 specularReflection = diffuseReflection * _Specular.rgb * pow( saturate( dot( reflect( -lightDirection, normalDirection ), viewDirection ) ), _Shininess);
    

    // Rim Lighting
    float rim = 1 - saturate( dot( viewDirection, normalDirection ) );
    float3 rimLighting = saturate( pow( rim, _RimPower ) * _RimColor.rgb * diffuseReflection);
    float3 lightFinal = diffuseReflection + specularReflection + rimLighting + UNITY_LIGHTMODEL_AMBIENT.rgb;
    

//----------------------------------------------->>> bubbble color Albedo, height, specular
    
    float2 flowVector = tex2D(_FlowMap, i.uv).rg * 2 - 1;
    flowVector *= _FlowStrength;
    float _noise = tex2D(_FlowMap, i.uv).a;
    float time = _Time.y * _Speed ; //+ _noise;
    float2 jump = float2(_UJump, _VJump);
    float3 uv = FlowUV(i.uv, flowVector,jump, _FlowOffset,_Tiling,time, true);
    float3 uvA = FlowUV(i.uv, flowVector,jump,_FlowOffset,_Tiling,time, true);
    // half4 bump = tex2D(_MainTex, i.uv );
    // half2 distortion = UnpackNormal(bump).rg;

    //i.uv.xy += sin((_Time.y + i.uv.y + i.uv.x) * _Magnitude)/20;
    // i.uv.xy += //distortion * _Magnitude; 

    fixed3 worldNormal = normalize(i.worldNormal);
    fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
    fixed3 worldView = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
    fixed3 worldHalf = normalize(worldView + worldLight);

    fixed3 bgcolor = tex2Dproj(_BackgroundTexture, i.pos);
    fixed3 albedo = tex2D(_MainTex, i.uv.xy  ).rgb ;// *  uv.z ;
    fixed3 albedo2 = tex2D(_MainTex, i.uv.xy  ).rgb *  uvA.z ;
    // albedo -= (pow(1 - FURSTEP, _FurShadeStep)) * _FurShading * _BubbleColor;
    // fixed4 col = tex2D( _GrabTexture, i.uv); 
    // fixed4 cyolor = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uv))
    // albedo = albedo * _furOutput;

    float2 t = float2(0, _Time.y * .03);
    float2 disp = tex2D(_FlowMap, i.uv + t).rg * 2 - 1;
    disp *= _FlowStrength;
    float n = tex2D(_NormalMap, i.uv * float2(1, .1) + t + disp).r;
    n = round(n * 5) / 5;

    fixed3 c = (albedo) * _BubbleColor;
    // c -= (pow(1 - FURSTEP, _FurShadeStep)) * _FurShading;// * _BubbleColor;
    fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * c;
    fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldNormal, worldLight));
    fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, worldHalf)), _Shininess);

    
    fixed3 color = ambient + diffuse  + specular ;//+ lightFinal;
    fixed3 noise = tex2D(_BubbleTex, i.uv.zw * _Thinness).rgb  * smoothstep(color,0,_Smooth)  ;
    fixed alpha = clamp(noise +(FURSTEP * FURSTEP) * _BubbleDensity, 0.1, 6) * smoothstep(noise,0,_Smooth) * n;
    //color.rgb = i.worldNormal*0.5+0.5;
    return fixed4(color ,alpha);
}