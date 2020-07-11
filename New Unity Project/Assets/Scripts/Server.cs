using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;


public class Server : MonoBehaviourPun
{
    public int maxLife;
    public Transform[] spawns;
    public static Server Instance;
    Player _server;
   // public Animator winScreen;
    Dictionary<Player, PlayerModel> _dic = new Dictionary<Player, PlayerModel>();
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
        PlayerModel character = PhotonNetwork.Instantiate(prefab.name, spawns[_dic.Count].position, Quaternion.identity).GetComponent<PlayerModel>();
        _dic.Add(player, character);
        //  maxLife = character.life;        
    }

    public void RequestAttack(Player player)
    {
        photonView.RPC("Attack", _server, player);
    }
    //Ps por si acaso comento esto para que despues no me reten
    public void RequestMoveX(Player player, float dir)
    {
        photonView.RPC("MoveX", _server, player, dir);
    }
    
    public void RequestMoveY(Player player, float dir)
    {
        photonView.RPC("MoveY", _server, player, dir);
    }
     
    /*
    public void RequestMoveX( Player player, Vector3 newDir ) {
        photonView.RPC("MoveX", _server, player, newDir);
    }
    public void RequestMoveY( Player player, Vector3 camForward ) {
        photonView.RPC("MoveY", _server, player, camForward);
    }
    */
    public void RequestStartCamHandler( Player player) {
        photonView.RPC("StartCamHandler", player, player);
        Debug.Log("hago llamada a " + player);

    }

    //RPC
    //Y esto igual uwu
    
    [PunRPC]
    void StartCamHandler(Player player ) {
        Debug.Log("recibo llamada a " + player);
        if ( !PhotonNetwork.IsMasterClient ) {

        if ( !_dic.ContainsKey(player) ) return;
        _dic [ player ].StartPlayer();
        }

    }

    void MoveX(Player player, float dir)
    {
        Debug.Log("se movio " + player);
        if (!_dic.ContainsKey(player)) return;
        _dic[player].MoveHorizontal(dir);
    }
    [PunRPC]
    void MoveY(Player player, float dir)
    {
        if (!_dic.ContainsKey(player)) return;
        _dic[player].MoveVertical(dir);
    }
    /*
    void MoveX( Player player, Vector3 newDir ) {
        Debug.Log("se movio " + player);
        if ( !_dic.ContainsKey(player) ) return;
        _dic [ player ].MoveHorizontal(newDir);
    }
    [PunRPC]
    void MoveY( Player player, Vector3 camForward ) {
        if ( !_dic.ContainsKey(player) ) return;
        _dic [ player ].MoveVertical(camForward);
    }
    */
    [PunRPC]
    void Attack(Player player)
    {
        if (!_dic.ContainsKey(player)) return;
        _dic[player].Attack();
    }



    public void RequestDamage(PlayerModel character, float damage)//pasa un model y su daño ,convierte el moden a int para despues obtener su view
    {
        if (!PhotonNetwork.IsMasterClient) return;
        int charId = character.gameObject.GetPhotonView().ViewID;
        photonView.RPC("Damage", _server, charId, damage);
    }

    [PunRPC]
    void Damage(int ID, int damage)
    {
        PlayerModel model = PhotonNetwork.GetPhotonView(ID).GetComponent<PlayerModel>();
        //  model.Life -= damage;   
        //  PlayerModel.view.SetDamaged(model.Life);
    }
    public void RequestDash(Player player)
    {
        if (!PhotonNetwork.IsMasterClient) return;
        photonView.RPC("Dash", _server);
    }
    [PunRPC]
    void Dash(Player player)
    {
        if (!_dic.ContainsKey(player)) return;
        _dic[player].Dash();
    }

    public void RequesGrab(Grabeable obj, PlayerModel model)
    {
        int objID = obj.gameObject.GetPhotonView().ViewID;
        int modelID = model.gameObject.GetPhotonView().ViewID;
        photonView.RPC("Grab", _server,objID, modelID);     
    }

    [PunRPC]
    void Grab(int objID, int modelID)
    {
        Grabeable obj = PhotonNetwork.GetPhotonView(objID).GetComponent<Grabeable>();
        obj.grabed = true;
        PlayerModel model= PhotonNetwork.GetPhotonView(modelID).GetComponent<PlayerModel>();
        obj.transform.parent = model.transform;
        obj.transform.position = model.grabPoint.position;
    }


    IEnumerator WaitForPlayers()
    {
        while (_dic.Count < 4)
        {
            yield return null;
        }
    }


}
