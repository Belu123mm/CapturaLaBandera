using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class PlayerController : MonoBehaviour
{
    //Controller -> Server -> Server ->Model
    //Variables
    public CameraHandler camHandler;
    private bool _isStarted;

    // Start is called before the first frame update
    void Start() {
       
    }    // Update is called once per frame
    void Update() {
        //Checkeo si es mi view
        if ( !camHandler) return;

        if ( Input.GetButton("Horizontal") ) 
        {
            float X = Input.GetAxis("Horizontal");
            Vector3 camRight = new Vector3(camHandler.cameraTransform.right.x, 0, camHandler.cameraTransform.right.z);
            Vector3 currentDir = new Vector3(camHandler.cameraTransform.forward.x, 0, camHandler.cameraTransform.forward.z);
            Server.Instance.RequestMoveX(PhotonNetwork.LocalPlayer, X,camRight,currentDir);
        }
        if ( Input.GetButton("Vertical") ) {
            float Y = Input.GetAxis("Vertical");
            Vector3 camForward = new Vector3(camHandler.cameraTransform.forward.x, 0, camHandler.cameraTransform.forward.z);
            Server.Instance.RequestMoveY(PhotonNetwork.LocalPlayer, Y,camForward);
        }
        if ( Input.GetButton("Attack") ) {
            //Request to move Attack
            Server.Instance.RequestAttack(PhotonNetwork.LocalPlayer);
        }
        if ( Input.GetButton("Dash") ) {

            Server.Instance.RequestDash(PhotonNetwork.LocalPlayer);

        }
        if ( Input.GetButton("Ability") ) {
            //Request to move Ability

        }
        if ( Input.GetButton("Jump") ) {
            //Request to move Jump

        }
        if ( Input.GetButton("Grab") ) {
            //Request to move Grab
            Server.Instance.RequestGrab(PhotonNetwork.LocalPlayer);
        }
    }
    public void StartPlayer()
    {
        camHandler = gameObject.GetComponent<CameraHandler>();
        Debug.Log("playeriniciado");

        if (camHandler != null)
        {
            camHandler.OnStartFollowing();
        }
    }
}