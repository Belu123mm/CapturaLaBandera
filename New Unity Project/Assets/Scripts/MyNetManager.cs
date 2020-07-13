using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine.UI;

public class MyNetManager : MonoBehaviourPunCallbacks
{
    public InputField txt;
    public Button connectButton;

    private void Awake()
    {
        txt.text = PlayerPrefs.GetString("name");
        if (txt.text == "")
        {
            connectButton.interactable = false;

        }
        else { connectButton.interactable = true; }
        PhotonNetwork.AutomaticallySyncScene = true;

    }



    public void MyConnect()
    {
        connectButton.interactable = false;
        PhotonNetwork.ConnectUsingSettings();
    }
    public void RegisterName(string name)
    {

        PlayerPrefs.SetString("name", name);
        if (name == "")
        {
            connectButton.interactable = false;
        }
        else
        {
            connectButton.interactable = true;
            PhotonNetwork.NickName = name;
        }
    }

    public override void OnConnectedToMaster()
    {
        RoomOptions options = new RoomOptions();
        options.MaxPlayers = 5;
        PhotonNetwork.JoinOrCreateRoom("MainSala", options, typedLobby: default);
    }

    public override void OnPlayerEnteredRoom(Player newPlayer)

    {
        if (PhotonNetwork.IsMasterClient && PhotonNetwork.CurrentRoom.PlayerCount == 3)
        {
            PhotonNetwork.LoadLevel(1);
        }
    }



}

