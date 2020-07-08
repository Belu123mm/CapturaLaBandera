using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine.UI;
using TMPro;
using System;

public class Spawner : MonoBehaviourPunCallbacks
{
    private Server _myserver;
    public Animator winScreen;


    void Start()
    {
        if (PhotonNetwork.IsMasterClient)
        {
            _myserver = PhotonNetwork.Instantiate("MyServer", transform.position, transform.rotation).GetComponent<Server>();          
            _myserver.winScreen = winScreen;
  
        }

    }



}
