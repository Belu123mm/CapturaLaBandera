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

        Destroy(this.gameObject, secs);

    }

}
