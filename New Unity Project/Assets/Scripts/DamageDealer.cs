using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageDealer : MonoBehaviour
{
    public GameObject dad;
    private bool hit;


    public void OnTriggerExit(Collider other)
    {
        if (!hit)
        {
            if (other.gameObject.layer == 9 && other.gameObject != dad)
            {
               // StartCoroutine(HitCD());
                PlayerModel m = other.gameObject.GetComponent<PlayerModel>();
                Server.Instance.RequestDamage(m, 1);
            }
        }
    }

 
    private IEnumerator HitCD()
    {
        hit = true;
        yield return new WaitForSeconds(1);
        hit = false;
    }

}
