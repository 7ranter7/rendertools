Shader "RenterShaders/Noises/Perlin"
{
    Properties
    {
        _Dimension("Dimension",Float)=0
        _Periodic("Periodic",Float)=0
        _Tiling("Tiling",Vector)=(1,1,1,1)
        _Offset("Offset",Vector)=(0,0,0,0)
        _Period("Period",Vector)=(1,1,1,1)
        _Octaves("Octaves",Int)=1
    }
    CustomEditor "RanterTools.Render.Editor.PerlinNoiseEditor"
    SubShader
    {
        Pass
        {
            Name "Perlin"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "./CGIncludes/Noises.cginc"
            #pragma multi_compile _DIMENSION_1D _DIMENSION_2D _DIMENSION_3D 
            #pragma multi_compile _PERIODIC _PERIODIC_NONE
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            float4  _Tiling;
            float4 _Period;
            float4 _Offset;
            int _Octaves;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col=1;
                float p=1;
                #if defined(_DIMENSION_1D)
                    #if defined(_PERIODIC)
                        p=0.5*MultiOctavePerlinNoise1DPeriod(i.uv.x*_Tiling.x+_Offset.x,_Octaves,_Period.x)+0.5;
                    #else
                        p=0.5*MultiOctavePerlinNoise1D(i.uv.x*_Tiling.x+_Offset.x,_Octaves)+0.5;
                    #endif
                    if(abs(p-i.uv.y)<=_Tiling.y)p=lerp(1,0,QuinticCurve(abs(p-i.uv.y)/_Tiling.y));
                    else p=0;
                #elif defined(_DIMENSION_2D)
                    #if defined(_PERIODIC)
                        p=MultiOctavePerlinNoise2DPeriod(i.uv*_Tiling.xy+_Offset.xy,_Octaves,_Period.xy);
                    #else
                        p=MultiOctavePerlinNoise2D(i.uv*_Tiling.xy+_Offset.xy,_Octaves);
                    #endif
                #elif defined(_DIMENSION_3D)
                    #if defined(_PERIODIC)
                        float3 coord=float3(i.uv.x,i.uv.y,_Time.y);
                        p=MultiOctavePerlinNoise3DPeriod(coord*_Tiling.xyz+_Offset.xyz,_Octaves,_Period.xyz);
                    #else
                        float3 coord=float3(i.uv.x,i.uv.y,_Time.y);
                        p=MultiOctavePerlinNoise3D(coord*_Tiling.xyz+_Offset.xyz,_Octaves);
                    #endif
                #endif
                col.rgb=0.5*p+0.5;
                return col;
            }
            ENDCG
        }
    }
}
