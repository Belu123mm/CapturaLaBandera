using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class Destroyer : MonoBehaviourPun
{
   
    void Start()
    {
        PhotonNetwork.Destroy(gameObject.GetComponent<PhotonView>());
        

    }

}
