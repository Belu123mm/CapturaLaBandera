using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

[RequireComponent(typeof(PlayerView))]
public class PlayerController : MonoBehaviourPun {
    //Controller -> Server -> Server ->Model
    //Variables



    // Start is called before the first frame update
    void Start() {

    }

    // Update is called once per frame
    void Update() {
        //Checkeo si es mi view
        if ( photonView.IsMine == false )
            return;

        if ( Input.GetButton("Horizontal") ) 
        {
            float X = Input.GetAxis("Horizontal");
            Server.Instance.RequestMoveX(photonView.Owner, X);
        }
        if ( Input.GetButton("Vertical") ) {
            float Y = Input.GetAxis("Vertical");
            Server.Instance.RequestMoveY(photonView.Owner, Y);
        }
        if ( Input.GetButton("Attack") ) {
            //Request to move Attack
            Server.Instance.RequestAttack(photonView.Owner);
        }
        if ( Input.GetButton("Dash") ) {

            Server.Instance.RequestDash(photonView.Owner);

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