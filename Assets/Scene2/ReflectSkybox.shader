Shader "Custom/ReflectSkybox"
{
    Properties
    {
        _Cube ("Cubemap", CUBE) = "" {}
        _Opacity ("Opacity", float) = 0.5
    }
    SubShader
    {
        
        Tags {"Queue"="Transparent" "RenderType"="Transparent" }
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normalInWorldCoords : NORMAL;
                float3 vertexInWorldCoords : TEXCOORD1;
            };


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex);
                o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); 
                
                return o;
            }
            
            samplerCUBE _Cube;
            float _Opacity;

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float3 P = i.vertexInWorldCoords.xyz;
                
                float3 vIncident = normalize(P - _WorldSpaceCameraPos);
                
                float3 vReflect = reflect( vIncident, i.normalInWorldCoords );
                
                float4 reflectColor = texCUBE( _Cube, vReflect );
                
                return float4(reflectColor.rgb, _Opacity);
            }
            ENDCG
        }
    }
}
