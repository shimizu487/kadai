
using UnityEngine;

public class HueController : MonoBehaviour
{
    [SerializeField] private Renderer targetRenderer;
    [SerializeField] private float hueSpeed = 0.5f;

    private Material targetMaterial;
    private float hue = 0.0f;

    void Start()
    {
        if (targetRenderer == null)
        {
            targetRenderer = GetComponent<Renderer>();
        }

        // このオブジェクト専用のマテリアルを取得
        targetMaterial = targetRenderer.material;

        //hue = targetMaterial.GetFloat("_Hue");
    }

    void Update()
    {
        float input = 0.0f;

        // W・Dで色相を進める
        if (Input.GetKey(KeyCode.W) ||
            Input.GetKey(KeyCode.D))
        {
            input += 1.0f;
        }

        // A・Sで色相を戻す
        if (Input.GetKey(KeyCode.A) ||
            Input.GetKey(KeyCode.S))
        {
            input -= 1.0f;
        }

        hue += input * hueSpeed * Time.deltaTime;

        // 0～1の範囲で循環させる
        hue = Mathf.Repeat(hue, 1.0f);

        targetMaterial.SetFloat("_Hue", hue);
    }

    void OnDestroy()
    {
        if (targetMaterial != null)
        {
            Destroy(targetMaterial);
        }
    }
}
