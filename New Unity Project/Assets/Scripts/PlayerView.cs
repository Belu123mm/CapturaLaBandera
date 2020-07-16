using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using Photon.Pun;
using Photon.Realtime;
using Hashtable = ExitGames.Client.Photon.Hashtable;

public class PlayerView : MonoBehaviourPun, IPunObservable
{
    public TMP_Text nameText;
    public TMP_Text timeText;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        
        
    }
    public void SetPlayerName (Player p ) {

        string misticText = (string) p.CustomProperties [ "Name" ];
        nameText.text = misticText;

    }
    public void SetTimerValue(float time ) {
        timeText.text = time.ToString();
    }

    public void OnPhotonSerializeView( PhotonStream stream, PhotonMessageInfo info ) {  //Esto se llama cuando cambia en el server
        if ( stream.IsWriting ) {
            stream.SendNext(nameText.text);
        } else {
            nameText.text = (string) stream.ReceiveNext();
        }
    }
}