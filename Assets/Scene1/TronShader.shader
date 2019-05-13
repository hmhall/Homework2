
Shader "Unlit/TronShader"
{
    Properties
    {
        _OutlineEffect ("OutlineEffect", float) = 1
        _EdgeColor("Edge Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }
        
        ZWrite Off
        ZTest Always
        Blend One One

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 viewDir : TEXCOORD1;

            };
            
            float _OutlineEffect;
            float4 _EdgeColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float ndotv = (1 - dot(i.normal, i.viewDir));
                ndotv*=_OutlineEffect;
                return _EdgeColor * ndotv;
            }
            ENDCG
        }
    }
}
