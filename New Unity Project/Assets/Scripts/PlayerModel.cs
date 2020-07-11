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
    public float movementSpeed;
    public float rotateSpeed;


    //Esto seria de manera local nada mas, cada player sincroniza esto?
    PlayerView view;

    CameraHandler camHandler;

    private bool _isMovingHor;
    private bool _isMovingVer;

    // Start is called before the first frame update
    void Start()
    {
        view = GetComponent<PlayerView>();

        camHandler = gameObject.GetComponent<CameraHandler>();

        if ( camHandler != null ) {
            if (photonView.IsMine ) {
                camHandler.OnStartFollowing();
                Debug.Log("STArtedD");
            }
        }

    }


    // Update is called once per frame
    void Update()
    {

    }
    public void MoveHorizontal(float dir)
    {
        if ( !_isMovingHor ) {
            _isMovingHor = true;

            Vector3 camRight = new Vector3(camHandler.cameraTransform.right.x, 0, camHandler.cameraTransform.right.z);
            Debug.Log(camRight);

            Vector3 currentDir = new Vector3(camHandler.cameraTransform.forward.x, 0, camHandler.cameraTransform.forward.z);
            Vector3 targetDir = (transform.position + camRight);

            Debug.DrawLine(currentDir, (targetDir), Color.red);

            float step = rotateSpeed * dir * Time.deltaTime;

            Vector3 newDir = Vector3.RotateTowards(currentDir, camRight, step, 0.0f);

            transform.rotation = Quaternion.LookRotation(newDir);

            StartCoroutine(WaitToMoveHor());
        }
    }
    public void MoveVertical(float dir)
    {
        if ( !_isMovingVer ) {
            _isMovingVer = true;
            //Tendrias que rotar
            Vector3 camForward = new Vector3(camHandler.cameraTransform.forward.x, 0, camHandler.cameraTransform.forward.z);
            Debug.Log(camForward);

            Vector3 targetDir = (transform.position + camForward);
            Debug.Log(targetDir);

            transform.position += Time.deltaTime * camForward * dir * movementSpeed;

            Debug.DrawLine(transform.position, (targetDir), Color.green);

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