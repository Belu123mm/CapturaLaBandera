using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeadZone : MonoBehaviour
{
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.GetComponent<PlayerModel>() != null)
        {
            PlayerModel gb = collision.gameObject.GetComponent<PlayerModel>();
            Server.Instance.RequestDamage(gb, 3);
        }

    }
}
