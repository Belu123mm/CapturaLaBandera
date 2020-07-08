using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(PlayerView))]
public class PlayerModel : MonoBehaviour {
    //Variables

    //Esto seria de manera local nada mas, cada player sincroniza esto?
    PlayerView view;

    bool _isMovingHor;
    bool _isMovingVer;

    // Start is called before the first frame update
    void Start() {
        view = GetComponent<PlayerView>();
    }


    // Update is called once per frame
    void Update() {

    }
    void MoveHorizontal() {

    }
    void MoveVertical() {

    }
    void Attack() {

    }
    void Dash() {

    }
    void Grab() {

    }
    void Jum() {

    }
    void Ability() {

    }

    //Para no llenar la red con paquetes
    IEnumerator WaitToMoveHor() {
        yield return new WaitForFixedUpdate();
        _isMovingHor = false;
    }
    IEnumerator WaitToMoveVer() {
        yield return new WaitForFixedUpdate();
        _isMovingVer = false;
    }
    
}
