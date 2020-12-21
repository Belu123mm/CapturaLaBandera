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
    public float jumpForce;
    public float DashForce;
    public float movementSpeed;
    public float radiusRange;
    public float dashCD;
    public bool hasObject;
    public bool hasTheFlag;
    public GameObject hammer;
    public float waaaForce;
    public Vector3 inicialPos;
    //Esto seria de manera local nada mas, cada player sincroniza esto?
    // sipi pero algunas cosas del view hay que mostrarlas a todos
    public PlayerView view;
    public Grabeable _currentObject;
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
        inicialPos = transform.position;

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
            UpdateView(timeWithFlag);
            //llamar al server a sincronizar
        }
        if (timeWithFlag >= totalTime)
        {
            Server.Instance.GetWinner(this);
        }
    }

    private void FixedUpdate()
    {
        rb.velocity = movementVector * Time.deltaTime * movementSpeed;
    }

    Vector3 movementVector;
    public void MoveHorizontal(float dir, Vector3 camRight, Vector3 currentDir)
    {
        if (!_isMovingHor)
        {
            _isMovingHor = true;
            movementVector += camRight * dir;
            view.SetWalkAnimY(dir);
            StartCoroutine(WaitToMoveHor());
        }
    }
    public void MoveVertical(float dir, Vector3 camForward)
    {
        if (!_isMovingVer)
        {
            _isMovingVer = true;
            movementVector += camForward * dir;
            view.SetWalkAnimY(dir);
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
        StopCoroutine(WaitToAttack());
        StartCoroutine(WaitToAttack());
        //La idea es que si activaste el collidrer, este detecte ls colision y le avise al server
        //enviar el playerModel dañado y el daño realizado a RequestDamage(PlayerModel ,float damage)
    }
    public void Dash(float dir)
    {
        if (!_isDashing)
        {
            StopCoroutine(DashTime(dir));
            StartCoroutine(DashTime(dir));
        }
    }
    public void Grab()
    {
        Debug.Log("GRABBIN");
        //Si tiene un objeto
        if (hasObject)
        {
            //Let it go
            Server.Instance.RequestRemove(this, _currentObject);
            _currentObject = null;
            hasObject = false;

        }
        //Si no tiene un objeto
        else
        {
            //Smash
            Collider[] collisions = Physics.OverlapSphere(transform.position, radiusRange);
            //Solo el 1ro
            var gList = collisions.Where(x => x.GetComponent<Grabeable>() == true).Select(x => x.GetComponent<Grabeable>());
            if (gList.Any())
            {
                Grabeable g = gList.First();



                if (g != null && !g.grabed)
                {
                    hasObject = true;
                    //Server.Instance.CheckedGrab(g, this);
                    g.grabed = true;
                    g.transform.parent = transform;
                    g.transform.position = grabPoint.position;

                    _currentObject = g;
                    Debug.Log("PESCAO");
                    if (g.IsFlag)
                    {
                        hasTheFlag = true;
                    }
                }
            }
        }
    }


    public void Jump()
    {
        if (_grounded)
        {
            rb.AddForce(Vector3.up * jumpForce);
        }
    }
    public void Ability()
    {
        //Como es una cosa que hace el server y tiene rigidbody, ps el movimiento se replica cuando pasas el addforce
        Collider[] penguinz = Physics.OverlapSphere(transform.position, radiusRange);
        Debug.DrawLine(transform.position, transform.position + transform.forward * radiusRange);
        Debug.DrawLine(transform.position, transform.position - transform.forward * radiusRange);
        Debug.DrawLine(transform.position, transform.position + transform.right * radiusRange);
        Debug.DrawLine(transform.position, transform.position - transform.right * radiusRange);
        if (penguinz.Length > 0)
        {

            for (int i = 0; i < penguinz.Length; i++)
            {
                if (penguinz[i].gameObject != this)
                {
                    Vector3 dir = penguinz[i].transform.position - transform.position;
                    Debug.Log(penguinz[i].name);
                    Rigidbody rb = penguinz[i].GetComponent<Rigidbody>();
                    if (rb != null)
                    {
                        rb.AddForce(dir.normalized * waaaForce);

                    }
                }
            }
        }

        view.SetAbility();

    }

    public void GetDamage(int damage)
    {
        life -= damage;

        view.SetDamage(life);
    }
    public void addLife(int heal)
    {
        life += heal;
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
        if (_isMovingHor)
        {
            yield return new WaitForFixedUpdate();
            _isMovingHor = false;

        }
    }
    IEnumerator WaitToMoveVer()
    {
        if (_isMovingVer)
        {
            yield return new WaitForFixedUpdate();
            _isMovingVer = false;

        }
    }
    IEnumerator DashTime(float dir)
    {
        _isDashing = true;
        rb.angularVelocity = Vector3.zero;
        rb.velocity = Vector3.zero;
        rb.AddForce(transform.forward * dir * DashForce);
        yield return new WaitForSeconds(0.3f);
        rb.AddForce(transform.forward * -dir * (DashForce / 2));
        yield return new WaitForSeconds(dashCD);
        _isDashing = false;
    }
    private void OnCollisionStay(Collision collision)
    {
        if (collision.gameObject.layer == 10)
        {
            _grounded = true;
        }
    }
    private void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.layer == 10)
        {
            _grounded = false;
        }
    }
}