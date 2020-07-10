using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(PlayerView))]
public class PlayerModel : MonoBehaviour
{
    
    //Variables
    public Transform grabPoint;//usted sabe,ahi va la posicion del objeto agarrado


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
        //lo llama MoveX
    }
    public void MoveVertical(float dir)
    {
        //lo llama MoveY
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
