using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine.Tilemaps;
using System.Linq;
public class Server : MonoBehaviourPun
{
    public int maxLife;
    public Transform[] spawns;
    public static Server Instance;
    Player _server;
    // public Animator winScreen;
    Dictionary<Player, PlayerModel> _dic = new Dictionary<Player, PlayerModel>();
    public GameObject prefab;
    public Animator endAnim;
    private void Awake()
    {
        PhotonNetwork.AutomaticallySyncScene = true;
    }
    void Start()
    {
        //endAnim = GameObject.Find("EndImage").GetComponent<Animator>();
        if (Instance == null)
        {
            if (photonView.IsMine)
            {
                photonView.RPC("SetServer", RpcTarget.AllBuffered, PhotonNetwork.LocalPlayer);
            }
        }
        else
        {
            if (photonView.IsMine)
            {

                PhotonNetwork.Destroy(gameObject);  //Me destrushe
            }
        }
        if (PhotonNetwork.IsMasterClient)
        {
            Camera.main.backgroundColor = Color.red;
            StartCoroutine(WaitForPlayers());
        }

    }

    //Set Server

    [PunRPC]
    public void SetServer(Player serverPlayer)
    {
        Instance = this;
        _server = serverPlayer;
        DontDestroyOnLoad(this);
        if (serverPlayer != PhotonNetwork.LocalPlayer)
        {
            photonView.RPC("AddPlayer", _server, PhotonNetwork.LocalPlayer);
        }
    }
    [PunRPC]
    public void AddPlayer(Player player)
    {
        PlayerModel character = PhotonNetwork.Instantiate(prefab.name, spawns[_dic.Count].position, spawns[_dic.Count].rotation).GetComponent<PlayerModel>();
        _dic.Add(player, character);
        maxLife = character.life;
    }


    public void RequestAttack(Player player)
    {
        photonView.RPC("Attack", RpcTarget.All, player);
    }
    //Ps por si acaso comento esto para que despues no me reten
    public void RequestMoveX(Player player, float dir, Vector3 camRight, Vector3 currentDir)
    {
        photonView.RPC("MoveX", _server, player, dir, camRight, currentDir);
    }

    public void RequestMoveY(Player player, float dir, Vector3 camForward)
    {
        photonView.RPC("MoveY", _server, player, dir, camForward);
    }

    void setCamHandler() //hago un rpc por cada jugador en el diccionario y les paso el ID de su model para que cada uno de forma separada active la camara
    {
        foreach (var Player in _dic)
        {
            photonView.RPC("StartPlayer", Player.Key, Player.Value.gameObject.GetPhotonView().ViewID);
            //Aca iria lo de StartModel en caso de que el planController no funcionase
        }
    }

    //Y esto igual uwu
    [PunRPC]
    void StartPlayer(int modelID)
    {

        PlayerController controller = PhotonNetwork.GetPhotonView(modelID).GetComponent<PlayerController>();
        controller.StartPlayer();

    }
    [PunRPC]
    void MoveX(Player player, float dir, Vector3 camRight, Vector3 currentDir)
    {
        if (!_dic.ContainsKey(player)) return;
        _dic[player].MoveHorizontal(dir, camRight, currentDir);
    }
    [PunRPC]
    void MoveY(Player player, float dir, Vector3 camForward)
    {
        if (!_dic.ContainsKey(player)) return;
        _dic[player].MoveVertical(dir, camForward);
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
        _dic[player].PrepAttack();
        PhotonNetwork.Instantiate("Boink", _dic [ player ].transform.position + _dic [ player ].transform.forward + _dic [ player ].transform.up * 2, _dic [ player ].transform.rotation);

    }

    public void RequestJump(Player player)
    {
        photonView.RPC("Jump", _server, player);
    }
    [PunRPC]
    void Jump(Player player)
    {
        if (!_dic.ContainsKey(player)) return;
        _dic[player].Jump();
    }
    public void RequestDamage(PlayerModel character, int damage)//pasa un model y su daño ,convierte el moden a int para despues obtener su view
    {
        int charId = character.gameObject.GetPhotonView().ViewID;
        photonView.RPC("Damage", _server, charId, damage);
    }

    [PunRPC]
    void Damage(int ID, int damage)
    {
        PlayerModel model = PhotonNetwork.GetPhotonView(ID).GetComponent<PlayerModel>();
        model.GetDamage(damage);
        if (model.life <= 0 || damage >= 3)
        {
            RequestRemove(model, model._currentObject);
            Debug.Log("se re murio");
            model.transform.position = model.inicialPos;
            model.life = 3;
            model.view.SetDamage(3);
        }
    }
    public void RequestRemove(PlayerModel pM, Grabeable flag)//pido sacarle la bandera a este model
    {
        int modelID = pM.photonView.ViewID;
        if (flag != null)
        {
            int flagID = flag.photonView.ViewID;
            photonView.RPC("RemoveFlag", RpcTarget.AllBuffered, modelID, flagID);           

        }
    }
    public void RequestTrap(Trap t)
    {
        int trapID = t.photonView.ViewID;

        photonView.RPC("ActiveTrap", RpcTarget.All, trapID);
    }
    [PunRPC]
    void ActiveTrap(int trapID)
    {
        Trap t = PhotonNetwork.GetPhotonView(trapID).GetComponent<Trap>();
        t.StartTrap();
        Destroy(t.GetComponent<Grabeable>());
    }
    [PunRPC]
    void RemoveFlag(int modelID, int flatID)
    {
        PlayerModel model = PhotonNetwork.GetPhotonView(modelID).GetComponent<PlayerModel>();
        Grabeable flag = PhotonNetwork.GetPhotonView(flatID).GetComponent<Grabeable>();
        model.hasTheFlag = false;
        flag.grabed = false;
        

        flag.transform.SetParent(null);
    }
    public void RequestAbility(Player player)
    {
        photonView.RPC("Ability", _server, player);
    }
    [PunRPC]
    void Ability(Player player)
    {
        if (!_dic.ContainsKey(player)) return;
        _dic[player].Ability();
        PhotonNetwork.Instantiate("WAA", _dic [ player ].transform.position + _dic [ player ].transform.forward + _dic [ player ].transform.up * 2, _dic [ player ].transform.rotation);
    }
    public void RequestDash(Player player, float x)
    {
        photonView.RPC("Dash", _server, player, x);
    }
    [PunRPC]
    void Dash(Player player, float x)
    {
        if (!_dic.ContainsKey(player)) return;
        _dic[player].Dash(x);
    }

    public void RequestGrab(Player player)
    {
        photonView.RPC("Grab", _server, player);
        Debug.Log("grabbbbbbbin");

    }
    public void CheckedGrab(Grabeable obj, PlayerModel model)
    {
        int objID = obj.gameObject.GetPhotonView().ViewID;
        int modelID = model.gameObject.GetPhotonView().ViewID;
        photonView.RPC("GrabObject", RpcTarget.AllBuffered, objID, modelID);
    }

    [PunRPC]
    void Grab(Player player)
    {

        if (!_dic.ContainsKey(player)) return;
        _dic[player].Grab();
    }
    [PunRPC]
    void GrabObject(int objID, int modelID)
    {
        Grabeable obj = PhotonNetwork.GetPhotonView(objID).GetComponent<Grabeable>();
        obj.grabed = true;
        PlayerModel model = PhotonNetwork.GetPhotonView(modelID).GetComponent<PlayerModel>();
        obj.transform.parent = model.transform;       
    }

    public void GetWinner(PlayerModel model)
    {
        int modelID = model.photonView.ViewID;

        foreach (var item in _dic)
        {
            if (item.Value == model)
            {
                photonView.RPC("SetWinner", item.Key, item.Value.photonView.ViewID, true);

            }
            else
            {
                photonView.RPC("SetWinner", item.Key, item.Value.photonView.ViewID, false);

            }

        }
        endAnim.SetBool("End", true);
    }
    [PunRPC]
    private void SetWinner(int modelID, bool isWinner)//en teoria, este rpc es individual para cada player en el diccionario,entonces cada uno checkea esto
    {
        PlayerModel model = PhotonNetwork.GetPhotonView(modelID).GetComponent<PlayerModel>();
        if (!isWinner)
        {
            model.view.endText.text = "You Lose :c";
        }
        else
        {
            model.view.endText.text = "You Win :D";
        }

    }

    public void RequestStartModel(Player p)
    { //Esto tmbn inicia al view. Es como el start
        photonView.RPC("StartPlayerModel", RpcTarget.AllBuffered, p);
    }

    [PunRPC]
    private void StartPlayerModel(Player p)
    {
        if (!_dic.ContainsKey(p)) return;
        _dic[p].StartModel(p);

    }

    public void PlayerRequestToStopX(Player p)
    {
        photonView.RPC("AskToStopWalkingX", _server, p);
    }
    public void PlayerRequestToStopY(Player p)
    {
        photonView.RPC("AskToStopWalkingY", _server, p);
    }

    [PunRPC]
    void AskToStopWalkingX(Player p)
    {
        if (!_dic.ContainsKey(p)) return;
        _dic[p].StopWalkingX();
    }
    [PunRPC]
    void AskToStopWalkingY(Player p)
    {
        if (!_dic.ContainsKey(p)) return;
        _dic[p].StopWalkingY();
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
