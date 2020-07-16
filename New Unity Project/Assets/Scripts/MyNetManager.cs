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
                Debug.Log("RECAMBIO");

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

    //Callbacks

    public override void OnConnectedToMaster() {
        PhotonNetwork.JoinLobby(TypedLobby.Default);
    }

    public override void OnJoinedLobby() {
        PhotonNetwork.AutomaticallySyncScene = true;
        //Custom Properties
        string namedes = PhotonNetwork.NickName;
        Hashtable hash = new Hashtable();
        hash.Add("Name", namedes);
        PhotonNetwork.LocalPlayer.SetCustomProperties(hash);

        if ( isHost ) {
            //Esta es la instancia del juego, en terminos de network no de escenas 
            PhotonNetwork.CreateRoom("MainRoom", new RoomOptions() { MaxPlayers = 3 });     //NUMERO DE PLAYERS
            return;
        } else {
            PhotonNetwork.JoinRandomRoom();

        }

    }

}

