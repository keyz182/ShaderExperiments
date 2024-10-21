using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Windows;


public class CreateAssetBundles
{
    [MenuItem ("Assets/Build AssetBundles")]
    static void BuildAllAssetBundles ()
    {
        if(!Directory.Exists("Assets/Bundles/StandaloneLinux64")) Directory.CreateDirectory("Assets/Bundles/StandaloneLinux64");
        if(!Directory.Exists("Assets/Bundles/StandaloneOSX")) Directory.CreateDirectory("Assets/Bundles/StandaloneOSX");
        if(!Directory.Exists("Assets/Bundles/StandaloneWindows64")) Directory.CreateDirectory("Assets/Bundles/StandaloneWindows64");
        BuildPipeline.BuildAssetBundles ("Assets/Bundles/StandaloneLinux64", BuildAssetBundleOptions.None, BuildTarget.StandaloneLinux64);
        BuildPipeline.BuildAssetBundles ("Assets/Bundles/StandaloneOSX", BuildAssetBundleOptions.None, BuildTarget.StandaloneOSX);
        BuildPipeline.BuildAssetBundles ("Assets/Bundles/StandaloneWindows64", BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows64);
    }
    
}