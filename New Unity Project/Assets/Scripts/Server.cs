using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine.Tilemaps;
using System.Linq;
public class Server : MonoBehaviourPun {
    public int maxLife;
    public Transform [] spawns;
    public static Server Instance;
    Player _server;
    // public Animator winScreen;
    Dictionary<Player, PlayerModel> _dic = new Dictionary<Player, PlayerModel>();
    public GameObject prefab;
    public Animator endAnim;
    private void Awake() {
        PhotonNetwork.AutomaticallySyncScene = true;
    }
    void Start() {
        if ( Instance == null ) {
            if ( photonView.IsMine ) {
                photonView.RPC("SetServer", RpcTarget.AllBuffered, PhotonNetwork.LocalPlayer);
            }
        } else {
            if ( photonView.IsMine ) {

                PhotonNetwork.Destroy(gameObject);  //Me destrushe
            }
        }
        if ( PhotonNetwork.IsMasterClient ) {
            Camera.main.backgroundColor = Color.red;
            StartCoroutine(WaitForPlayers());
        }


    }

    //Set Server

    [PunRPC]
    public void SetServer( Player serverPlayer ) {
        Instance = this;
        _server = serverPlayer;
        DontDestroyOnLoad(this);
        if ( serverPlayer != PhotonNetwork.LocalPlayer ) {
            photonView.RPC("AddPlayer", _server, PhotonNetwork.LocalPlayer);
        }
    }
    [PunRPC]
    public void AddPlayer( Player player ) {
        PlayerModel character = PhotonNetwork.Instantiate(prefab.name, spawns [ _dic.Count ].position, Quaternion.identity).GetComponent<PlayerModel>();
        _dic.Add(player, character);
        //  maxLife = character.life;        
    }

    public void RequestAttack( Player player ) {
        photonView.RPC("Attack", _server, player);
    }
    //Ps por si acaso comento esto para que despues no me reten
    public void RequestMoveX( Player player, float dir, Vector3 camRight, Vector3 currentDir ) {
        photonView.RPC("MoveX", _server, player, dir, camRight, currentDir);
    }

    public void RequestMoveY( Player player, float dir, Vector3 camForward ) {
        photonView.RPC("MoveY", _server, player, dir, camForward);
    }

    void setCamHandler() //hago un rpc por cada jugador en el diccionario y les paso el ID de su model para que cada uno de forma separada active la camara
    {
        foreach ( var Player in _dic ) {
            photonView.RPC("StartPlayer", Player.Key, Player.Value.gameObject.GetPhotonView().ViewID);
            //Aca iria lo de StartModel en caso de que el planController no funcionase
        }
    }

    //Y esto igual uwu
    [PunRPC]
    void StartPlayer( int modelID ) {

        PlayerController controller = PhotonNetwork.GetPhotonView(modelID).GetComponent<PlayerController>();
        controller.StartPlayer();

    }
    [PunRPC]
    void MoveX( Player player, float dir, Vector3 camRight, Vector3 currentDir ) {
        if ( !_dic.ContainsKey(player) ) return;
        _dic [ player ].MoveHorizontal(dir, camRight, currentDir);
    }
    [PunRPC]
    void MoveY( Player player, float dir, Vector3 camForward ) {
        if ( !_dic.ContainsKey(player) ) return;
        _dic [ player ].MoveVertical(dir, camForward);
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
    void Attack( Player player ) {
        if ( !_dic.ContainsKey(player) ) return;
        _dic [ player ].Attack();
    }



    public void RequestDamage( PlayerModel character, float damage )//pasa un model y su daño ,convierte el moden a int para despues obtener su view
    {
        if ( !PhotonNetwork.IsMasterClient ) return;
        int charId = character.gameObject.GetPhotonView().ViewID;
        photonView.RPC("Damage", _server, charId, damage);
    }

    [PunRPC]
    void Damage( int ID, int damage ) {
        PlayerModel model = PhotonNetwork.GetPhotonView(ID).GetComponent<PlayerModel>();
        //  model.Life -= damage;   
        //  PlayerModel.view.SetDamaged(model.Life);
    }
    public void RequestDash( Player player ) {
        if ( !PhotonNetwork.IsMasterClient ) return;
        photonView.RPC("Dash", _server);
    }
    [PunRPC]
    void Dash( Player player ) {
        if ( !_dic.ContainsKey(player) ) return;
        _dic [ player ].Dash();
    }

    public void RequestGrab( Player player ) {
        photonView.RPC("Grab", _server, player);

    }
    public void CheckedGrab( Grabeable obj, PlayerModel model ) {
        int objID = obj.gameObject.GetPhotonView().ViewID;
        int modelID = model.gameObject.GetPhotonView().ViewID;
        photonView.RPC("GrabObject", _server, objID, modelID);
    }

    [PunRPC]
    void Grab( Player player ) {
        Debug.Log("grabeo " + player);
        if ( !_dic.ContainsKey(player) ) return;
        _dic [ player ].Grab();
    }
    [PunRPC]
    void GrabObject( int objID, int modelID ) {
        Grabeable obj = PhotonNetwork.GetPhotonView(objID).GetComponent<Grabeable>();
        obj.grabed = true;
        PlayerModel model = PhotonNetwork.GetPhotonView(modelID).GetComponent<PlayerModel>();
        obj.transform.parent = model.transform;
        obj.transform.position = model.grabPoint.position;
    }

    public void GetWinner( PlayerModel model ) {
        int modelID = model.photonView.ViewID;
        photonView.RPC("SetWinner", _server, modelID);
    }
    [PunRPC]
    private void SetWinner( int modelID ) {
        PlayerModel model = PhotonNetwork.GetPhotonView(modelID).GetComponent<PlayerModel>();
        Player ppp = _dic.Select(x => x.Key).Where(x => _dic [ x ] == model).First();
        foreach (var item in _dic)
        {
            if (item.Key != ppp)
            {
                item.Value.view.endText.text = "You Lose";
            }
        }
        //proximamente mostrarle al ganador un winscreen y a los perdedores decirles que el gano
    }

    public void RequestStartModel( Player p ) { //Esto tmbn inicia al view. Es como el start
        photonView.RPC("StartPlayerModel", RpcTarget.AllBuffered, p);
    }

    [PunRPC]
    private void StartPlayerModel(Player p ) {
        if ( !_dic.ContainsKey(p) ) return;
        _dic [ p ].StartModel(p);

    }

    IEnumerator WaitForPlayers()
    {
        while (_dic.Count < 2)
        {
            yield return null;
        }
        setCamHandler();
    }


}
