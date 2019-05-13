Shader "Custom/Heightmap"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DisplacementAmt ("Displacement", Float) = 1.0
        _DeformationType ("Deformation Type", Int) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
        
           // Tags { "LightMode" = "ForwardAdd" }
            
            Cull off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"
            
            uniform float4 _LightColor0;
            uniform float _DisplacementAmt;

            

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 vertexInWorldCoords : TEXCOORD1;
                float heightVal : TEXCOORD2;
            };
            
            sampler2D _MainTex;
            int _DeformationType;

            v2f vert (appdata v)
            {
                v2f o;
                
                float3 hmVal = tex2Dlod(_MainTex, float4(v.uv, 0, 0)).rgb;
                
                float vDisplace;
                if(_DeformationType==0)
                    vDisplace = hmVal.r * _DisplacementAmt;
                else if(_DeformationType==1) 
                    vDisplace = hmVal.g * _DisplacementAmt;
                else
                    vDisplace = hmVal.b * _DisplacementAmt;
                    
                float4 newPosition = float4((v.vertex.xyz + v.normal.xyz * vDisplace).xyz, 1.0);
                
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, newPosition); //Vertex position in WORLD coords
                o.normal = UnityObjectToWorldNormal(v.normal); //Normal vector in WORLD coords 
                o.vertex = UnityObjectToClipPos(newPosition); 
                o.uv = v.uv;
                o.heightVal = newPosition.y;

                return o;
                
            }
            
            
            
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
