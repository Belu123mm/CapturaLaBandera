﻿using System.Collections;
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
    public TMP_Text lifeText;
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
    void Start() {
        endText = GameObject.Find("EndText").GetComponent<TextMeshProUGUI>();
        anim = GetComponent<Animator>();
        lifeText.text = "3";

        //Skinn
        //De ahi sigo esto, lo comento para no arruinar el color bonito que tiene ahora jsfjsdf
        /*
        Material aaaa = Resources.Load<Material>("penguinMaterial");
        Material aaaaaaa = new Material(aaaa);
        var materials = penguinMesh.materials;
        materials [ 0 ] = aaaaaaa;
        penguinMesh.materials = materials;
        */
    }

    // Update is called once per frame
    void Update() {
        if ( !photonView.IsMine ) {
            return;
        }
        if ( !isWalkingx && !isWalkingy ) {
            anim.SetBool("isMoving", false);
        }
    }
    public void SetPlayerName( Player p ) {

        string misticText = p.NickName;
        photonView.RPC("ReceivePlayerName", RpcTarget.All, misticText);
    }
    [PunRPC]
    void ReceivePlayerName(string text) {
        nameText.text = text;

    }
    public void SetTimerValue( float time ) {
        timeText.text = time.ToString();
    }
    public void SetSkinValues( Player p ) {

    }
    public void SetWalkAnimX( float x ) {
        isWalkingx = true;
        anim.SetFloat("xVelocity", x);
        anim.SetBool("isMoving", true);
      //  Debug.Log("aaaaaaaaaaanimationx" + anim.GetBool("isMoving"));
    }
    public void SetWalkAnimY( float y ) {
        isWalkingy = true;
        anim.SetFloat("yVelocity", y);
        anim.SetBool("isMoving", true);
       // Debug.Log("aaaaaaaaaaanimationy" + anim.GetBool("isMoving"));
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
    public void SetDamage( int newLife ) {
        //feedback y lo de la vida 
        photonView.RPC("ReceiveDamage", RpcTarget.All, newLife.ToString());
    }
    [PunRPC]
    void ReceiveDamage(string text ) {
        lifeText.text = text;
    }
    //Solo llamar para variables que se actualizen todo el rato, para lo demas existe RPC
    public void OnPhotonSerializeView( PhotonStream stream, PhotonMessageInfo info ) {  //Esto se llama cuando cambia en el server
        
        if ( stream.IsWriting ) {
            stream.SendNext(timeText.text);
        } else {
            timeText.text = (string) stream.ReceiveNext();
        }
        
    }
}