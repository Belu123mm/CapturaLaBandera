using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageDealer : MonoBehaviour
{
    public GameObject dad;
    private bool hit;
    public void OnTriggerEnter(Collider other)
    {
        if (!hit)
        {

            StartCoroutine(HitCD());
            if (other.gameObject.layer == 9 && other.gameObject != dad)
            {
                PlayerModel m = other.gameObject.GetComponent<PlayerModel>();
                Server.Instance.RequestDamage(m, 1);
            }
        }
    }

    private IEnumerator HitCD()
    {
        hit = true;
        yield return new WaitForSeconds(0.5f);
        hit = false;
    }

}
