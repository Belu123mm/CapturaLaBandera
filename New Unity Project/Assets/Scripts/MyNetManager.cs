using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;
using Hashtable = ExitGames.Client.Photon.Hashtable;

public class MyNetManager : MonoBehaviourPunCallbacks
{
    public InputField nameText;
    public TMP_Text infoText;
    public TMP_InputField serverpeople;
    public SkinHandler handler;
    public Button serverButton;
    public Button clientButton;
    public bool isServerOn;
    public bool isPlayerOn;
    public bool isHost;
    public bool inGame;

    private void Awake() => DontDestroyOnLoad(this);

    private void Start() => PhotonNetwork.AutomaticallySyncScene = true;

    public void Update()
    {
        if (SceneManager.GetActiveScene().name != "Lobby")
        {
            inGame = true;
        }
        if (inGame == false)
        {
            if (isHost)
            {
                if (PhotonNetwork.InRoom)
                {//Y se cumple esta cosa cambias de escena

                    byte playerCount = PhotonNetwork.CurrentRoom.PlayerCount;

                    if (playerCount == PhotonNetwork.CurrentRoom.MaxPlayers)
                    {
                        PhotonNetwork.LoadLevel(1);
                        Debug.Log("CAMBIO");
                        inGame = true;
                        return;
                    }
                }
            }//si no sos el host, no haces nada
        }
        else
        {//ahora, si hay juego, pues creas el server o el pj
            if (isHost == true)
            {

                if (!isServerOn)
                {
                    isServerOn = true;
                    PhotonNetwork.Instantiate("Server", Vector3.zero, Quaternion.identity);

                    return;
                }
            }
        }
    }
    //Functions
    public void ImServer()
    {
        isHost = true;
        PhotonNetwork.ConnectUsingSettings();
        infoText.text = "Connecting as Server";

    }

    public void ImClient()
    {
        PhotonNetwork.ConnectUsingSettings();
        infoText.text = "Connecting to Server";
    }

    public void RegisterName(string name)
    {

        PlayerPrefs.SetString("name", name);
        if (name == "")
        {
            clientButton.interactable = false;
        }
        else
        {
            clientButton.interactable = true;
            PhotonNetwork.NickName = name;
        }
    }

    public void SetSkinValues()
    {
        //Custom Properties
        //Color thingz. 10 variables
        Hashtable hash = new Hashtable();
        Vector3 baseColor = new Vector3(handler.baseColor.r, handler.baseColor.g, handler.baseColor.b);
        hash.Add("BaseColor", baseColor);
        hash.Add("BaseMetallic", handler.baseMetallic.value);
        hash.Add("BaseSmoothness", handler.baseSmoothness.value);
        Vector3 patternColor = new Vector3(handler.patternColor.r, handler.patternColor.g, handler.patternColor.b);
        hash.Add("PatternColor", patternColor);
        hash.Add("PatternIntensity", handler.patternIntensity.value);
        hash.Add("PatternType", handler.patternType.value);
        Vector3 clothesColor = new Vector3(handler.clothesColor.r, handler.clothesColor.g, handler.clothesColor.b);
        hash.Add("ClothesColor", clothesColor);
        hash.Add("ClothesMetallic", handler.clothesMetallic.value);
        hash.Add("ClothesSmoothness", handler.clothesSmoothness.value);
        hash.Add("ClothesType", handler.clothesType.value);
        PhotonNetwork.LocalPlayer.SetCustomProperties(hash);

    }

    public void Disconnect() => PhotonNetwork.Disconnect();

    //Callbacks

    public override void OnConnectedToMaster() => PhotonNetwork.JoinLobby(TypedLobby.Default);

    public override void OnJoinedLobby()
    {
        PhotonNetwork.AutomaticallySyncScene = true;
        infoText.text = "In Lobby";

        if (isHost)
        {
            //Esta es la instancia del juego, en terminos de network no de escenas 
            int pp = byte.Parse(serverpeople.text) + 1;
            string owo = "" + pp;
            byte players = byte.Parse(owo);
            Debug.Log(players);
            PhotonNetwork.CreateRoom("MainRoom", new RoomOptions() { MaxPlayers = players });     //NUMERO DE PLAYERS
            return;
        }
        else
        {
            PhotonNetwork.JoinRandomRoom();

        }

    }
    public override void OnCreatedRoom()
    {
        DebugCustomConsole.Log("Room created", Color.yellow);
        infoText.text = "Room created";
    }

    public override void OnJoinedRoom()
    {
        DebugCustomConsole.Log("In Room", Color.yellow);
        infoText.text = "In room";

    }
    public override void OnJoinRandomFailed(short returnCode, string message)
    {
        DebugCustomConsole.Log("Failed.Cause: " + message, Color.red);
        infoText.text = "Failed. Cause: " + message;
        PhotonNetwork.Disconnect();
    }


    public override void OnDisconnected(DisconnectCause cause)
    {
        DebugCustomConsole.Log("On Disconected", Color.red);
        infoText.text = cause.ToString();
    }


}

