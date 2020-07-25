using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using Hashtable = ExitGames.Client.Photon.Hashtable;

public class MyNetManager : MonoBehaviourPunCallbacks {
    public InputField txt;
    public SkinHandler handler;
    public Button serverButton;
    public Button clientButton;
    public bool isServerOn;
    public bool isPlayerOn;
    public bool isHost;
    public bool inGame;


    private void Awake() {
        DontDestroyOnLoad(this);
    }

    private void Start() {

        txt.text = PlayerPrefs.GetString("name");
        if ( txt.text == "" ) {
            clientButton.interactable = false;

        } else { clientButton.interactable = true; }
        PhotonNetwork.AutomaticallySyncScene = true;

    }

    public void Update() {
        if ( SceneManager.GetActiveScene().name != "Lobby" ) {
            inGame = true;
        }
        if ( inGame == false ) {
            if ( isHost ) {
                if ( PhotonNetwork.InRoom ) {//Y se cumple esta cosa cambias de escena
                    byte playerCount = PhotonNetwork.CurrentRoom.PlayerCount;

                    if ( playerCount == PhotonNetwork.CurrentRoom.MaxPlayers ) {
                        //PhotonNetwork.LoadLevel(playerCount - 2);

                        PhotonNetwork.LoadLevel(1);
                        Debug.Log("CAMBIO");
                        inGame = true;
                        return;
                    }
                }
            }//si no sos el host, no haces nada
        } else {//ahora, si hay juego, pues creas el server o el pj
            if ( isHost == true ) {

                if ( !isServerOn ) {
                    isServerOn = true;
                    PhotonNetwork.Instantiate("Server", Vector3.zero, Quaternion.identity);
                   
                    return;
                }
            }
        }
    }
    //Functions
    public void ImServer() {
        isHost = true;
        serverButton.interactable = false;
        PhotonNetwork.ConnectUsingSettings();

    }

    public void ImClient() {
        clientButton.interactable = false;
        PhotonNetwork.ConnectUsingSettings();

    }

    public void RegisterName( string name ) {

        PlayerPrefs.SetString("name", name);
        if ( name == "" ) {
            clientButton.interactable = false;
        } else {
            clientButton.interactable = true;
            PhotonNetwork.NickName = name;
        }
    }
    public void SetSkinValues() {
        //Custom Properties
        Hashtable hash = new Hashtable();
        //hash.Add("BaseColor", handler.baseColor);
        PhotonNetwork.LocalPlayer.SetCustomProperties(hash);

    }

    public void Disconnect() {
        PhotonNetwork.Disconnect();
    }

    //Callbacks

    public override void OnConnectedToMaster() {
        PhotonNetwork.JoinLobby(TypedLobby.Default);
    }

    public override void OnJoinedLobby() {
        PhotonNetwork.AutomaticallySyncScene = true;

        if ( isHost ) {
            //Esta es la instancia del juego, en terminos de network no de escenas 
            PhotonNetwork.CreateRoom("MainRoom", new RoomOptions() { MaxPlayers = 3 });     //NUMERO DE PLAYERS
            return;
        } else {
            PhotonNetwork.JoinRandomRoom();

        }

    }

}

