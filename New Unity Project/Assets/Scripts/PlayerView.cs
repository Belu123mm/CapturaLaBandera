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
    //Start
        //Name
    public void SetPlayerName( Player p ) {

        string misticText = p.NickName;
        photonView.RPC("ReceivePlayerName", RpcTarget.All, misticText);
    }
    [PunRPC]
    void ReceivePlayerName(string text) {
        nameText.text = text;

    }
        //Material
    public void SetMaterialNya(Player p ) {
        photonView.RPC("ReceiveMaterialNya", RpcTarget.All, p);
    }
    [PunRPC]
    void ReceiveMaterialNya(Player p) {
        Vector3 baseColorVector = (Vector3) p.CustomProperties [ "BaseColor" ];
        Color baseColor = new Color(baseColorVector.x, baseColorVector.y, baseColorVector.z);
        penguinMesh.material.SetColor("_baseColor", baseColor);
        penguinMesh.material.SetFloat("_PenguinMetallic", (float)p.CustomProperties [ "BaseMetallic" ]);
        penguinMesh.material.SetFloat("_PeguinSmoothness",(float)p.CustomProperties [ "BaseSmoothness" ]);
        Vector3 patternColorVector = (Vector3)p.CustomProperties [ "PatternColor" ];
        Color patternColor = new Color(patternColorVector.x, patternColorVector.y, patternColorVector.z);
        penguinMesh.material.SetColor("_patternColor", patternColor);
        penguinMesh.material.SetFloat("_SkinIntensity",(float)p.CustomProperties [ "PatternIntensity" ]);
        switch ( (int ) p.CustomProperties [ "PatternType" ] ) {
            case 0:
            penguinMesh.material.SetTexture("_SKin",Resources.Load<Texture>("penguin v1"));
            break;
            case 1:
            penguinMesh.material.SetTexture("_SKin",Resources.Load<Texture>("penguin v2"));
            break;
            case 2:
            penguinMesh.material.SetTexture("_SKin",Resources.Load<Texture>("penguin v3"));
            break;
        }
        Vector3 clothesColorVector = (Vector3)p.CustomProperties [ "ClothesColor" ];
        Color clothesColor = new Color(clothesColorVector.x, clothesColorVector.y, clothesColorVector.z);
        penguinMesh.material.SetColor("_clothesColor", clothesColor);
        penguinMesh.material.SetFloat("_ClothesMetallic", (float) p.CustomProperties [ "ClothesMetallic" ]);
        penguinMesh.material.SetFloat("_ClothesSmootness", (float) p.CustomProperties [ "ClothesSmoothness" ]);
        switch ( (int) p.CustomProperties [ "ClothesType" ] ) {
            case 0:
            penguinMesh.material.SetTexture("_Clothes", Resources.Load<Texture>("penguin v1"));
            break;
            case 1:
            penguinMesh.material.SetTexture("_Clothes", Resources.Load<Texture>("penguin v2"));
            break;
            case 2:
            penguinMesh.material.SetTexture("_Clothes", Resources.Load<Texture>("penguin v3"));
            break;
        }
        
        var matz = penguinMesh.materials;
        matz [ 1 ] = Resources.Load<Material>("FeedbackShader");  //no?
        
    }

    //Update
    public void SetTimerValue( float time ) {
        timeText.text = time.ToString();
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
        photonView.RPC("TriggerAttack", RpcTarget.All);
    }
    [PunRPC]
    void TriggerAttack() {
        anim.SetTrigger("attack");

    }
    public void SetAbility() {
        photonView.RPC("TriggerAbility", RpcTarget.All);
    }
    [PunRPC]
    void TriggerAbility() {
        anim.SetTrigger("waaa");

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
        StartCoroutine(DamageFeedback());
    }
    IEnumerator DamageFeedback() {
        Material [] mats;
        mats = penguinMesh.materials;
        mats [ 1 ].SetFloat("FeedbackType", 1);
        mats [ 1 ].SetFloat("value", 1);
        penguinMesh.materials = mats;
        yield return new WaitForSeconds(3);
        mats = penguinMesh.materials;
        mats [ 1 ].SetFloat("value", 0);
        penguinMesh.materials = mats;

    }
    /*
    IEnumerator ReviveFeedback() {
        feedbackMat.SetFloat("FeedbackType", 0);
        feedbackMat.SetFloat("value", 1);
        yield return new WaitForSeconds(0.2f);
        feedbackMat.SetFloat("value", 0);

    }*/
    //Solo llamar para variables que se actualizen todo el rato, para lo demas existe RPC
    public void OnPhotonSerializeView( PhotonStream stream, PhotonMessageInfo info ) {  //Esto se llama cuando cambia en el server
        
        if ( stream.IsWriting ) {
            stream.SendNext(timeText.text);
        } else {
            timeText.text = (string) stream.ReceiveNext();
        }
        
    }
}