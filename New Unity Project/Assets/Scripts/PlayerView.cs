using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using Photon.Pun;
using Photon.Realtime;
using Hashtable = ExitGames.Client.Photon.Hashtable;
using UnityEngine.UI;

public class PlayerView : MonoBehaviourPun, IPunObservable {
    public TMP_Text nameText;
    public TMP_Text timeText;
    public TextMeshProUGUI endText;
    public SkinnedMeshRenderer penguinMesh;

    [SerializeField]
    Animator anim;

    //Skinvalues
    bool isSkinReady;   //Este se sincroniza, el otro no
    bool isSkinChanged;

    //Int de 0 a 2
    int skin;
    int clothes;
    //Vectores de 0 a 1
    Vector3 baseColor;
    Vector3 skinColor;
    Vector3 clothesColor;
    //Valores de 0 a 1
    float skInt;
    float clothSm;
    float clothMet;
    float penSm;
    float pengMet;

    bool isWalkingx;
    bool isWalkingy;

    // Start is called before the first frame update
    void Start()
    {
        endText = GameObject.Find("EndText").GetComponent<TextMeshProUGUI>();
        anim = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if ( !photonView.IsMine ) {
            return;
        }
        if(!isWalkingx && !isWalkingy ) {
            anim.SetBool("isMoving", false);
        }
    }
    public void SetPlayerName (Player p ) {

        string misticText = (string) p.CustomProperties [ "Name" ];
        nameText.text = misticText;

    }
    public void SetTimerValue(float time ) {
        timeText.text = time.ToString();
    }
    public void SetSkinValues (Player p ) {

    }
    public void SetWalkAnimX(float x) {
        isWalkingx = true;
        anim.SetFloat("xVelocity", x);
        anim.SetBool("isMoving", true);
        Debug.Log("aaaaaaaaaaanimationx" + anim.GetBool("isMoving"));
    }
    public void SetWalkAnimY(float y) {
        isWalkingy = true;
        anim.SetFloat("yVelocity", y);
        anim.SetBool("isMoving", true);
        Debug.Log("aaaaaaaaaaanimationy" + anim.GetBool("isMoving"));
    }
    public void SetAttack() {
        anim.SetTrigger("attack");
    }
    public void IsNotMovingX() {
        isWalkingx = false;
        anim.SetFloat("xVelocity", 0);

    }
    public void IsNotMovingY() {
        isWalkingy = false;
        anim.SetFloat("yVelocity", 0);

    }
    public void OnPhotonSerializeView( PhotonStream stream, PhotonMessageInfo info ) {  //Esto se llama cuando cambia en el server
        if ( stream.IsWriting ) {
            stream.SendNext(nameText.text);
        } else {
            nameText.text = (string) stream.ReceiveNext();
        }
    }
}