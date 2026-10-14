using UnityEngine;

public class UnityChanController : MonoBehaviour
{
    private Rigidbody rb;
    private Animator animator;

    public float moveSpeed = 20f;
    public float jumpForce = 7f;
    //private bool isGrounded = true;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        animator = GetComponent<Animator>();
    }

    void Update()
    {
        float h = Input.GetAxis("Horizontal");
        //float v = Input.GetAxis("Vertical");

        //Vector3 move = new Vector3(h, 0, v) * moveSpeed * Time.deltaTime;
        Vector3 move = new Vector3(h, 0) * moveSpeed * Time.deltaTime;
        rb.MovePosition(transform.position + move);

        if (move != Vector3.zero)
        {
            Quaternion toRotation = Quaternion.LookRotation(move, Vector3.up);
            transform.rotation = Quaternion.RotateTowards(transform.rotation, toRotation, 720 * Time.deltaTime);
        }

        // Animatorにスピード値を渡す
        //float speed = new Vector3(h, 0, v).magnitude;
        float speed = new Vector3(h, 0).magnitude;
        animator.SetFloat("Speed", speed);

        //if (Input.GetKeyDown(KeyCode.Space) && isGrounded)
        //{
        //    rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
        //    isGrounded = false;

        //    animator.SetBool("Jump", true);  // ← 再生トリガー
        //}
    }

    private void OnCollisionEnter(Collision collision)
    {
        //if (collision.gameObject.CompareTag("Ground"))
        //{
        //    isGrounded = true;
        //    animator.SetBool("Jump", false);  // ← 戻さないと「ジャンプしっぱなし」になる
        //}
    }
}