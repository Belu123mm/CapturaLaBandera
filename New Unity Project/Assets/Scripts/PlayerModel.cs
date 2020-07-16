﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using System.Linq;

[RequireComponent(typeof(PlayerView))]
[RequireComponent(typeof(CameraHandler))]
public class PlayerModel : MonoBehaviourPun
{

    //Variables
    public Transform grabPoint;//usted sabe,ahi va la posicion del objeto agarrado

    public float rotateSpeed;
    public float movementSpeed;
    public float radiusRange;
    //Esto seria de manera local nada mas, cada player sincroniza esto?
    // sipi pero algunas cosas del view hay que mostrarlas a todos
    PlayerView view;

    private float timeWithFlag;
    private float totalTime=60;
    private bool hasTheFlag;
    private bool _isMovingHor;
    private bool _isMovingVer;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (hasTheFlag)
        {
            timeWithFlag += Time.deltaTime;
        }
        if (timeWithFlag >= totalTime)
        {
            Server.Instance.GetWinner(this);
        }
    }

    public void MoveHorizontal(float dir, Vector3 camRight, Vector3 currentDir)
    {
        if (!_isMovingHor)
        {
            _isMovingHor = true;
            /*
             * Ahora todo esto estaria en el controller, solo le pasaria la nueva direccion a la que mirar
             * 
             */



            Debug.DrawLine(currentDir, (transform.position + camRight), Color.red);

            float step = rotateSpeed * dir * Time.deltaTime;

            Vector3 newDir = Vector3.RotateTowards(currentDir, camRight, step, 0.0f);

            transform.rotation = Quaternion.LookRotation(newDir);

            StartCoroutine(WaitToMoveHor());
        }
    }
    public void MoveVertical(float dir, Vector3 camForward)
    {
        if (!_isMovingVer)
        {
            _isMovingVer = true;

            transform.position += Time.deltaTime * camForward * dir * movementSpeed;



            Debug.DrawLine(transform.position, (transform.position + camForward), Color.green);

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
        Debug.Log("Grabie");
        Collider[] collisions = Physics.OverlapSphere(transform.position, radiusRange);
        for (int i = 0; i < collisions.Length; i++)
        {
            if (collisions[i].GetComponent<Grabeable>() != null)
            {

                Grabeable g = collisions[i].GetComponent<Grabeable>();
                if (!g.grabed)
                {
                    Server.Instance.CheckedGrab(g, this);
                    hasTheFlag = true;
                }
            }
        }
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