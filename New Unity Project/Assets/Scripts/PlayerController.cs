using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

[RequireComponent(typeof(CameraHandler))]
public class PlayerController : MonoBehaviour
{
    bool _horHasStopped;
    bool _verHasStopped;
    bool _animxHastStopped;
    bool _animyHastStopped;
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


        if ( Input.GetButton("Horizontal") ) {
            _horHasStopped = false;
            _animxHastStopped = false;
            float X = Input.GetAxis("Horizontal");
            Vector3 camRight = new Vector3(camHandler.cameraTransform.right.x, 0, camHandler.cameraTransform.right.z);
            Vector3 currentDir = new Vector3(camHandler.cameraTransform.forward.x, 0, camHandler.cameraTransform.forward.z);
            Server.Instance.RequestMoveX(PhotonNetwork.LocalPlayer, X, camRight, currentDir);
        } else {
            _horHasStopped = true;
        }
        if ( Input.GetButton("Vertical") ) {
            _verHasStopped = false;
            _animyHastStopped = false;
            float Y = Input.GetAxis("Vertical");
            Vector3 camForward = new Vector3(camHandler.cameraTransform.forward.x, 0, camHandler.cameraTransform.forward.z);
            Server.Instance.RequestMoveY(PhotonNetwork.LocalPlayer, Y, camForward);
            Server.Instance.RequestMoveY(PhotonNetwork.LocalPlayer, Y, camForward);
        } else {
            _verHasStopped = true;
        }
        if ( Input.GetButton("Attack") ) {
            //Request to move Attack
            Server.Instance.RequestAttack(PhotonNetwork.LocalPlayer);
        }
        if ( Input.GetButton("Dash") ) {

            Server.Instance.RequestDash(PhotonNetwork.LocalPlayer);

        }
        if ( Input.GetButton("Ability") ) {
            Server.Instance.RequestAbility(PhotonNetwork.LocalPlayer);         
        }
        if ( Input.GetButton("Jump") ) {
            //Request to move Jump

        }
        if ( Input.GetButton("Grab") ) {
            //Request to move Grab
            Server.Instance.RequestGrab(PhotonNetwork.LocalPlayer);
        }
        if ( _verHasStopped ) {
            if ( _animyHastStopped == false ) {
                Server.Instance.PlayerRequestToStopY(PhotonNetwork.LocalPlayer);
                _animyHastStopped = true;
            }
        }
        if ( _horHasStopped ) {
            if ( _animxHastStopped == false ) {
                Server.Instance.PlayerRequestToStopX(PhotonNetwork.LocalPlayer);
                _animxHastStopped = true;
            }
        }
    }
    public void StartPlayer()
    {
        camHandler = gameObject.GetComponent<CameraHandler>();
        Debug.Log("playeriniciado");

        if (camHandler != null)
        {
            camHandler.OnStartFollowing();
            Server.Instance.RequestStartModel(PhotonNetwork.LocalPlayer);
        }
    }
}