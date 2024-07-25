using UnityEngine;
using UnityEngine.Serialization;

[ExecuteInEditMode]
public class BlackHole : MonoBehaviour
{
    public Transform hole_object;
    public float rad = 3f;
    public float black_rad_1 = 1f; // radius where black color starts
    public float black_rad_2 = 4f; // radius where black color starts blend with background
    public float ior = 0.38f;

    [FormerlySerializedAs("_material")] public Material material;
    
    void OnEnable()
    {
        if(material == null)
            material = new Material(Shader.Find("BlackHole"));
    }


    // Postprocess
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Vector2 screenPos; // position hole in screen coordinate [0,1]x[0,1]

        float distance;

        if (hole_object != null)
        {
            screenPos = new Vector2(
                GetComponent<Camera>().WorldToScreenPoint(hole_object.position).x / GetComponent<Camera>().pixelWidth,
                1 - GetComponent<Camera>().WorldToScreenPoint(hole_object.position).y / GetComponent<Camera>().pixelHeight);

            distance = Vector3.Distance(hole_object.transform.position, transform.position);
        }
        else
        {
            screenPos = new Vector2(0.5f, 0.5f);
            distance = 10.0f;
        }

        material.SetFloat("_dist", distance);
        material.SetVector("screenPos", screenPos);
        material.SetFloat("IOR", ior);
        material.SetFloat("black_r1", black_rad_1/distance);
        material.SetFloat("black_r2", black_rad_2/distance);
        material.SetFloat("rad", rad);

        Graphics.Blit(source, destination, material);
    }
}