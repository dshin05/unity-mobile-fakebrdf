using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("Image Effects/Image Refraction")]
public class ImageRefractionEffect : SlinImageEffectBase
{
	// Called by camera to apply image effect
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		ImageEffects.BlitWithMaterial(material, source, destination);
	}
}
