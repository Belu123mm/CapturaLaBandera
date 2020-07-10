﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(PlayerView))]
public class PlayerModel : MonoBehaviour
{
    
    //Variables
    public Transform grabPoint;//usted sabe,ahi va la posicion del objeto agarrado
    public float speed;

    //Esto seria de manera local nada mas, cada player sincroniza esto?
    PlayerView view;

    private bool _isMovingHor;
    private bool _isMovingVer;

    // Start is called before the first frame update
    void Start()
    {
        view = GetComponent<PlayerView>();
    }


    // Update is called once per frame
    void Update()
    {

    }
    public void MoveHorizontal(float dir)
    {
        if ( !_isMovingHor ) {
            _isMovingHor = true;

            //lo llama MoveX
            transform.position += transform.forward * dir * speed * Time.deltaTime;

            StartCoroutine(WaitToMoveHor());
        }
    }
    public void MoveVertical(float dir)
    {
        if ( !_isMovingVer ) {
            _isMovingVer = true;
            //Tendrias que rotar


            //lo llama MoveY
            StartCoroutine(WaitToMoveVer());

        }
    }
    public void Attack()
    {
        //enviar el playerModel dañado y el daño realizado a RequestDamage(PlayerModel ,float damage)
    }
    public void Dash()
    {

    }
    public void Grab()
    {
        //envia el componente Grabeable y este model a RequestGrab
    }
    public void Jum()
    {

    }
    public void Ability()
    {

    }

    //Para no llenar la red con paquetes
    IEnumerator WaitToMoveHor()
    {
        yield return new WaitForFixedUpdate();
        _isMovingHor = false;
    }
    IEnumerator WaitToMoveVer()
    {
        yield return new WaitForFixedUpdate();
        _isMovingVer = false;
    }

}
