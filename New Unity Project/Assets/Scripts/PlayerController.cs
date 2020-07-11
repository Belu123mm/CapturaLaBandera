using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

[RequireComponent(typeof(PlayerView))]
public class PlayerController : MonoBehaviour
{
    //Controller -> Server -> Server ->Model
    //Variables

    private bool _isStarted;

    // Start is called before the first frame update
    void Start() {
    }    // Update is called once per frame
    void Update() {
        //Checkeo si es mi view


        if ( !_isStarted ) {
            Server.Instance.RequestStartCamHandler(PhotonNetwork.LocalPlayer);
            _isStarted = true;
            return;
        }

        if ( Input.GetButton("Horizontal") ) 
        {
            float X = Input.GetAxis("Horizontal");
       
            Server.Instance.RequestMoveX(PhotonNetwork.LocalPlayer, X);
        }
        if ( Input.GetButton("Vertical") ) {
            float Y = Input.GetAxis("Vertical");
            Server.Instance.RequestMoveY(PhotonNetwork.LocalPlayer, Y);
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

        }




    }
}