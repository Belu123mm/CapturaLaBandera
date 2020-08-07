using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class Grabeable : MonoBehaviourPun
{
    public bool IsFlag;
    public bool grabed;
    public Collider myCol;
    private Rigidbody rb = null;

    private void Start()
    {
        if (gameObject.GetComponent<Rigidbody>() != null)
        {
            rb = gameObject.GetComponent<Rigidbody>();
        }
    }
    private void Update()
    {
        if (grabed)
        {
            if (rb != null)
            {
                rb.useGravity = false;
                rb.isKinematic = false;
            }
        }
        else
        {
            if (rb != null)
            {
                rb.isKinematic = true;
                rb.useGravity = true;
            }
           
        }
    }
}
