using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
public class SkinHandler : MonoBehaviour
{
    public Material view;
    [Header("Base")]
    public Slider baseHue;
    public Slider baseSat;
    Image baseSatBackground;
    public Slider baseLum;
    [HideInInspector]
    public Color baseColor;
    public Slider baseMetallic;
    public Slider baseSmoothness;


    [Header("Pattern")]
    public Slider patternHue;
    public Slider patternSat;
    Image patternSatBackground;
    public Slider patternLum;
    [HideInInspector]
    public Color patternColor;
    public Slider patternIntensity;
    public TMP_Dropdown patternType;

    [Header("Clothes")]
    public Slider clothesHue;
    public Slider clothesSat;
    Image clothesSatBackground;
    public Slider clothesLum;
    [HideInInspector]
    public Color clothesColor;
    public Slider clothesMetallic;
    public Slider clothesSmoothness;
    public TMP_Dropdown clothesType;

    [Header("Images")]
    public Texture2D version1;
    public Texture2D version2;
    public Texture2D version3;

    void Start()
    {
        baseSatBackground = baseSat.GetComponentInChildren<Image>();
        patternSatBackground = patternSat.GetComponentInChildren<Image>();
        clothesSatBackground = clothesSat.GetComponentInChildren<Image>();
                
    }
    #region Sliders
    //Public functions
        //Colors
    public void UpdateBaseHue() {
        baseSatBackground.color = Color.HSVToRGB(baseHue.value, 1, 1);
        UpdateBase();
    }
    public void UpdateBaseSat() => UpdateBase();    
    public void UpdateBaseLum() => UpdateBase();

    public void UpdatePatternHue() {
        patternSatBackground.color = Color.HSVToRGB(patternHue.value, 1, 1);
        UpdatePattern();
    }
    public void UpdatePatternSat() => UpdatePattern();
    public void UpdatePatternLum() => UpdatePattern();

    public void UpdateClothesHue() {
        clothesSatBackground.color = Color.HSVToRGB(clothesHue.value, 1, 1);
        UpdateClothes();
    }
    public void UpdateClothesSat() => UpdateClothes();
    public void UpdateClothesLum() => UpdateClothes();
        //Values
    public void UpdateBaseMetallic() {
        view.SetFloat("_PenguinMetallic", baseMetallic.value);
    }
    public void UpdateBaseSmoothness() {
        view.SetFloat("_PenguinSmoothness",baseSmoothness.value);

    }
    public void UpdateIntensity() {
        view.SetFloat("_SkinIntensity", patternIntensity.value);

    }
    public void UpdateClothesMetallic() {
        view.SetFloat("_ClothesMetallic", clothesMetallic.value);
    }
    public void UpdateClothesSmoothness() {
        view.SetFloat("_ClothesSmootness", clothesSmoothness.value);

    }
    
    //Private functions
    void UpdateBase() {
        baseColor = Color.HSVToRGB(baseHue.value, baseSat.value, baseLum.value);
        view.SetColor("_baseColor", baseColor);
    }
    void UpdatePattern() {
        patternColor = Color.HSVToRGB(patternHue.value, patternSat.value, patternLum.value);
        view.SetColor("_patternColor", patternColor);
    }
    void UpdateClothes() {
        clothesColor = Color.HSVToRGB(clothesHue.value, clothesSat.value, clothesLum.value);
        view.SetColor("_clothesColor", clothesColor);
    }
    #endregion

    #region Dropdown
    public void UpdatePatternImage() {
        Texture text = version1;
        switch ( patternType.value) {
            case 0:
            text = version1;
            break;
            case 1:
            text = version2;
            break;
            case 2:
            text = version3;
            break;
        }
        view.SetTexture("_SKin", text);

    }
    public void UpdateClothesImage() {
        Texture text = version1;
        switch ( clothesType.value ) {            
            case 0:
            text = version1;
            break;
            case 1:
            text = version2;
            break;
            case 2:
            text = version3;
            break;
        }
        view.SetTexture("_Clothes", text);

    }
    #endregion

}
