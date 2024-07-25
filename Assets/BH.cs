﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class BH : MonoBehaviour
{

    //public settings
    public Shader shader;
    public Transform blackHole;
    public float ratio;
    public float radius;

    //private settings
    Camera cam;
    Material _material;

    Material material
    {
        get {
            if (_material == null)
            {
                _material = new Material(shader);
                _material.hideFlags = HideFlags.HideAndDontSave;
            }
            return _material;
        }
    }

    void OnEnable()
    {
        cam = GetComponent<Camera>();
        ratio = 1f / cam.aspect;
    }

    void OnDisable()
    {
        if (_material)
        {
            DestroyImmediate(_material);
        }
    }

    Vector3 wtsp;
    Vector2 pos;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (shader && material && blackHole)
        {
            wtsp = cam.WorldToScreenPoint(blackHole.position);

            if (wtsp.z > 0)
            {
                pos = new Vector2(wtsp.x / cam.pixelWidth, (wtsp.y / cam.pixelHeight));
                _material.SetVector("_Position", pos);
                _material.SetFloat("_Ratio", ratio);
                _material.SetFloat("_Rad", radius);
                _material.SetFloat("_Distance", Vector3.Distance(blackHole.position, transform.position));

                Graphics.Blit(source, destination, material);
            }
        }
    }
}
