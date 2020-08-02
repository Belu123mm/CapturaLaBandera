﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trap : MonoBehaviour
{
    private Animator anim;
    private Grabeable gb;
    
    private bool grabed;
    // Start is called before the first frame update
    void Start()
    {
        gb=gameObject.GetComponent<Grabeable>();
    }

    
    // Update is called once per frame
    void Update()
    {
        if (gb.grabed)
        {
            grabed=true;
        }
        if (!gb.grabed && grabed)//si la suelta y ya fue agarrada una vez se activa
        {
            StartCoroutine(TrapActived());
        }
       
    }
   
    IEnumerator TrapActived()
    {
        yield return new WaitForSeconds(3);
        anim.SetBool("IsOn", true);
        yield return new WaitForSeconds(0.6f);
        DamageDealer dd=gameObject.AddComponent<DamageDealer>();
        dd.dad = this.gameObject;
    }
}