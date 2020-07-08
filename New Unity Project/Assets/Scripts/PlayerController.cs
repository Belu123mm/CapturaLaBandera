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

        if ( Input.GetButton("Horizontal") ) {
            //Request to move horizontal

        }
        if ( Input.GetButton("Vertical") ) {
            //Request to move vertical

        }
        if ( Input.GetButton("Attack") ) {
            //Request to move Attack

        }
        if ( Input.GetButton("Dash") ) {
            //Request to move Dash

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