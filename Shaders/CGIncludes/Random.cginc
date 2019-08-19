#ifndef RANTERTOOLS_RANDOM
    #define RANTERTOOLS_RANDOM
    

    //Random functions
    //To 1D

    float Rand1DTo1D(float value, float mutator = 0.546)
    {
        return frac(sin(value + mutator) * 134558.5453);
    }
    float Rand2DTo1D(float2 value, float2 dotDir = float2(13.9898, 87.233))
    {
        return frac(sin(dot(sin(value), dotDir)) * 143758.5453);
    }
    float Rand3DTo1D(float3 value, float3 dotDir = float3(12.9898, 78.233, 37.719))
    {
        return frac(sin(dot(sin(value), dotDir)) * 143758.5453);
    }

    float Rand4DTo1D(float4 value, float4 dotDir = float4(12.9898, 78.233, 37.719, 17.4265))
    {
        return frac(sin( dot( sin(value), dotDir)) * 143758.5453);
    }


    //To 2D
    float2 Rand1DTo2D(float value)
    {
        return float2(Rand1DTo1D(value,-3.9812),Rand1DTo1D(value)*4.2512);
    }
    float2 Rand2DTo2D(float2 value)
    {
        return float2(Rand2DTo1D(value,float2(12.5197,-7.551)),Rand2DTo1D(value,float2(1.2512,-7.1515)));
    }
    float2 Rand3DTo2D(float3 value)
    {
        return float2(Rand3DTo1D(value,float3(12.5197,-7.551,1.284)),
        Rand3DTo1D(value,float3(1.2512,-17.1515,12.254)));
    }

    float2 Rand4DTo2D(float4 value)
    {
        return float2(Rand4DTo1D(value,float4(12.5197,-7.551,1.284,0.1548)),
        Rand4DTo1D(value,float4(1.2512,-7.1515,2.254,11.15158)));
    }

    //To 3D
    float3 Rand1DTo3D(float value)
    {
        return float3(Rand1DTo1D(value,-3.9812),Rand1DTo1D(value)*4.2512,Rand1DTo1D(value)*1.2512);
    }
    float3 Rand2DTo3D(float2 value)
    {
        return float3(Rand2DTo1D(value,float2(12.5197,-7.551)),Rand2DTo1D(value,float2(1.2512,-7.1515)),Rand2DTo1D(value,float2(3.223512,-4.3215)));
    }
    float3 Rand3DTo3D(float3 value, float3 dotDir = float3(12.9898, 78.233, 37.719))
    {
        return float3(Rand3DTo1D(value,float3(12.5197,-7.551,1.284)),
        Rand3DTo1D(value,float3(1.2512,-7.1515,2.254)),
        Rand3DTo1D(value,float3(-3.2512,4.1515,-3.23254)));
    }

    float3 Rand4DTo3D(float4 value)
    {
        return float3(Rand4DTo1D(value,float4(12.5197,-7.551,1.284,0.1548)),
        Rand4DTo1D(value,float4(1.2512,-7.1515,2.254,11.15158)),
        Rand4DTo1D(value,float4(2.2512,-4.1515,1.213654,1.1565158)));
    }
#endif