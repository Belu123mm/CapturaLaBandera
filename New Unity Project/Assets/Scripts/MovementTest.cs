using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovementTest : MonoBehaviour {

    public float movementSpeed;
    public float rotateSpeed;
    bool _isMovingHor;
    bool _isMovingVer;

    // Start is called before the first frame update
    void Start() {

    }

    // Update is called once per frame
    void Update() {
        if (Input.GetButton("Horizontal"))
        MoveHorizontal(Input.GetAxis("Horizontal")* Vector3.right);


        if ( Input.GetButton("Vertical") )
            MoveVertical(Input.GetAxis("Vertical") * Vector3.forward);

    }

    void MoveHorizontal( Vector3 dir ) {

            Vector3 targetDir = (transform.position + dir) - transform.position;

            float step = rotateSpeed * Time.deltaTime;

            Vector3 newDir = Vector3.RotateTowards(transform.forward, targetDir, step, 0.0f);



            transform.rotation = Quaternion.LookRotation(newDir);

            transform.position += dir * movementSpeed * Time.deltaTime;
            Debug.DrawRay(transform.position, newDir, Color.red);

    }
        public void MoveVertical( Vector3 dir ) {

            Vector3 targetDir = (transform.position + dir) - transform.position;

            float step = rotateSpeed * Time.deltaTime;

            Vector3 newDir = Vector3.RotateTowards(transform.forward, targetDir, step, 0.0f);

            transform.rotation = Quaternion.LookRotation(newDir);

            transform.position += dir * movementSpeed * Time.deltaTime;
            Debug.DrawRay(transform.position, newDir, Color.red);


    }
    IEnumerator WaitToMoveHor() {
        yield return new WaitForFixedUpdate();
        _isMovingHor = false;
    }
    IEnumerator WaitToMoveVer() {
        yield return new WaitForFixedUpdate();
        _isMovingVer = false;
    }


}