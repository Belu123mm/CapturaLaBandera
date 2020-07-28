using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using System.Linq;
using Photon.Realtime;
using System;

public class PlayerModel : MonoBehaviourPun
{
    //Variables
    public Transform grabPoint;//usted sabe,ahi va la posicion del objeto agarrado
    public int life = 3;    //Cada hit es de 1, asi que ps 3 hits de base pero vemos, you know
    public float rotateSpeed;
    public float movementSpeed;
    public float radiusRange;
    public float dashCD;
    public bool hasTheFlag;
    public GameObject hammer;
    //Esto seria de manera local nada mas, cada player sincroniza esto?
    // sipi pero algunas cosas del view hay que mostrarlas a todos
    public PlayerView view;
    private float timeWithFlag;
    private float totalTime = 60;
    private bool _isMovingHor;
    private bool _isMovingVer;
    private bool _isDashing;
    private bool _grounded;
    private Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        view = GetComponentInChildren<PlayerView>();
        rb = GetComponent<Rigidbody>();
    }
    public void StartModel(Player p)
    {
        view.SetPlayerName(p);
        view.SetMaterialNya(p);
    }
    public void UpdateView(float t)
    {
        view.SetTimerValue(t);
    }

    // Update is called once per frame
    void Update()
    {
        if (hasTheFlag)
        {
            timeWithFlag += Time.deltaTime;
            //llamar al server a sincronizar
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
            /*
           Debug.DrawLine(currentDir, (transform.position + camRight), Color.red);


           //transform.rotation = Quaternion.LookRotation(newDir);
           */
            //RIGIDBODYMOVEMENT
            //rb.MoveRotation(Quaternion.LookRotation(newDir));
            float step = rotateSpeed * dir * Time.deltaTime;
            Vector3 newDir = Vector3.RotateTowards(currentDir, camRight, step, 0.0f);
            if (rb.angularVelocity.y *dir<0)//si esta sensilla cuenta matematica da un numero negativo quiere decir que esta girando en direccion contraria a la del input recibido
            {
                rb.angularVelocity = Vector3.zero;
            }
                rb.rotation = Quaternion.LookRotation(newDir);
            // rb.AddTorque(Vector3.up * dir * rotateSpeed * Time.deltaTime);
            StartCoroutine(WaitToMoveHor());
        }
    }
    public void MoveVertical(float dir, Vector3 camForward)
    {
        if (!_isMovingVer)
        {
            _isMovingVer = true;

            //transform.position += Time.deltaTime * camForward * dir * movementSpeed;
            //RIGIDBODYMOVEMENT
            rb.position += Time.deltaTime * camForward * dir * movementSpeed;

            Debug.DrawLine(transform.position, (transform.position + camForward), Color.green);

            view.SetWalkAnimY(dir);

            //lo llama MoveY
            StartCoroutine(WaitToMoveVer());

        }
    }
    public void StopWalkingX()
    {
        view.IsNotMovingX();

    }
    public void StopWalkingY()
    {
        view.IsNotMovingY();

    }
    public void PrepAttack()
    {
        photonView.RPC("Attack", RpcTarget.All);
    }
    [PunRPC]
    void Attack()
    {
        StartCoroutine(WaitToAttack());
        //La idea es que si activaste el collidrer, este detecte ls colision y le avise al server
        //enviar el playerModel dañado y el daño realizado a RequestDamage(PlayerModel ,float damage)
    }
    public void Dash(float dir)
    {
        if (!_isDashing)
        {
            Debug.Log("dashie");
            StartCoroutine(DashTime(dir));
        }
    }
    public void Grab()
    {
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
        PlayerModel pM = null;
        Grabeable flag = null;
        Collider[] collisions = Physics.OverlapSphere(transform.position, radiusRange);
        for (int i = 0; i < collisions.Length; i++)
        {
            if (collisions[i].GetComponent<PlayerModel>() != null && collisions[i].gameObject != this)
            {
                pM = collisions[i].GetComponent<PlayerModel>();
            }
            if (collisions[i].GetComponent<Grabeable>() != null)
            {
                flag = collisions[i].GetComponent<Grabeable>();
            }
        }
        if (pM != null && flag != null)
        {
            Server.Instance.RequestRemove(pM, flag);
        }
    }

    public void GetDamage(int damage)
    {
        life -= damage;
        view.SetDamage(life);
    }

    IEnumerator WaitToAttack()
    {

        hammer.SetActive(true);
        view.SetAttack();
        yield return new WaitForSeconds(1);
        hammer.SetActive(false);
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
    IEnumerator DashTime(float dir)
    {
        _isDashing = true;
        rb.angularVelocity = Vector3.zero;
        rb.velocity = Vector3.zero;
        rb.AddForce(transform.forward * dir * movementSpeed * 2, ForceMode.Impulse);
        yield return new WaitForSeconds(0.5f);
        rb.velocity = new Vector3(0, rb.velocity.y, 0);
        yield return new WaitForSeconds(dashCD);
        _isDashing = false;
    }
}