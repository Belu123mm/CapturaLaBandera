using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using Tools.EventClasses;
using System;

public class TriggerDispatcher : MonoBehaviour
{
    [SerializeField] UnityEvent OnTriggerEnterEvent = null;
    [SerializeField] UnityEvent OnTriggerExitEvent = null;
    [SerializeField] UnityEvent OnTriggerLateEnterEvent = null;
    [SerializeField] EventGameObject OnGameObjectTrigger = null;

    public Entities whocantrigger = Entities.player;

    public void SubscribeToEnter(UnityAction callback)
    {
        OnTriggerEnterEvent.AddListener(callback);
    }

    private void OnTriggerEnter(Collider other)
    {
        StartCoroutine(LateEnter(other));
        
        OnExecute(OnTriggerEnterEvent, other, TriggerMode.enter);
        if (CheckCollision(other))
        {
            OnGameObjectTrigger.Invoke(other.gameObject);
        }
    }

    IEnumerator LateEnter(Collider other)
    {
        yield return new WaitForEndOfFrame();
        OnExecute(OnTriggerLateEnterEvent, other, TriggerMode.lateEnter);
    }

    private void OnTriggerExit(Collider other)
    {
        OnExecute(OnTriggerExitEvent, other, TriggerMode.exit);
    }

    void OnExecute(UnityEvent eventToInvoke, Collider other, TriggerMode _mode)
    {
        if (CheckCollision(other))
        {
            eventToInvoke.Invoke();
        }
    }

    public bool CheckCollision(Collider other)
    {
        if (other == null) return false;
        switch (whocantrigger)
        {
            case Entities.other:
                return other.GetComponent<GameObject>();
            case Entities.player:
                return other.GetComponent<PlayerModel>();
        }
        return false;
    }
}

public enum Entities //In progress
{
    player,
    other
}

public enum TriggerMode
{
    all,
    enter,
    exit,
    lateEnter
}
