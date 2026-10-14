using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    // 対象となるプレイヤー（Cube）
    public Transform target;

    // カメラの相対位置（Yが高さ、Zが後ろ）
    public Vector3 offset = new Vector3(0f, 3f, -5f);
    public Vector3 rotate = new Vector3(-4f, 0f, 0f);

    void LateUpdate()
    {
        if (target == null) return;

        // プレイヤーの位置にオフセットを加えてカメラ位置を決定
        transform.position = target.position + offset;

        // 常にプレイヤーの方向を向く
        //transform.LookAt(target);
        transform.rotation = Quaternion.Euler(rotate);
    }
    void Start()
    {
        // Vector3の「オイラー角」をQuaternionに変換して代入
        transform.rotation = Quaternion.Euler(rotate);
    }
}