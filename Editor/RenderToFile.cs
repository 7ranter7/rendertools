using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using RanterTools.Base;
using System.IO;
using UnityEngine.Experimental.Rendering;

namespace RanterTools.Render
{
    /// <summary>
    /// Window for render material in your texture on the disk.
    /// </summary>
    public class RenderToFile : EditorWindow
    {

        #region Global State
        /// <summary>
        /// Instance of renderToFile window
        /// </summary>
        static RenderToFile window;
        #endregion Global State


        #region State   



        #endregion State

        #region Parameters
        /// <summary>
        /// Material for render in texture.
        /// </summary>
        static Material materialForRender;
        /// <summary>
        /// Temporary render texture for render.
        /// </summary>
        static RenderTexture renderTexture;

        /// <summary>
        /// Output file path for texture. 
        /// </summary>
        /// <returns>Output file path for texture.</returns>
        static string outputFilePath = Path.Combine(Application.dataPath, "output.png");
        /// <summary>
        /// Output texture size.
        /// </summary>
        /// <returns> Output texture size.</returns>
        static Vector2Int textureSize = new Vector2Int(1024, 1024);
        /// <summary>
        /// Format for render texture.
        /// </summary>
        static GraphicsFormat format = GraphicsFormat.R8G8B8A8_UInt;

        #endregion Parameters


        #region Unity


        /// <summary>
        /// Create renderToFile window or show if it already exists.
        /// </summary>
        [MenuItem(GlobalNames.MenuRanterTools + "/" + GlobalNames.MenuRendering + "/" + GlobalNames.MenuRenderMaterialToFile)]
        static void Init()
        {
            if (window == null)
            {
                window = (RenderToFile)EditorWindow.GetWindow(typeof(RenderToFile), false, "Render to texture", true);
            }
            window.Show();
        }

        /// <summary>
        /// Unity Method call every time, when window need update graphics.
        /// </summary>
        void OnGUI()
        {
            GUIContent shaderLabel = new GUIContent("Render to file");
            EditorGUILayout.LabelField(shaderLabel);

            shaderLabel = new GUIContent("Shader");
            materialForRender = (Material)EditorGUILayout.ObjectField(shaderLabel, materialForRender, typeof(Material), false);
            format = (GraphicsFormat)EditorGUILayout.EnumPopup(format);
            using (var scope = new EditorGUILayout.HorizontalScope())
            {
                shaderLabel = new GUIContent("Output file");
                outputFilePath = EditorGUILayout.TextField(shaderLabel, outputFilePath);
                shaderLabel = new GUIContent("Choose file path");
                if (GUILayout.Button(shaderLabel))
                {
                    outputFilePath = EditorUtility.SaveFilePanel("Chose file path for output of render.", EditorApplication.applicationPath, "output", "png");
                }
            }
            shaderLabel = new GUIContent("Texture size");
            textureSize = EditorGUILayout.Vector2IntField(shaderLabel, textureSize);
            shaderLabel = new GUIContent("Bake");
            if (GUILayout.Button(shaderLabel))
            {
                BakeTexture();
            }
        }

        #endregion Unity

        #region Methods
        /// <summary>
        /// Bake texture use render material and save it on disk.
        /// </summary>
        void BakeTexture()
        {
            if (materialForRender == null)
            {
                Debug.LogWarning("Not set material for render. Please set it.");
                return;
            }
            if (textureSize.x <= 0 || textureSize.y <= 0)
            {
                Debug.LogWarning("One or both texture size is zero or less. Please set positive numbers.");
                return;
            }

            RenderTexture current = RenderTexture.active;
            renderTexture = RenderTexture.GetTemporary(textureSize.x, textureSize.y);
            Graphics.Blit(null, renderTexture, materialForRender);
            Texture2D texture = new Texture2D(textureSize.x, textureSize.y);
            RenderTexture.active = renderTexture;
            texture.ReadPixels(new Rect(Vector2.zero, textureSize), 0, 0);
            texture.Apply();
            try
            {
                File.WriteAllBytes(outputFilePath, texture.EncodeToPNG());
            }
            catch
            {
                Debug.LogWarning("Can't save texture in file: " + outputFilePath);
            }
            RenderTexture.active = current;
        }
        #endregion Methods
    }
}