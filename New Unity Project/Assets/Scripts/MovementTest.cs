using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovementTest : MonoBehaviour {

    public float movementSpeed;
    public float rotateSpeed;
    bool _isMovingHor;
    bool _isMovingVer;

    CameraHandler camHandler;


    // Start is called before the first frame update
    void Start() {
        camHandler = gameObject.GetComponent<CameraHandler>();

    }

    // Update is called once per frame
    void Update() {
        if ( Input.GetButton("Horizontal") )
            MoveHorizontal(Input.GetAxis("Horizontal"));


        if ( Input.GetButton("Vertical") )
            MoveVertical(Input.GetAxis("Vertical"));

    }

    void MoveHorizontal( float dir ) {

        Vector3 camRight = new Vector3(camHandler.cameraTransform.right.x, 0, camHandler.cameraTransform.right.z);
        Debug.Log(camRight);

        Vector3 currentDir = new Vector3(camHandler.cameraTransform.forward.x, 0, camHandler.cameraTransform.forward.z);
        Vector3 targetDir = (transform.position + camRight);

        Debug.DrawLine(currentDir, (targetDir), Color.red);

        float step = rotateSpeed * dir * Time.deltaTime;

        Vector3 newDir = Vector3.RotateTowards(currentDir, camRight, step, 0.0f);

        transform.rotation = Quaternion.LookRotation(newDir);

    }
    public void MoveVertical( float dir ) {

        Vector3 camForward = new Vector3(camHandler.cameraTransform.forward.x , 0 , camHandler.cameraTransform.forward.z );
        Debug.Log(camForward);

        Vector3 targetDir = (transform.position + camForward);

        transform.position += Time.deltaTime * camForward * dir * movementSpeed ;

        Debug.DrawLine(transform.position, (targetDir) , Color.green);
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