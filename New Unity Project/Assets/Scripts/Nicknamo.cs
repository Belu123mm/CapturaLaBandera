using System.Collections;
using System.Collections.Generic;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
public class Nicknamo : MonoBehaviourPun
{
    public TextMeshProUGUI txt;
    private void Awake()
    {

        if (photonView.IsMine)
        {
            photonView.RPC("SetMyNickName", RpcTarget.AllBuffered);
        }
    }

    [PunRPC]

    private void SetMyNickName()
    {
        txt.text = PhotonNetwork.LocalPlayer.NickName;
    }
}

