Shader "Fur/FurAttributesShader"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _FurColor ("FurColor", Color) = (1, 1, 1, 1)
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _BubbleColor ("BubbleColor", Color) = (1, 1, 1, 1)
        _Shininess ("Shininess", Range(0.00, 256.0)) = 0.0
        
        _MainTex ("Texture", 2D) = "white" { }
        _FurTex ("Fur Pattern", 2D) = "white" { }
        _BubbleTex ("Bubble Pattern", 2D) = "white" { }
        _NormalMap("NormalMap",2D) = "bump"{}
        _Displacement ("displacement", 2D) = "white" { }
        
        _FurLength ("Fur Length", Range(0.0, 5)) = 0.5
        _BubbleLength ("BubbleLength Length", Range(0.0, 5)) = 0.5
        _FurDensity ("Fur Density", Range(0, 4)) = 0.11
        _BubbleDensity ("BubbleDensity", Range(0, 4)) = 0.11
        _FurThinness ("Fur Thinness", Range(0.01, 10)) = 1
        _FurShading ("Fur Shading", Range(0.0, 4)) = 0.25
        _Thinness ("BubbleThinness", Range(0.0, 4)) = 0.25
        _FurShadeStep("ShadeStep",Range(0.01, 256.0)) = 8.0
        _Smooth ("Smooth", Range(0, 0.5)) = 0

       _ForceGlobal ("Force Global", Vector) = (0, 0, 0, 0)
       _ForceLocal ("Force Local", Vector) = (0, 0, 0, 0)

       _bubbleGlobal("bubble Global Direction", Vector) = (0, 0, 0, 0)
       _bubbleLocal("buble local Direction", Vector) = (0, 0, 0, 0)

        //Toon
        // rim light
        _RimColor ("Rim Color", Color) = (0.8, 0.8, 0.8, 0.6)
        _RimPower( "Rim Power", Range( 0.1, 10.0 )) = 3.0
        _RimThreshold ("Rim Threshold", Range(0, 1)) = 0.5
        _RimSmooth ("Rim Smooth", Range(0, 1)) = 0.1

        // specular
        _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
        _SpecSmooth ("Specular Smooth", Range(0, 1)) = 0.1

        _ToonSteps ("Steps of Toon", range(1, 9)) = 2
        _RampThreshold ("Ramp Threshold", Range(0.1, 1)) = 0.5
        _RampSmooth ("Ramp Smooth", Range(0, 1)) = 0.1
        _Magnitude ("Magnitude", Range(0,1)) = 0.05
        [NoScaleOffset] _FlowMap ("Flow (RG, A noise)", 2D) = "black" {}
               
		
        _Tiling ("Tiling", Float) = 1
        _Speed ("Speed", Float) = 1
        _UJump ("U jump per phase", Range(-0.25, 5)) = 0.25
		_VJump ("V jump per phase", Range(-0.25, 5)) = 0.25
        _FlowStrength ("Flow Strength", Float) = 1
        _FlowOffset ("Flow Offset", Float) = 0
        [NoScaleOffset] _NormalMap ("Normals", 2D) = "bump" {}

        _BumpMap("bump Map", 2D) = "bump" {}
    }

    Category
    {

       Tags { "RenderType" = "Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent" }
       Cull Off
       LOD 300
       ZWrite On
       ZTest LEqual
       //AlphaTest LEqual [_Furtex]
       Blend SrcAlpha OneMinusSrcAlpha
       Blend SrcAlpha OneMinusSrcAlpha
       ColorMask RGB
        
        SubShader
        {   
            GrabPass { "_GrabTexture" }

            Pass {
                ColorMask 0
            }

            //  Pass {
            // // Only render pixels with an alpha larger than 50%
            // AlphaTest Greater 0.5
            // SetTexture [_MainTex] { combine texture }
            //  }




            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_surface
                #pragma fragment frag_surface
                #define FURSTEP 0.00
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.05
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.10
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.15
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.20
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.22
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.25
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.27
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.30
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.32
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.35
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.37
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.40
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.42
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.45
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.47
                #include "FurHelper.cginc"
                
                ENDCG
                
            }


            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.48
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.50
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
             Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.53
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.55
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.58
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.60
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
             Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.62
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.65
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.68
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.70
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.73
            //     #include "FurHelper.cginc"
                
            //     ENDCG
            // }
            
            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.75
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.78
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.80
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.83
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.85
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
             
            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.90
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.93
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.95
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base
            //     #pragma fragment frag_base
            //     #define FURSTEP 0.98
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.10
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.15
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.20
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.25
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.30
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.35
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.40
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.45
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.50
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.55
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.60
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.65
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.70
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            //  Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.75
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base2
                #pragma fragment frag_base2
                #define FURSTEP 0.80
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base2
                #pragma fragment frag_base2
                #define FURSTEP 0.85
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.87
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.89
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.90
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }

            // Pass
            // {
            //     CGPROGRAM
                
            //     #pragma vertex vert_base2
            //     #pragma fragment frag_base2
            //     #define FURSTEP 0.92
            //     #include "FurHelper.cginc"
                
            //     ENDCG
                
            // }
            
            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base2
                #pragma fragment frag_base2
                #define FURSTEP 0.95
                #include "FurHelper.cginc"
                
                ENDCG
                
            }
             Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base2
                #pragma fragment frag_base2
                #define FURSTEP 0.97
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

            Pass
            {
                CGPROGRAM
                
                #pragma vertex vert_base2
                #pragma fragment frag_base2
                #define FURSTEP 1.00
                #include "FurHelper.cginc"
                
                ENDCG
                
            }

        }
    }
}