using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

namespace RanterTools.Render.Editor
{

    /// <summary>
    /// Custom editor for Perlin noise shader
    /// </summary>
    //TODO:
    //reset all parameters after switch dimension or store parameters for each dimension in editor

    public class PerlinNoiseEditor : ShaderGUI
    {
        PerlinNoiseDimension dimension = PerlinNoiseDimension.Perlin1D;
        bool periodic = false;
        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            Material targetMaterial = materialEditor.target as Material;
            MaterialProperty tiling = null, offset = null, period = null, octaves = null, dimensionProperty = null, periodicProperty = null;
            foreach (var p in properties)
            {
                if (p.name == "_Dimension") dimensionProperty = p;
                if (p.name == "_Periodic") periodicProperty = p;
                if (p.name == "_Tiling") tiling = p;
                if (p.name == "_Offset") offset = p;
                if (p.name == "_Period") period = p;
                if (p.name == "_Octaves") octaves = p;
            }


            dimension = (PerlinNoiseDimension)dimensionProperty.floatValue;
            periodic = (periodicProperty.floatValue == 0) ? false : true;
            switch (dimension)
            {
                case PerlinNoiseDimension.Perlin1D:
                    { targetMaterial.DisableKeyword("_DIMENSION_1D"); break; }
                case PerlinNoiseDimension.Perlin2D:
                    { targetMaterial.DisableKeyword("_DIMENSION_2D"); break; }
                case PerlinNoiseDimension.Perlin3D:
                    { targetMaterial.DisableKeyword("_DIMENSION_3D"); break; }
            }
            if (periodic)
            {
                targetMaterial.DisableKeyword("_PERIODIC");
                periodicProperty.floatValue = 1;
            }
            else
            {
                targetMaterial.DisableKeyword("_PERIODIC_NONE");
                periodicProperty.floatValue = 0;
            }


            if (tiling == null || offset == null || period == null || octaves == null)
            {
                Debug.LogWarning("_Tilling,_Offset,_Period or _Octaves property not found in shader " + targetMaterial.shader.name);
                return;
            }

            EditorGUI.BeginChangeCheck();
            periodic = EditorGUILayout.Toggle("Periodic", periodic);
            using (var scope = new EditorGUILayout.HorizontalScope())
            {
                EditorGUILayout.PrefixLabel("Dimension");
                ///Enum dimension perlin noise
                dimension = (PerlinNoiseDimension)EditorGUILayout.EnumPopup(dimension);
            }
            dimensionProperty.floatValue = (float)dimension;
            switch (dimension)
            {
                case PerlinNoiseDimension.Perlin1D:
                    { targetMaterial.EnableKeyword("_DIMENSION_1D"); break; }
                case PerlinNoiseDimension.Perlin2D:
                    { targetMaterial.EnableKeyword("_DIMENSION_2D"); break; }
                case PerlinNoiseDimension.Perlin3D:
                    { targetMaterial.EnableKeyword("_DIMENSION_3D"); break; }
            }
            if (periodic)
            {
                targetMaterial.EnableKeyword("_PERIODIC");
                periodicProperty.floatValue = 1;
            }
            else
            {
                targetMaterial.EnableKeyword("_PERIODIC_NONE");
                periodicProperty.floatValue = 0;
            }


            switch (dimension)
            {
                case PerlinNoiseDimension.Perlin1D:
                    {
                        float x;
                        x = EditorGUILayout.FloatField("Tiling multiplier", tiling.vectorValue.x);
                        tiling.vectorValue = new Vector4(x, tiling.vectorValue.y, tiling.vectorValue.z, tiling.vectorValue.w);
                        x = EditorGUILayout.Slider("Line thickness", tiling.vectorValue.y, 0.001f, 1);
                        tiling.vectorValue = new Vector4(tiling.vectorValue.x, x, tiling.vectorValue.z, tiling.vectorValue.w);
                        x = EditorGUILayout.FloatField("Offset", offset.vectorValue.x);
                        offset.vectorValue = new Vector4(x, offset.vectorValue.y, offset.vectorValue.z, offset.vectorValue.w);
                        if (periodic)
                        {
                            x = EditorGUILayout.IntSlider("Period", (int)period.vectorValue.x, 2, int.MaxValue);
                            period.vectorValue = new Vector4(x, period.vectorValue.y, period.vectorValue.z, period.vectorValue.w);
                        }
                        octaves.floatValue = EditorGUILayout.IntSlider("Octaves", (int)octaves.floatValue, 1, 8);
                        break;
                    }
                case PerlinNoiseDimension.Perlin2D:
                    {
                        Vector2 t;
                        t = EditorGUILayout.Vector2Field("Tiling", new Vector2(tiling.vectorValue.x, tiling.vectorValue.y));
                        tiling.vectorValue = new Vector4(t.x, t.y, tiling.vectorValue.z, tiling.vectorValue.w);
                        t = EditorGUILayout.Vector2Field("Offset", new Vector2(offset.vectorValue.x, offset.vectorValue.y));
                        offset.vectorValue = new Vector4(t.x, t.y, offset.vectorValue.z, offset.vectorValue.w);
                        if (periodic)
                        {
                            t = EditorGUILayout.Vector2IntField("Period", new Vector2Int((int)period.vectorValue.x, (int)period.vectorValue.y));
                            period.vectorValue = new Vector4(Mathf.Clamp(t.x, 2, int.MaxValue), Mathf.Clamp(t.y, 2, int.MaxValue), period.vectorValue.z, period.vectorValue.w);
                        }
                        octaves.floatValue = EditorGUILayout.IntSlider("Octaves", (int)octaves.floatValue, 1, 8);
                        break;
                    }
                case PerlinNoiseDimension.Perlin3D:
                    {
                        Vector3 t;
                        t = EditorGUILayout.Vector3Field("Tiling", new Vector3(tiling.vectorValue.x, tiling.vectorValue.y, tiling.vectorValue.z));
                        tiling.vectorValue = new Vector4(t.x, t.y, t.z, tiling.vectorValue.w);
                        t = EditorGUILayout.Vector3Field("Offset", new Vector3(offset.vectorValue.x, offset.vectorValue.y, offset.vectorValue.z));
                        offset.vectorValue = new Vector4(t.x, t.y, t.z, offset.vectorValue.w);
                        if (periodic)
                        {
                            t = EditorGUILayout.Vector3IntField("Period", new Vector3Int((int)period.vectorValue.x, (int)period.vectorValue.y, (int)period.vectorValue.z));
                            period.vectorValue = new Vector4(Mathf.Clamp(t.x, 2, int.MaxValue), Mathf.Clamp(t.y, 2, int.MaxValue), Mathf.Clamp(t.z, 2, int.MaxValue), period.vectorValue.w);
                        }
                        octaves.floatValue = EditorGUILayout.IntSlider("Octaves", (int)octaves.floatValue, 1, 8);
                        break;
                    }
            }

            if (EditorGUI.EndChangeCheck())
            {
                EditorUtility.SetDirty(targetMaterial);

            }

        }

    }



    public enum PerlinNoiseDimension { Perlin1D, Perlin2D, Perlin3D };

}