using UnityEngine;

[RequireComponent(typeof(Camera))]
[AddComponentMenu("")]
public class SlinImageEffectBase : MonoBehaviour
{
	/// Provides a shader property that is set in the inspector
	/// and a material instantiated from the shader
	public Material material;

	protected void Start ()
	{
		// Disable if we don't support image effects
		if (!SystemInfo.supportsImageEffects)
		{
			enabled = false;
			return;
		}
	}
}
