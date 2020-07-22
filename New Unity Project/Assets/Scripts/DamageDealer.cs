using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageDealer : MonoBehaviour
{
    public LayerMask penguinMask;
    public void OnCollisionEnter( Collision collision ) {
        if (collision.gameObject.layer == penguinMask ) {
            PlayerModel m = collision.gameObject.GetComponent<PlayerModel>();
            Server.Instance.RequestDamage(m, 1);
        }
    }
}
