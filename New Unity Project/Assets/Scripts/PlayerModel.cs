using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(PlayerView))]
public class PlayerModel : MonoBehaviour
{
    //Variables

    //Esto seria de manera local nada mas, cada player sincroniza esto?
    PlayerView view;

    // Start is called before the first frame update
    void Start() {
        view = GetComponent<PlayerView>();
    }


    // Update is called once per frame
    void Update()
    {
        
    }
}
