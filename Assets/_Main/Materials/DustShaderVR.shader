Shader "Custom/DustShaderVR"
{
    Properties
    {
        _MainTex ("Base Texture", 2D) = "white" {} // Das Hauptbild
        _DustTex ("Dust Texture", 2D) = "black" {} // Die Staubtextur
        _DustAmount ("Dust Amount", Range(0, 1)) = 1.0 // Kontrolle für Staub
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha // Ermöglicht Transparenz
            ZWrite Off
            Cull Off // Beide Seiten rendern, wichtig für VR

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc" // Standard Unity-Include für Shader

            sampler2D _MainTex;      // Haupttextur
            sampler2D _DustTex;      // Staubtextur
            float _DustAmount;       // Staubmenge

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID // Für Stereo-Rendering
            };

            v2f vert(appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v); // Initialisiert Instancing
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Lese Haupttextur und Staubtextur
                fixed4 baseColor = tex2D(_MainTex, i.uv);
                fixed4 dustColor = tex2D(_DustTex, i.uv);

                // Reduziere den Einfluss der Staubtextur basierend auf DustAmount
                float dustAlpha = lerp(0, dustColor.a, _DustAmount);

                // Mische die Staubtextur mit der Haupttextur
                baseColor.rgb = lerp(baseColor.rgb, dustColor.rgb, dustAlpha);

                // Behalte die Alpha der Haupttextur (keine Transparenz des Blocks)
                baseColor.a = 1.0;

                return baseColor;
            }
            ENDCG
        }
    }
}
