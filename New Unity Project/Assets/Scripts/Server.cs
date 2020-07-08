using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using System;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Server : MonoBehaviourPun
{
    public int maxLife;
    public Transform[] spawns;
    public static Server Instance;
    Player _server;
    public PlayerController controllerPrefab;
    public Animator winScreen;
    Dictionary<Player, PlayerModel> _dic = new Dictionary<Player, PlayerModel>();
    List<Player> playerList = new List<Player>();
    public GameObject prefab;
    private void Awake()
    {
        PhotonNetwork.AutomaticallySyncScene = true;
    }
    void Start()
    {
        if (Instance == null)
        {
            if (photonView.IsMine)
            {
                photonView.RPC("SetServer", RpcTarget.AllBuffered, PhotonNetwork.LocalPlayer);
            }
        }
        if (PhotonNetwork.IsMasterClient)
        {
            Camera.main.backgroundColor = Color.red;
            StartCoroutine(WaitForPlayers());
        }
    }

    [PunRPC]
    public void SetServer(Player serverPlayer)
    {
        if (Instance)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        _server = serverPlayer;
        if (serverPlayer != PhotonNetwork.LocalPlayer)
        {
            photonView.RPC("AddPlayer", _server, PhotonNetwork.LocalPlayer);
        }
    }


    [PunRPC]
    public void AddPlayer(Player player)
    {
        photonView.RPC("SetList", RpcTarget.AllBuffered, player);

        PlayerModel character = PhotonNetwork.Instantiate(prefab.name, spawns[_dic.Count].position, Quaternion.identity).GetComponent<PlayerModel>();
        _dic.Add(player, character);
        //  maxLife = character.life;        
    }
    [PunRPC]
    private void SetList(Player player)
    {
        if (!playerList.Contains(player))
            playerList.Add(player);
    }

    public void RequestMove(Player player, int dir)
    {
        photonView.RPC("Move", _server, player, dir);
    }
    [PunRPC]
    void Move(Player player, int dir)
    {
        if (!_dic.ContainsKey(player)) return;
    //    _dic[player].Move(dir);
    }
    public void RequestSpecial(Player player)
    {
        Debug.Log("request special");
       // photonView.RPC("Special", _server, player);
    }
    public void RequestSecondS(Player player)
    {
     //  photonView.RPC("SecondS", _server, player);
    }
    [PunRPC]
    void SecondS(Player player)
    {
        if (!_dic.ContainsKey(player)) return;
      //  _dic[player].SecondS();
    }

    [PunRPC]
    void Special(Player player)
    {
        if (!_dic.ContainsKey(player)) return;
     //   _dic[player].Special(player);
    }
   
    public void RequestMeleeDamage(PlayerModel character,int damage)//pasa un model y su daño ,convierte el moden a int para despues obtener su view
    {
        if (!PhotonNetwork.IsMasterClient) return;
        int charId = character.gameObject.GetPhotonView().ViewID;
        photonView.RPC("MeleeDamage", _server,charId, damage, charId);
    }  
    
    [PunRPC]
    void MeleeDamage( int damage, int ID)
    {
       PlayerModel model = PhotonNetwork.GetPhotonView(ID).GetComponent<PlayerModel>();
      //  model.Life -= damage;   
      //  PlayerModel.view.SetDamaged(model.Life);
    } 
 

    IEnumerator WaitForPlayers()
    {
        while (_dic.Count < 4)
        {
            yield return null;
        }      
    }     
  
   
}
