using UnityEngine;

public class MissileController : MonoBehaviour
{
    public float thrust = 15f;
    public float rotateSpeed = 90f;
    public Transform target;

    private Rigidbody rb;
    private Vector3 previousTargetPosition;
    private Vector3 moveDirection;

    void Start()
    {
        rb = GetComponent<Rigidbody>();

        // ミサイルの初期位置と初期回転
        transform.position = new Vector3(4.523276f, 1.98f, 10.17f);
        transform.rotation = Quaternion.Euler(0f, 90f, 0f);
        transform.localScale = new Vector3(0.5f, 0.5f, 0.5f);

        // 初期方向をミサイル自身の正面に設定
        moveDirection = transform.forward.normalized;

        if (target != null)
        {
            previousTargetPosition = target.position;
        }

    }

    void Update()
    {
        float h = Input.GetAxisRaw("Horizontal");

        // A・Dキーの回転方向を逆にする
        float angle = -h * rotateSpeed * Time.deltaTime;

        // 水平方向のみ、見た目の向きを変更
        transform.Rotate(Vector3.up, angle, Space.World);
    }

    void FixedUpdate()
    {
        if (target == null) return;

        // Unityちゃんの移動量を取得
        Vector3 targetMovement =
            target.position - previousTargetPosition;

        previousTargetPosition = target.position;

        targetMovement.y = 0f;

        // Unityちゃんが移動したときだけミサイルを前進させる
        if (targetMovement.sqrMagnitude > 0.0001f)
        {
            // ワールド座標からミサイルのローカル座標へ変換
            Vector3 localDirection =
                transform.worldToLocalMatrix.MultiplyVector(
                    targetMovement.normalized
                );

            // ローカル座標からワールド座標へ変換
            Vector3 worldDirection =
                transform.localToWorldMatrix.MultiplyVector(
                    localDirection
                );

            worldDirection.y = 0f;

            if (worldDirection.sqrMagnitude > 0f)
            {
                moveDirection = worldDirection.normalized;

                // Unityちゃんの移動時だけ速度を設定
                rb.linearVelocity = moveDirection * thrust;
            }
        }
        else
        {
            // Unityちゃんが止まったらミサイルも止める
            rb.linearVelocity = Vector3.zero;
        }
    }
}