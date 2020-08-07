using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class Destroyer : MonoBehaviourPun
{
    public float secs;
    // Start is called before the first frame update
    void Start()
    {
        if ( PhotonNetwork.IsMasterClient ) {
            Destroy(this.gameObject, secs);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
