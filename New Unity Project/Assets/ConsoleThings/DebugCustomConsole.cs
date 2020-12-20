using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.Events;

// SHIFT + C = Limpia la consola

public class DebugCustomConsole : MonoBehaviour
{
    public static DebugCustomConsole instance;
    public TextMeshProUGUI text;

    bool enableconsole = true;
    public UnityEvent OnConsoleEnable;
    public UnityEvent OnConsoleDisable;

    /////////////////////////////////////////
    /// UNITY METHODS
    /////////////////////////////////////////
    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
        else
        {
            Destroy(this.gameObject);
        }
        
        DontDestroyOnLoad(this.gameObject);
        enableconsole = true; //esta al revez porque el SwitchEnableConsole me lo vuelve a invertir ahorita mismo o sea ==> true = apagado
        SwitchEnableConsole();

    }
    private void Update()
    {
        if (Input.GetKey(KeyCode.LeftShift) && Input.GetKeyDown(KeyCode.C))
        {
            ClearConsole();
        }
    }
    /////////////////////////////////////////
    /// PUBLICS
    /////////////////////////////////////////
    public void SwitchEnableConsole()
    {
        enableconsole = !enableconsole;
        if (enableconsole) OnConsoleEnable.Invoke();
        else OnConsoleDisable.Invoke();
    }
    public void ClearConsole() { text.text = ""; }
    public static void Log(string debugText, bool force_to_open_console = false) { Color color = Color.white; instance.LogConsole(debugText, color, force_to_open_console); }
    public static void Log(string debugText, Color _color, bool force_to_open_console = false) { instance.LogConsole(debugText, _color, force_to_open_console); }

    /////////////////////////////////////////
    /// PRIVATES
    /////////////////////////////////////////
    void LogConsole(string val, Color _color, bool forceOpenConsole = false)
    {
        if (forceOpenConsole)
        {
            enableconsole = false; //esta al revez porque el SwitchEnableConsole me lo vuelve a invertir ahorita mismo
            SwitchEnableConsole();
            text.text += "\n> " + "<color=" + ToRGBHex(_color) + ">" + val + "</color>";
        }
        else
        {
            if (enableconsole)
            {
                text.text += "\n> " + "<color=" + ToRGBHex(_color) + ">" + val + "</color>";
            }
        }
    }
    public static string ToRGBHex(Color c) => string.Format("#{0:X2}{1:X2}{2:X2}", ToByte(c.r), ToByte(c.g), ToByte(c.b));
    private static byte ToByte(float f)
    {
        f = Mathf.Clamp01(f);
        return (byte)(f * 255);
    }
}

