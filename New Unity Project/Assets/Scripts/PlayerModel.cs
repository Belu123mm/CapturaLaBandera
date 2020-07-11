using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
[RequireComponent(typeof(PlayerView))]
[RequireComponent(typeof(CameraHandler))]
public class PlayerModel : MonoBehaviourPun
{
    
    //Variables
    public Transform grabPoint;//usted sabe,ahi va la posicion del objeto agarrado

    public float rotateSpeed;
    public float movementSpeed;


    //Esto seria de manera local nada mas, cada player sincroniza esto?
    PlayerView view;
    CameraHandler camHandler;

    private bool _isMovingHor;
    private bool _isMovingVer;

    // Start is called before the first frame update
    void Start() {
    }
    
    // Update is called once per frame
    void Update()
    {
    }

    public void StartPlayer() {
        camHandler = gameObject.GetComponent<CameraHandler>();
        Debug.Log("playeriniciado");

        if ( camHandler != null ) {
            camHandler.OnStartFollowing();
        }
    }
        public void MoveHorizontal(float dir )
    {
        if ( !_isMovingHor ) {
            _isMovingHor = true;
            /*
             * Ahora todo esto estaria en el controller, solo le pasaria la nueva direccion a la que mirar
             * 
             */

            Vector3 camRight = new Vector3(camHandler.cameraTransform.right.x, 0, camHandler.cameraTransform.right.z);
            Debug.Log(camRight);

            Vector3 currentDir = new Vector3(camHandler.cameraTransform.forward.x, 0, camHandler.cameraTransform.forward.z);

            Debug.DrawLine(currentDir, (transform.position + camRight), Color.red);

            float step = rotateSpeed * dir * Time.deltaTime;

            Vector3 newDir = Vector3.RotateTowards(currentDir, camRight, step, 0.0f);

            transform.rotation = Quaternion.LookRotation(newDir);

            StartCoroutine(WaitToMoveHor());
        }
    }
    public void MoveVertical(float dir )
    {
        if ( !_isMovingVer ) {
            _isMovingVer = true;

            Vector3 camForward = new Vector3(camHandler.cameraTransform.forward.x, 0, camHandler.cameraTransform.forward.z);

            Debug.Log(camForward);

            transform.position += Time.deltaTime * camForward * dir * movementSpeed;

            Debug.Log(transform.position + camForward);

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