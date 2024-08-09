using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;


public class CreateAssetBundles
{
    [MenuItem ("Assets/Build AssetBundles")]
    static void BuildAllAssetBundles ()
    {
        BuildPipeline.BuildAssetBundles ("Assets/Bundles/StandaloneLinux64", BuildAssetBundleOptions.None, BuildTarget.StandaloneLinux64);
        BuildPipeline.BuildAssetBundles ("Assets/Bundles/StandaloneOSX", BuildAssetBundleOptions.None, BuildTarget.StandaloneOSX);
        BuildPipeline.BuildAssetBundles ("Assets/Bundles/StandaloneWindows64", BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows64);
    }
    
}