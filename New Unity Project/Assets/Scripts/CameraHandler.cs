using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraHandler : MonoBehaviour
{
    //Ahora esto es un fps, vamo a veh
    public Transform cameraTransform;
    public Transform cameraParent;

    [Tooltip("The distance in the local x-z plane to the target")]
    [SerializeField]
    private float distance = 7.0f;

    [Tooltip("The height we want the camera to be above the target")]
    [SerializeField]
    private float height = 3.0f;

    [Tooltip("Allow the camera to be offseted vertically from the target, for example giving more view of the sceneray and less ground.")]
    [SerializeField]
    private Vector3 centerOffset = Vector3.zero;

    [Tooltip("Set this as false if a component of a prefab being instanciated by Photon Network, and manually call OnStartFollowing() when and if needed.")]
    [SerializeField]
    private bool followOnStart = false;

    [Tooltip("The Smoothing for the camera to follow the target")]
    [SerializeField]
    private float smoothSpeed = 0.125f;
    //Hacer cosas de tooltip y uwus
    public float clampYUp;
    public float clampYDown;

    // cached transform of the target

    // maintain a flag internally to reconnect if target is lost or camera is switched
    public bool isFollowing;

    // Cache for camera offset
    Vector3 cameraOffset = Vector3.zero;

    Vector3 currentRotX;
    Vector3 currentRotY;
    Vector3 initialVector;
    // Start is called before the first frame update
    void Start()
    {
        // Start following the target if wanted.
        if (followOnStart)
        {
            OnStartFollowing();

        }
    }
    public void MoveCamera(float x, float y)
    {
        if (cameraTransform == null && isFollowing)
        {
            OnStartFollowing();
        }

        // only follow is explicitly declared
        if (isFollowing)
        {
            cameraParent.position = this.transform.position + cameraOffset;

            //Nunca cuestiones a Agus, aunque haga negradas 
            Vector3 rotateCameraVector3 = cameraTransform.transform.rotation.eulerAngles;
            Vector3 rotateBodyVector3 = cameraParent.transform.rotation.eulerAngles;
            rotateCameraVector3.x -= y;
            rotateBodyVector3.y += x;

            clampYUp -= y;
            if (clampYUp > 90)
            {
                clampYUp = 90;
                rotateCameraVector3.x = clampYUp;
            }
            else if (clampYUp < -90)
            {
                clampYUp = -90;
                rotateCameraVector3.x = 270;
            }
            cameraTransform.transform.rotation = Quaternion.Euler(rotateCameraVector3);
            cameraParent.transform.rotation = Quaternion.Euler(rotateBodyVector3);

        }
    }

    public void OnStartFollowing()
    {

        isFollowing = true;
        //busco los transform
        cameraParent = GameObject.Find("CameraParent").transform;
        cameraTransform = Camera.main.transform;
        currentRotX = cameraParent.eulerAngles;
        currentRotY = cameraTransform.eulerAngles;
        initialVector = cameraTransform.forward;
        initialVector.x = 0f;
    }



    /// <summary>
    /// Follow the target smoothly
    /// </summary>
    void SetStartPosition()
    {
        cameraOffset.z = -distance;
        cameraOffset.y = height;

        cameraTransform.position = this.transform.position + this.transform.TransformVector(cameraOffset);

        cameraTransform.LookAt(this.transform.position + centerOffset);
        Debug.Log("owowo");
    }

}
