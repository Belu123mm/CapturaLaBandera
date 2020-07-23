using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageDealer : MonoBehaviour
{
    public GameObject dad;    
  
    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == 9 &&other.gameObject!=dad) {
            PlayerModel m = other.gameObject.GetComponent<PlayerModel>();
            Server.Instance.RequestDamage(m, 1);
        }
    }
  
   
}
