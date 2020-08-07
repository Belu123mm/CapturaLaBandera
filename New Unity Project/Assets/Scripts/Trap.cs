using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class Trap : MonoBehaviourPun
{
    private Animator anim;
    public Grabeable gb;

    private bool grabed;
    private bool actived;
    // Start is called before the first frame update
    void Start()
    {
        anim = gameObject.GetComponent<Animator>();
        gb = gameObject.GetComponent<Grabeable>();
    }


    // Update is called once per frame
    void Update()
    {
        if (!actived)
        {
            if (gb.grabed)
            {
                grabed = true;
            }
            if (!gb.grabed && grabed)//si la suelta y ya fue agarrada una vez se activa
            {
                Server.Instance.RequestTrap(this);
                Debug.Log("trampa activada");
                actived = true;
            }


        }
    }

    public void StartTrap()
    {
        StartCoroutine(TrapActived());

    }
    IEnumerator TrapActived()
    {
        yield return new WaitForSeconds(3);
        anim.SetBool("IsOn", true);
        yield return new WaitForSeconds(0.6f);
        DamageDealer dd = gameObject.AddComponent<DamageDealer>();     
        dd.dad = this.gameObject;
    }
}
