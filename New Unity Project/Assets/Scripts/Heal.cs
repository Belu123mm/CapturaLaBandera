using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
public class Heal : MonoBehaviourPun
{
    public int heal;
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.layer == 9)
        {
            PlayerModel model=collision.gameObject.GetComponent<PlayerModel>();
            Server.Instance.RequestHeal(model,heal,this);

        }
    }
    public void DestroyTime() {
        photonView.RPC("DestroyMe", RpcTarget.All);
    }
    [PunRPC]
    void DestroyMe() {
        Destroy(this.gameObject);
    }

}
