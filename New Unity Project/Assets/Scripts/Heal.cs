using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Heal : MonoBehaviour
{
    public int heal;
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.layer == 9)
        {
            PlayerModel model=collision.gameObject.GetComponent<PlayerModel>();
            Server.Instance.RequestHeal(model,heal);
            gameObject.GetComponent<Destroyer>();
        }
    }
}
