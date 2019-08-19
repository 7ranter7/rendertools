#ifndef RANTERTOOLS_NOISES
    #define RANTERTOOLS_NOISES

    #include "./Random.cginc"
    #define PERIOD defined(_PERIOD):float
    

    //Quintic smooth curve
    float QuinticCurve(float t)
    {
        return t*t*t*(t*(t*6-15)+10);
    }

    //Cubic Hermine smooth curve.
    float CubicHermine(float t)
    {
        return t*t*(3.0-2.0*t);
    }

    

    ///////Perlin noises//////

    //Perlin noise for 1D variant
    float PerlinNoise1DBase(float n,int minimum,int maximum)
    {
        //Local position point in the cell
        float local=n-floor(n);

        //Calculate random gradient for each corner
        float left=2*Rand1DTo1D(minimum)-1;
        float right=2*Rand1DTo1D(maximum)-1;
        

        //Calculate direction to the point from each coner
        float fromLeft=local;
        float fromRight=local-1;
        

        //Dots for gradients and direction to the point
        float tx1=left*fromLeft;
        float tx2=right*fromRight;

        //Curve parameter for smooth
        float localT=QuinticCurve(local);
        
        //Inqterpolation results
        return lerp(tx1,tx2,localT);
    }
    float PerlinNoise1D(float n)
    {
        return PerlinNoise1DBase(n,floor(n),ceil(n));
    }

    float PerlinNoise1DPeriod(float n,int period)
    {
        period=max(2,period);
        return PerlinNoise1DBase(n,floor(n)%period,ceil(n)%period);
    }

    float MultiOctavePerlinNoise1D(float v, int octaves, float persistence = 0.5f)
    {
        float amplitude = 2;
        float summ = 0;
        float result = 0;
        while (octaves-- > 0)
        {
            summ += amplitude;
            result += PerlinNoise1DBase(v,floor(v),ceil(v)) * amplitude;
            amplitude *= persistence;
            v *= 2;
        }
        return result/summ;
    }
    float MultiOctavePerlinNoise1DPeriod(float v, int octaves,int period, float persistence = 0.5f)
    {
        period=max(2,period);
        float amplitude = 2;
        float summ = 0;
        float result = 0;
        while (octaves-- > 0)
        {
            summ += amplitude;
            result += PerlinNoise1DBase(v,floor(v)%period,ceil(v)%period) * amplitude;
            amplitude *= persistence;
            v *= 2;
        }
        return result/summ;
    }

    //Perlin noise for 2D variant
    float PerlinNoise2DBase(float2 n,int2 minimum, int2 maximum)
    {
        //Local position point in the cell
        float2 local=n-floor(n);
        
        //Calculate random gradient for each corner
        float2 topLeft=2*Rand2DTo2D(minimum)-1;
        float2 topRight=2*Rand2DTo2D(float2(maximum.x,minimum.y))-1;
        float2 bottomLeft=2*Rand2DTo2D(float2(minimum.x,maximum.y))-1;
        float2 bottomRight=2*Rand2DTo2D(maximum)-1;

        //Calculate direction to the point from each coner
        float2 fromTopLeft=float2(local);
        float2 fromTopRight=float2(local-float2(1,0));
        float2 fromBottomLeft=float2(local-float2(0,1));
        float2 fromBottomRight=float2(local-float2(1,1));

        //Dots for gradients and direction to the point
        float tx1=dot(topLeft,fromTopLeft);
        float tx2=dot(topRight,fromTopRight);
        float bx1=dot(bottomLeft,fromBottomLeft);
        float bx2=dot(bottomRight,fromBottomRight);

        //Curve parameter for smooth
        float localXT=QuinticCurve(local.x);
        float localYT=QuinticCurve(local.y);
        
        //Interpolation results
        float tx=lerp(tx1,tx2,localXT);
        float bx=lerp(bx1,bx2,localXT);
        return lerp(tx,bx,localYT);
    }

    float PerlinNoise2D(float2 n)
    {
        return PerlinNoise2DBase(n,floor(n),ceil(n));
    }

    float PerlinNoise2DPeriod(float2 n,int2 period)
    {
        period=max(2,period);
        return PerlinNoise2DBase(n,floor(n)%period,ceil(n)%period);
    }

    //Multi octave realization
    float MultiOctavePerlinNoise2D(float2 v, int octaves, float persistence = 0.5f)
    {
        float amplitude = 2;
        float summ = 0;
        float result = 0;
        while (octaves-- > 0)
        {
            summ += amplitude;
            result += PerlinNoise2DBase(v,floor(v),ceil(v)) * amplitude;
            amplitude *= persistence;
            v *= 2;
        }
        return result/summ;
    }
    float MultiOctavePerlinNoise2DPeriod(float2 v, int octaves,int2 period, float persistence = 0.5f)
    {
        period=max(2,period);
        float amplitude = 2;
        float summ = 0;
        float result = 0;
        while (octaves-- > 0)
        {
            summ += amplitude;
            result += PerlinNoise2DBase(v,floor(v)%period,ceil(v)%period) * amplitude;
            amplitude *= persistence;
            v *= 2;
        }
        return result/summ;
    }

    //Perlin noise for 2D variant
    float PerlinNoise3DBase(float3 n,int3 minimum,int3 maximum)
    {    
        //Local position point in the cell
        float3 local=n-floor(n);
        
        //Calculate random gradient for each corner
        float3 farTopLeft=2*Rand3DTo3D(minimum)-1;
        float3 farTopRight=2*Rand3DTo3D(float3(maximum.x,minimum.y,minimum.z))-1;
        float3 farBottomLeft=2*Rand3DTo3D(float3(minimum.x,maximum.y,minimum.z))-1;
        float3 farBottomRight=2*Rand3DTo3D(float3(maximum.x,maximum.y,minimum.z))-1;
        float3 nearTopLeft=2*Rand3DTo3D(float3(minimum.x,minimum.y,maximum.z))-1;
        float3 nearTopRight=2*Rand3DTo3D(float3(maximum.x,minimum.y,maximum.z))-1;
        float3 nearBottomLeft=2*Rand3DTo3D(float3(minimum.x,maximum.y,maximum.z))-1;
        float3 nearBottomRight=2*Rand3DTo3D(float3(maximum))-1;

        //Calculate direction to the point from each coner
        float3 fromFarTopLeft=float3(local);
        float3 fromFarTopRight=float3(local-float3(1,0,0));
        float3 fromFarBottomLeft=float3(local-float3(0,1,0));
        float3 fromFarBottomRight=float3(local-float3(1,1,0));
        float3 fromNearTopLeft=float3(local-float3(0,0,1));
        float3 fromNearTopRight=float3(local-float3(1,0,1));
        float3 fromNearBottomLeft=float3(local-float3(0,1,1));
        float3 fromNearBottomRight=float3(local-float3(1,1,1));

        //Dots for gradients and direction to the point
        float ftx1=dot(farTopLeft,fromFarTopLeft);
        float ftx2=dot(farTopRight,fromFarTopRight);
        float fbx1=dot(farBottomLeft,fromFarBottomLeft);
        float fbx2=dot(farBottomRight,fromFarBottomRight);
        float ntx1=dot(nearTopLeft,fromNearTopLeft);
        float ntx2=dot(nearTopRight,fromNearTopRight);
        float nbx1=dot(nearBottomLeft,fromNearBottomLeft);
        float nbx2=dot(nearBottomRight,fromNearBottomRight);

        //Curve parameter for smooth
        float localXT=QuinticCurve(local.x);
        float localYT=QuinticCurve(local.y);
        float localZT=QuinticCurve(local.z);
        
        //Interpolation results
        float ftx=lerp(ftx1,ftx2,localXT);
        float fbx=lerp(fbx1,fbx2,localXT);

        float ntx=lerp(ntx1,ntx2,localXT);
        float nbx=lerp(nbx1,nbx2,localXT);

        float fy=lerp(ftx,fbx,localYT);
        float ny=lerp(ntx,nbx,localYT);
        return lerp(fy,ny,localZT);
    }
    float PerlinNoise3D(float3 n)
    {  
        return  PerlinNoise3DBase(n,floor(n),ceil(n));
    }
    float PerlinNoise3DPeriod(float3 n,int3 period)
    {  
        period=max(2,period);
        return  PerlinNoise3DBase(n,floor(n)%period,ceil(n)%period);
    }
    //Multi octave realization
    float MultiOctavePerlinNoise3D(float3 v, int octaves, float persistence = 0.5f)
    {
        float amplitude = 2;
        float summ = 0;
        float result = 0;
        while (octaves-- > 0)
        {
            summ += amplitude;
            result += PerlinNoise3DBase(v,floor(v),ceil(v)) * amplitude;
            amplitude *= persistence;
            v *= 2;
        }
        return result/summ;
    }
    float MultiOctavePerlinNoise3DPeriod(float3 v, int octaves,int3 period, float persistence = 0.5f)
    {
        period=max(2,period);
        float amplitude = 2;
        float summ = 0;
        float result = 0;
        while (octaves-- > 0)
        {
            summ += amplitude;
            result += PerlinNoise3DBase(v,floor(v)%period,ceil(v)%period) * amplitude;
            amplitude *= persistence;
            v *= 2;
        }
        return result/summ;
    }

#endif