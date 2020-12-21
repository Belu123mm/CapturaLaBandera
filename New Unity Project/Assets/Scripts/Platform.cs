using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class Platform : MonoBehaviourPun
{
    public Transform pos1;
    public Transform pos2;
    Transform current;
    public float speed = 3;

    public float time_stop_platform;
    float timer_stop;
    bool timestop = true;

    // Start is called before the first frame update
    void Start()
    {
        current = pos1;
    }

    // Update is called once per frame
    void Update()
    {

        if (!timestop)
        {
            Vector3 dir = current.transform.position - this.transform.position;
            dir.Normalize();
            this.transform.position += dir * Time.deltaTime * speed;
            if (Vector3.Distance(this.transform.position, current.transform.position) <= 0.2f)
            {
                current = current == pos1 ? pos2 : pos1;
                timestop = true;
                timer_stop = 0;
            }
        }
        else 
        {
            if (timer_stop < time_stop_platform) timer_stop = timer_stop + 1 * Time.deltaTime;
            else { timer_stop = 0; timestop = false; }
        }
    }
}
